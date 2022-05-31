

-- Calculo del inventario final en tabla de paso
CREATE OR REPLACE FUNCTION update_inv_end (text) RETURNS NUMERIC 
AS '
    DECLARE 
        tableName   ALIAS FOR $1;
        results     INTEGER;
    BEGIN
        EXECUTE ''UPDATE ''||tableName||'' SET inv_end = inv_inv_end+prv_inv_end*prv_conversion_factor+rec_inv_end/rcp_conversion_factor'';

        GET DIAGNOSTICS results=ROW_COUNT;

        return results;
    END        
' LANGUAGE plpgsql;


-- Calculo del uso ideal en tabla de paso. Pone uso ideal igual a uso real
-- en productos miscelaneos.

--DROP FUNCTION update_ideal_use ();
CREATE OR REPLACE FUNCTION update_ideal_use (text) RETURNS NUMERIC 
AS '
    DECLARE 
        tableName   ALIAS FOR $1;
        results     INTEGER;
    BEGIN
        EXECUTE ''UPDATE '' || tableName || '' SET ideal_use = real_use WHERE misc = true'';

        GET DIAGNOSTICS results=ROW_COUNT;

        return results;
    END
' LANGUAGE plpgsql;


-- Calculo del uso real en tablas de detalle de inventario
-- inv ini + recep + trans ent - trans sal - inv final

--DROP FUNCTION update_real_use ();
CREATE OR REPLACE FUNCTION update_real_use (text) RETURNS NUMERIC 
AS '
    DECLARE 
        tableName   ALIAS FOR $1;
        results     INTEGER;
    BEGIN
        EXECUTE ''UPDATE '' || tableName || '' SET real_use = inv_beg + receptions + itransfers - otransfers - inv_end'';

        GET DIAGNOSTICS results=ROW_COUNT;
        PERFORM update_ideal_use(tableName);

        return results;
    END
' LANGUAGE plpgsql;


-- Registra TODOS los movimientos de recepciones en inventario. Esta funcion
-- reemplaza todos los valores de recepciones por los nuevos.

CREATE OR REPLACE FUNCTION add_receptions_inv(int, int, int) RETURNS void AS '
    DECLARE 
        liYear       ALIAS FOR $1;
        liPeriod     ALIAS FOR $2;
        liWeek       ALIAS FOR $3;

        liWeekNo   INTEGER;
        recep      RECORD;
    BEGIN
        liWeekNo := get_week_no(liYear, liPeriod, liWeek);

        UPDATE op_inv_inventory_detail 
            SET receptions = 0 WHERE year_no=liYear AND period_no=liPeriod 
            AND week_no = liWeek;

        FOR recep IN 
            SELECT reception_id AS id FROM op_grl_reception 
            WHERE date_trunc(''day'',date_id) IN(SELECT date_trunc(''day'',date_id) 
            FROM ss_cat_time WHERE year_no=liYear AND period_no=liPeriod AND week_no=liWeekNo)
            LOOP
                PERFORM add_reception_inv(recep.id, liYear, liPeriod, liWeek);
        END LOOP;

        RETURN ;
    END
' LANGUAGE plpgsql;

-- Registra TODOS los movimientos de transferencias de entrada en inventario. 
-- Esta funcion reemplaza todos los valores de transferencias.

CREATE OR REPLACE FUNCTION add_itransfers_inv(int, int, int) RETURNS void AS '
    DECLARE 
        liYear      ALIAS FOR $1;
        liPeriod    ALIAS FOR $2;
        liWeek      ALIAS FOR $3;

        liWeekNo    INTEGER;
        transfer    RECORD;
    BEGIN
        liWeekNo := get_week_no(liYear, liPeriod, liWeek);

        UPDATE op_inv_inventory_detail 
            SET itransfers = 0 
            WHERE year_no=liYear AND period_no=liPeriod AND week_no = liWeek;

        FOR transfer IN 
            SELECT transfer_id AS id FROM op_grl_transfer 
            WHERE transfer_type=1 AND date_trunc(''day'',date_id) 
            IN(SELECT date_trunc(''day'',date_id) FROM ss_cat_time 
               WHERE year_no=liYear AND period_no=liPeriod AND week_no=liWeekNo)
            LOOP
                PERFORM add_itransfer_inv(transfer.id, liYear, liPeriod, liWeek);
        END LOOP;

        RETURN ;
    END
' LANGUAGE plpgsql;


-- Registra TODOS los movimientos de transferencias de salida en inventario. 
-- Esta funcion reemplaza todos los valores de transferencias existentes.

CREATE OR REPLACE FUNCTION add_otransfers_inv(int, int, int) RETURNS void AS '
    DECLARE 
        liYear      ALIAS FOR $1;
        liPeriod    ALIAS FOR $2;
        liWeek      ALIAS FOR $3;

        liWeekNo    INTEGER;
        transfer    RECORD;
    BEGIN
        liWeekNo := get_week_no(liYear, liPeriod, liWeek);

        UPDATE op_inv_inventory_detail 
            SET otransfers = 0 
            WHERE year_no=liYear AND period_no=liPeriod AND week_no=liWeek;

        FOR transfer IN 
            SELECT transfer_id AS id FROM op_grl_transfer 
            WHERE transfer_type=0 AND date_trunc(''day'',date_id) 
            IN(SELECT date_trunc(''day'',date_id) FROM ss_cat_time 
               WHERE year_no=liYear AND period_no=liPeriod AND week_no=liWeekNo)
            LOOP
                PERFORM add_otransfer_inv(transfer.id, liYear, liPeriod, liWeek);
        END LOOP;

        RETURN ;
    END
' LANGUAGE plpgsql;

/*
 * int add_reception_inv(int receptionId)
 *
 * Registra los movimientos de una recepcion en inventario.
 * Si no se especifica el anio, periodo y semana, se calculan estos
 * en base a la fecha de la recepcion.
 * 
 * @author  Eduardo Zarate (laliux)
 * @param   receptionId     El id de la recepcion
 *
 * @return  El numero de productos de la recepcion.
 */ 
CREATE OR REPLACE FUNCTION add_reception_inv(int) RETURNS INTEGER AS '
    DECLARE 
        recep   RECORD;
    BEGIN
        
        SELECT INTO recep * FROM get_reception_date($1) 
            AS (id integer, year smallint, period smallint, week integer);

        if recep.id > 0 THEN
            return add_reception_inv(recep.id, recep.year, recep.period, recep.week);
        else
            return 0;
        end if;            

    END
' LANGUAGE plpgsql;

/*
 * int add_itransfer_inv(int transferId)
 *
 * Registra los movimientos de una transferencia de entrada en inventario
 * Si no se especifica el anio, periodo y semana, se calculan estos valores
 * de acuerdo a la fecha de la transferencia.
 *
 * @author  Eduardo Zarate (laliux)
 * @param   transferId      El id de la transferencia.
 *
 * @return  El numero de productos de la transferencia.
 */
CREATE OR REPLACE FUNCTION add_itransfer_inv(int) RETURNS INTEGER AS '
    DECLARE 
        transfer    RECORD;
    BEGIN

        SELECT INTO transfer * FROM get_transfer_date($1) 
            AS (id integer, year smallint, period smallint, week integer);

        IF transfer.id > 0 THEN
            return add_itransfer_inv(transfer.id, transfer.year, transfer.period, transfer.week);
        ELSE
            return 0;
        END IF;            

    END
' LANGUAGE plpgsql;

/*
 * int add_otransfer_inv(int transferId)
 *
 * Registra los movimientos de una transferencia de salida en inventario.
 * Si no se especifica el anio, periodo y semana, se calculan estos valores
 * de acuerdo a la fecha de la transferencia.
 *
 * @author  Eduardo Zarate (laliux)
 * @param   transferId      El id de la transferencia.
 *
 * @return  El numero de productos de la transferencia.
 */
CREATE OR REPLACE FUNCTION add_otransfer_inv(int) RETURNS INTEGER AS '
    DECLARE 
        transfer    RECORD;
    BEGIN
        
        SELECT INTO transfer * FROM get_transfer_date($1) 
            AS (id integer, year smallint, period smallint, week integer);

        IF transfer.id > 0 THEN
            return add_otransfer_inv(transfer.id, transfer.year, transfer.period, transfer.week);
        ELSE
            return 0;
        END IF;            
    END
' LANGUAGE plpgsql;

/*
 * int add_reception_inv(int receptionId, int year, int period, int week)
 *
 * Registra los movimientos de una recepcion en inventario
 *
 * @author  Eduardo Zarate (laliux)
 * @param   receptionId     El id de la recepcion
 * @param   year            El anio YYYY yum.
 * @param   period          El el periodo P yum.
 * @param   week            La semana W yum.
 *
 * @return  El numero de productos de la recepcion.
 */
CREATE OR REPLACE FUNCTION add_reception_inv(int, int, int, int) RETURNS INTEGER AS '
    DECLARE 
        recep_id    ALIAS FOR $1;
        year_no     ALIAS FOR $2;
        period_no   ALIAS FOR $3;
        week_no     ALIAS FOR $4;

        recep       RECORD;
        results     INTEGER;
    BEGIN
        
        DELETE FROM op_inv_inventory_mov;

        results := insert_reception_mov(recep_id);

        IF results > 0 THEN
           
            -- Toma los valores de recepcion que se encuentran en la 
            -- tabla de movimientos y los agrega a inventario. La suposicion es que
            -- solo hay UNA recepcion

        UPDATE op_inv_inventory_detail 
            SET receptions = op_inv_inventory_detail.receptions+mov.receptions 
            FROM op_inv_inventory_mov mov WHERE op_inv_inventory_detail.inv_id=mov.inv_id 
            AND op_inv_inventory_detail.year_no= year_no  
            AND op_inv_inventory_detail.period_no=period_no 
            AND op_inv_inventory_detail.week_no= week_no;

        GET DIAGNOSTICS results=ROW_COUNT;

        RAISE NOTICE ''Reception % addedd % records'', recep_id, results;

            return results;

        ELSE
            return 0;
        END IF;

    END
' LANGUAGE plpgsql;


-- Registra los movimientos de una transferencia de entrada en inventario
CREATE OR REPLACE FUNCTION add_itransfer_inv(int, int, int, int) RETURNS INTEGER AS '
    DECLARE 
        liTransferId    ALIAS FOR $1;
        liYear          ALIAS FOR $2;
        liPeriod        ALIAS FOR $3;
        liWeek          ALIAS FOR $4;

        results         INTEGER;
    BEGIN
        
        DELETE FROM op_inv_inventory_mov;

        results := insert_itransfer_mov(liTransferId);

        IF results > 0 THEN
           
            -- Toma los valores de la transferencia de entrada que se encuentran en la 
            -- tabla de movimientos y los agrega a inventario. La suposicion es que
            -- solo hay UNA transferencia.

        UPDATE op_inv_inventory_detail 
            SET itransfers = op_inv_inventory_detail.itransfers+mov.input_transfers  
            FROM op_inv_inventory_mov mov WHERE op_inv_inventory_detail.inv_id=mov.inv_id 
            AND op_inv_inventory_detail.year_no= liYear
            AND op_inv_inventory_detail.period_no=liPeriod
            AND op_inv_inventory_detail.week_no= liWeek;

        GET DIAGNOSTICS results=ROW_COUNT;

            return results;

        ELSE
            return 0;
        END IF;

    END
' LANGUAGE plpgsql;


-- Registra los movimientos de una transferencia de SALIDA en inventario
CREATE OR REPLACE FUNCTION add_otransfer_inv(int, int, int, int) RETURNS INTEGER AS '
    DECLARE 
        liTransferId    ALIAS FOR $1;
        liYear          ALIAS FOR $2;
        liPeriod        ALIAS FOR $3;
        liWeek          ALIAS FOR $4;

        results         INTEGER;
    BEGIN
        
        DELETE FROM op_inv_inventory_mov;

        results := insert_otransfer_mov(liTransferId);

        IF results > 0 THEN
           
            -- Toma los valores de la transferencia de salida que se encuentran en la 
            -- tabla de movimientos y los agrega a inventario. La suposicion es que
            -- solo hay UNA transferencia.

        UPDATE op_inv_inventory_detail 
            SET otransfers = op_inv_inventory_detail.otransfers+mov.output_transfers  
            FROM op_inv_inventory_mov mov WHERE op_inv_inventory_detail.inv_id=mov.inv_id 
            AND op_inv_inventory_detail.year_no= liYear
            AND op_inv_inventory_detail.period_no=liPeriod
            AND op_inv_inventory_detail.week_no= liWeek;

        GET DIAGNOSTICS results=ROW_COUNT;

            return results;

        ELSE
            return 0;
        END IF;

    END
' LANGUAGE plpgsql;

-- Resta (quita) los movimientos de una recepcion del inventario.
-- Si no se especifica el anio, periodo y semana, esto se calculan
-- en base a la fecha de la recepcion
CREATE OR REPLACE FUNCTION remove_reception_inv(int) RETURNS INTEGER AS '
    DECLARE 
        recep       RECORD;
    BEGIN
        
        SELECT INTO recep * FROM get_reception_date($1) 
            AS (id integer, year smallint, period smallint, week integer);

        IF recep.id > 0 THEN
            return remove_reception_inv(recep.id, recep.year, recep.period, recep.week);
        ELSE
            return 0;
        END IF;            

    END
' LANGUAGE plpgsql;

-- Resta (quita) los movimientos de una transferencia de entrada del inventario.
-- Si no se especifica el anio, periodo y semana, se calculan estos valores
-- de acuerdo a la fecha de la transferencia.
CREATE OR REPLACE FUNCTION remove_itransfer_inv(int) RETURNS INTEGER AS '
    DECLARE 
        transfer    RECORD;
    BEGIN

        SELECT INTO transfer * FROM get_transfer_date($1) 
            AS (id integer, year smallint, period smallint, week integer);

        IF transfer.id > 0 THEN
            return remove_itransfer_inv(transfer.id, transfer.year, transfer.period, transfer.week);
        ELSE
            return 0;
        END IF;            

    END
' LANGUAGE plpgsql;

-- Resta (quita) los movimientos de una transferencia de salida del inventario
-- Si no se especifica el anio, periodo y semana, se calculan estos valores
-- de acuerdo a la fecha de la transferencia.
CREATE OR REPLACE FUNCTION remove_otransfer_inv(int) RETURNS INTEGER AS '
    DECLARE 
        transfer    RECORD;
    BEGIN
        
        SELECT INTO transfer * FROM get_transfer_date($1) 
            AS (id integer, year smallint, period smallint, week integer);

        IF transfer.id > 0 THEN
            return remove_otransfer_inv(transfer.id, transfer.year, transfer.period, transfer.week);
        ELSE
            return 0;
        END IF;            
    END
' LANGUAGE plpgsql;



-- Resta (quita) los movimientos de una recepcion del inventario.
-- Requiere el ID de la recepcion y el anio, periodo y semana del inventario.
CREATE OR REPLACE FUNCTION remove_reception_inv(int, int, int, int) RETURNS INTEGER AS '
    DECLARE 
        recep_id    ALIAS FOR $1;
        year_no     ALIAS FOR $2;
        period_no   ALIAS FOR $3;
        week_no     ALIAS FOR $4;

        results     INTEGER;
    BEGIN
        
        DELETE FROM op_inv_inventory_mov;

        results := insert_reception_mov(recep_id);

        IF results > 0 THEN
           
            -- Toma los valores de recepcion que se encuentran en la 
            -- tabla de movimientos y los resta de inventario. La suposicion es que
            -- solo hay UNA recepcion

        UPDATE op_inv_inventory_detail 
            SET receptions = op_inv_inventory_detail.receptions-mov.receptions 
            FROM op_inv_inventory_mov mov WHERE op_inv_inventory_detail.inv_id=mov.inv_id 
            AND op_inv_inventory_detail.year_no= year_no  
            AND op_inv_inventory_detail.period_no=period_no 
            AND op_inv_inventory_detail.week_no= week_no;

        GET DIAGNOSTICS results=ROW_COUNT;

            return results;

        ELSE
            return 0;
        END IF;

    END
' LANGUAGE plpgsql;


-- Resta (quita) los movimientos de una transferencia de entrada del inventario.
-- Requiere el ID de la transferencia y el anio, periodo y semana del inventario.
CREATE OR REPLACE FUNCTION remove_itransfer_inv(int, int, int, int) RETURNS INTEGER AS '
    DECLARE 
        liTransferId    ALIAS FOR $1;
        liYear          ALIAS FOR $2;
        liPeriod        ALIAS FOR $3;
        liWeek          ALIAS FOR $4;

        results         INTEGER;
    BEGIN
        
        DELETE FROM op_inv_inventory_mov;

        results := insert_itransfer_mov(liTransferId);

        IF results > 0 THEN
           
            -- Toma los valores de la transferencia de entrada que se encuentran en la 
            -- tabla de movimientos y los resta de inventario. La suposicion es que
            -- solo hay UNA transferencia.

        UPDATE op_inv_inventory_detail 
            SET itransfers = op_inv_inventory_detail.itransfers-mov.input_transfers  
            FROM op_inv_inventory_mov mov WHERE op_inv_inventory_detail.inv_id=mov.inv_id 
            AND op_inv_inventory_detail.year_no= liYear
            AND op_inv_inventory_detail.period_no=liPeriod
            AND op_inv_inventory_detail.week_no= liWeek;

        GET DIAGNOSTICS results=ROW_COUNT;

            return results;

        ELSE
            return 0;
        END IF;

    END
' LANGUAGE plpgsql;


-- Resta (quita) los movimientos de una Transferencia de Salida del inventario
-- Requiere el ID de la transferencia y el anio, periodo y semana del inventario.
CREATE OR REPLACE FUNCTION remove_otransfer_inv(int, int, int, int) RETURNS INTEGER AS '
    DECLARE 
        liTransferId    ALIAS FOR $1;
        liYear          ALIAS FOR $2;
        liPeriod        ALIAS FOR $3;
        liWeek          ALIAS FOR $4;

        results         INTEGER;
    BEGIN
        
        DELETE FROM op_inv_inventory_mov;

        results := insert_otransfer_mov(liTransferId);

        IF results > 0 THEN
           
            -- Toma los valores de la transferencia de salida que se encuentran en la 
            -- tabla de movimientos y los resta de inventario. La suposicion es que
            -- solo hay UNA transferencia.

        UPDATE op_inv_inventory_detail 
            SET otransfers = op_inv_inventory_detail.otransfers-mov.output_transfers  
            FROM op_inv_inventory_mov mov WHERE op_inv_inventory_detail.inv_id=mov.inv_id 
            AND op_inv_inventory_detail.year_no= liYear
            AND op_inv_inventory_detail.period_no=liPeriod
            AND op_inv_inventory_detail.week_no= liWeek;

        GET DIAGNOSTICS results=ROW_COUNT;

            return results;

        ELSE
            return 0;
        END IF;

    END
' LANGUAGE plpgsql;



-- Borra una transferencia de entrada de la base de datos.
CREATE OR REPLACE FUNCTION remove_input_transfer(int) RETURNS INTEGER AS '
    DECLARE 
        transferId  ALIAS FOR $1;
        results     integer;
    BEGIN
        results := remove_itransfer_inv(transferId);

        if results > 0 then
            DELETE FROM op_grl_transfer WHERE transfer_type=1 AND transfer_id=transferId;
        
            GET DIAGNOSTICS results=ROW_COUNT;
            return results;
        else
            return 0;
        end if;            
    END
' LANGUAGE plpgsql;

-- Borra una Transferencia de Salida de la base de datos.
CREATE OR REPLACE FUNCTION remove_output_transfer(int) RETURNS INTEGER AS '
    DECLARE 
        transferId  ALIAS FOR $1;
        results     integer;
    BEGIN
        results := remove_otransfer_inv(transferId);

        if results > 0 then
            DELETE FROM op_grl_transfer WHERE transfer_type=0 AND transfer_id=transferId;
        
            GET DIAGNOSTICS results=ROW_COUNT;
            return results;
        else
            return 0;
        end if;            
    END
' LANGUAGE plpgsql;

-- Calcula los valores de una recepcion y pone los datos en la
-- tabla de movimientos.

CREATE OR REPLACE FUNCTION insert_reception_mov(int) RETURNS INTEGER AS '
    DECLARE 
        liRecepId   ALIAS FOR $1;
        results     INTEGER;
    BEGIN
        INSERT INTO op_inv_inventory_mov 
            SELECT p.inv_id, rd.provider_product_code, rd.received_quantity*p.conversion_factor, 0, 0 
            FROM op_grl_cat_providers_product p INNER JOIN op_grl_reception_detail rd 
            ON p.provider_id =rd.provider_id 
            AND p.provider_product_code = rd.provider_product_code 
            WHERE rd.reception_id = liRecepId;

        GET DIAGNOSTICS results=ROW_COUNT;

        return results;
    END
' LANGUAGE plpgsql;


-- Calcula los valores de una Transferencia de Entrada y pone los datos en la
-- tabla de movimientos.

CREATE OR REPLACE FUNCTION insert_itransfer_mov(int) RETURNS INTEGER AS '
    DECLARE 
        liTransferId    ALIAS FOR $1;
        results         INTEGER;
    BEGIN
        INSERT INTO op_inv_inventory_mov 
            SELECT td.inv_id, td.provider_product_code, 0, 
            provider_quantity*prv_conversion_factor+inventory_quantity, 0 
            FROM op_grl_transfer t INNER JOIN op_grl_transfer_detail td 
            ON (t.transfer_id=td.transfer_id) WHERE t.transfer_type=1 AND 
            t.transfer_id = liTransferId ;

        GET DIAGNOSTICS results=ROW_COUNT;

        return results;
    END
' LANGUAGE plpgsql;




-- Calcula los valores de una Transferencia de Salida y pone los datos en la
-- tabla de movimientos.

CREATE OR REPLACE FUNCTION insert_otransfer_mov(int) RETURNS INTEGER AS '
    DECLARE 
        liTransferId    ALIAS FOR $1;
        results         INTEGER;
    BEGIN
        INSERT INTO op_inv_inventory_mov 
            SELECT td.inv_id, td.provider_product_code, 0, 0 ,
            provider_quantity*prv_conversion_factor+inventory_quantity 
            FROM op_grl_transfer t INNER JOIN op_grl_transfer_detail td 
            ON (t.transfer_id=td.transfer_id) WHERE t.transfer_type=0 AND 
            t.transfer_id = liTransferId ;

        GET DIAGNOSTICS results=ROW_COUNT;

        return results;
    END
' LANGUAGE plpgsql;


-- Devuelve el id, el anio, periodo y semana de una recepcion.
CREATE OR REPLACE FUNCTION get_reception_date(int) RETURNS record AS '
    DECLARE 
        recep       RECORD;
    BEGIN
        SELECT INTO recep reception_id,
            get_year  (date_trunc(''day'', date_id)),
            get_period(date_trunc(''day'', date_id)),
            get_week  (date_trunc(''day'', date_id)) 
            FROM op_grl_reception WHERE reception_id = $1;

        RETURN recep;
    END
' LANGUAGE plpgsql;

-- Devuelve el id, el anio, periodo y semana de una transferencia.
CREATE OR REPLACE FUNCTION get_transfer_date(int) RETURNS record AS '
    DECLARE 
        transfer    RECORD;
    BEGIN        
        SELECT INTO transfer transfer_id,
            get_year  (date_trunc(''day'', date_id)), 
            get_period(date_trunc(''day'', date_id)), 
            get_week  (date_trunc(''day'', date_id)) 
            FROM op_grl_transfer WHERE transfer_id = $1;

        return transfer;
    END;        
' LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION init_inventory() RETURNS integer AS '
    DECLARE
        todayYear   integer;
        todayPeriod integer;
        todayWeek   integer;
    BEGIN
        todayYear   := current_year();
        todayPeriod := current_period();
        todayWeek   := current_week();

        return init_inventory(todayYear, todayPeriod, todayWeek);
    END
' LANGUAGE plpgsql;

-- Inicializa inventario
CREATE OR REPLACE FUNCTION init_inventory(int, int, int) RETURNS integer AS '
    DECLARE
        todayYear     ALIAS FOR $1;
        todayPeriod   ALIAS FOR $2;
        todayWeek     ALIAS FOR $3;
        todayWeekNo   integer;
        currentDate     timestamp;
        previousDate    timestamp;
        previous        record;
        today           record;
        results         integer;
    BEGIN
        --Semana actual
        todayWeekNo := get_week_no(todayYear, todayPeriod, todayWeek);
        --SELECT into today currentYear AS year, 
            --currentPeriod AS period, currentWeek AS week , current_week_no() AS week_no;

        SELECT into currentDate date_id FROM ss_cat_time
            WHERE year_no=todayYear AND period_no=todayPeriod
            AND week_no=todayWeekNo ORDER BY date_id DESC LIMIT 1;

        --Semana que acaba de cerrar
        SELECT into previousDate currentDate::date - interval ''7 day'';

        --Anio, periodo y semana que acaban de cerrar
        SELECT into previous get_year(previousDate) AS year, 
            get_period(previousDate) AS period, get_week(previousDate) AS week;

        --Se inicializan datos para la semana actual            
        --Se borra lo que exista
        DELETE FROM op_inv_inventory_detail WHERE year_no=todayYear 
            AND period_no=todayPeriod AND week_no=todayWeek;

        --Se pone inventario CERO en productos que en la semana anterior tengan inv_end NULL
        UPDATE op_inv_inventory_detail SET inv_end=0 WHERE year_no=previous.year AND
            period_no=previous.period AND week_no=previous.week AND inv_end IS NULL;
        
        --Se ponen valores de inventario inicial
        INSERT INTO op_inv_inventory_detail SELECT inv_id, inv_end, 0, 0, 0, 0, 0, 0, 0, 0,
                      0,0,0,prv_conversion_factor, rcp_conversion_factor, prv_unit_measure, 
                      inv_unit_measure,misc,currentDate,todayYear,todayPeriod,todayWeek 
                      FROM op_inv_inventory_detail WHERE 
                      year_no=previous.year AND period_no=previous.period AND week_no=previous.week;

        GET DIAGNOSTICS results=ROW_COUNT;

        --Se cargan recepciones
        PERFORM add_receptions_inv(todayYear, todayPeriod, todayWeek);

        --Se cargan transferencias de entrada
        PERFORM add_itransfers_inv(todayYear, todayPeriod, todayWeek);

        --Se cargan transferencias de salida
        PERFORM add_otransfers_inv(todayYear, todayPeriod, todayWeek);

        return results;
    END
' LANGUAGE plpgsql;



-- Version de function get_week_no con argumentos INTEGER
CREATE OR REPLACE FUNCTION get_week_no(int, int, int) RETURNS smallint 
    AS 'SELECT get_week_no(CAST($1 AS smallint), CAST($2 AS smallint), CAST($3 AS smallint)) '
 LANGUAGE sql;

