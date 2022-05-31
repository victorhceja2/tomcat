CREATE TABLE op_invc_cat_inventory_critics (
    inv_id character(6) DEFAULT ''::bpchar NOT NULL,
    inv_desc character varying(30) DEFAULT ''::character varying NOT NULL,
    family_id character(10) DEFAULT ''::bpchar NOT NULL,
    frecuency_id smallint DEFAULT (0)::smallint NOT NULL,
    date_id timestamp without time zone NOT NULL
);

ALTER TABLE ONLY op_invc_cat_inventory_critics
    ADD CONSTRAINT op_invc_cat_inventory_critics_pkey PRIMARY KEY (inv_id);

CREATE TABLE op_invc_step_inventory_critics (
    inv_id character(6) NOT NULL,
    inv_beg numeric(12,2),
    receptions numeric(12,2),
    itransfers numeric(12,2),
    otransfers numeric(12,2),
    prv_inv_end numeric(12,2),
    inv_inv_end numeric(12,2),
    rec_inv_end numeric(12,2),
    inv_end numeric(12,2),
    decreases numeric(12,2),
    ideal_use numeric(12,2),
    real_use numeric(12,2),
    unit_cost numeric(12,2),
    prv_conversion_factor numeric(12,2),
    rcp_conversion_factor numeric(12,2),
    prv_unit_measure character(4),
    inv_unit_measure character(4),
    misc boolean,
    date_id timestamp without time zone NOT NULL,
    year_no smallint NOT NULL,
    period_no smallint NOT NULL,
    week_no smallint NOT NULL
);

ALTER TABLE ONLY op_invc_step_inventory_critics
    ADD CONSTRAINT op_invc_step_inventory_critics_pkey PRIMARY KEY (inv_id, year_no, period_no, week_no, date_id);

ALTER TABLE ONLY op_invc_step_inventory_critics
    ADD CONSTRAINT fk1 FOREIGN KEY (inv_id) REFERENCES op_grl_cat_inventory(inv_id) ON UPDATE CASCADE ON DELETE CASCADE;



CREATE TABLE op_invc_inventory_critics (
    inv_id character(6) NOT NULL,
    inv_beg numeric(12,2),
    receptions numeric(12,2),
    itransfers numeric(12,2),
    otransfers numeric(12,2),
    prv_inv_end numeric(12,2),
    inv_inv_end numeric(12,2),
    rec_inv_end numeric(12,2),
    inv_end numeric(12,2),
    decreases numeric(12,2),
    ideal_use numeric(12,2),
    real_use numeric(12,2),
    unit_cost numeric(12,2),
    prv_conversion_factor numeric(12,2),
    rcp_conversion_factor numeric(12,2),
    prv_unit_measure character(4),
    inv_unit_measure character(4),
    misc boolean,
    date_id timestamp without time zone NOT NULL,
    year_no smallint NOT NULL,
    period_no smallint NOT NULL,
    week_no smallint NOT NULL
);
ALTER TABLE ONLY op_invc_inventory_critics
    ADD CONSTRAINT op_invc_inventory_critics_pkey PRIMARY KEY (inv_id, year_no, period_no, week_no, date_id);

ALTER TABLE ONLY op_invc_inventory_critics
    ADD CONSTRAINT fk1 FOREIGN KEY (inv_id) REFERENCES op_grl_cat_inventory(inv_id) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE TABLE op_invc_close_inv_log
(
  log_id serial NOT NULL,
  date_id timestamp without time zone,
  business_date date
);

ALTER TABLE ONLY op_invc_close_inv_log
    ADD CONSTRAINT op_invc_close_inv_log_pk PRIMARY KEY (log_id);

CREATE TABLE op_invc_configuration (
    configuration_id integer NOT NULL,
    event_desc character varying(32),
    value character varying(64)
);

ALTER TABLE ONLY op_invc_configuration
    ADD CONSTRAINT op_invc_configuration_pk PRIMARY KEY (configuration_id);

CREATE TABLE op_inv_ideal_use (
    turn_date date NOT NULL,
    turn_id smallint NOT NULL,
    inv_id character(6) NOT NULL,
    ideal_use numeric(12,2),
    unit_cost numeric(12,2),
    misc boolean
);

ALTER TABLE ONLY op_inv_ideal_use
    ADD CONSTRAINT op_invc_ideal_use_pkey PRIMARY KEY (turn_date, turn_id, inv_id);


ALTER TABLE ONLY op_inv_ideal_use
    ADD CONSTRAINT fk1 FOREIGN KEY (inv_id) REFERENCES op_grl_cat_inventory(inv_id) ON UPDATE RESTRICT ON DELETE RESTRICT;

DELETE FROM op_invc_configuration;
INSERT INTO op_invc_configuration VALUES (1, 'Hora minima', '20');
INSERT INTO op_invc_configuration VALUES (2, 'Acceso', '0');
INSERT INTO op_invc_configuration VALUES (4, 'Criticos extra', '5');
INSERT INTO op_invc_configuration VALUES (3, 'Fecha anterior', '2021-07-19');

--- INICIO DE NUEVA FUNCION

DROP FUNCTION op_invc_get_acumulated_data(IN timestamp without time zone);
CREATE OR REPLACE FUNCTION op_invc_get_acumulated_data(IN timestamp without time zone)
  RETURNS TABLE(inv_des character varying, inv_be numeric, recep numeric, itransfer numeric, otransfer numeric, prv_inv_end numeric, inv_inv_end numeric, rec_inv_end numeric, inv_total numeric, real_use numeric, ide_use numeric, difference numeric, decrease numeric, difference_money integer, faltant integer, invent_id character, inventory_unit_measure text, prov_conversion_factor numeric, prov_unit_measure text, recipe_conversion_factor numeric, rec_unit_measure text, un_cost numeric, max_variance double precision, min_efficiency double precision, max_efficiency double precision, miscelaneo boolean, week_day integer) AS
$BODY$
DECLARE li_year         SMALLINT;
        li_quarter      SMALLINT;
        li_period       SMALLINT;
        li_week         SMALLINT;
        ld_end_date     TIMESTAMP;
        ld_start_date   TIMESTAMP;
BEGIN

ld_end_date := $1;
li_year := DATE_PART('year', ld_end_date);

SELECT quarter_no, period_no, week_no
INTO li_quarter, li_period, li_week
FROM ss_cat_time
WHERE date_id = ld_end_date;

SELECT date_id INTO ld_start_date
FROM ss_cat_time
WHERE year_no = li_year
AND quarter_no = li_quarter
AND period_no = li_period
AND week_no = li_week
AND weekday_id = 1;

RAISE notice 'Hello--> % % % % %', ld_start_date, ld_end_date, li_quarter, li_period, li_week;

RETURN QUERY
    SELECT DISTINCT
    c.inv_desc,
    ROUND(isnull(tot.i_beg,0.00),2) as inv_beg,
    ROUND(tot.rec,2) as rec,
    ROUND(tot.itran,2) as itran,
    ROUND(tot.otran,2) as otran,
    isnull(i.prv_inv_end,0.00) AS p_end,
    isnull(i.inv_inv_end,0.00) AS i_end,
    isnull(i.rec_inv_end,0.00) AS r_end,
    isnull(i.prv_inv_end,0.00)+isnull(i.inv_inv_end,0)+isnull(i.rec_inv_end,0) AS i_total,
    ISNULL(real_use,0.00) AS r_use,
    ROUND(tot.iuse,2) AS ideal_use,
    ROUND((isnull(tot.i_beg,0.00)+tot.rec+tot.itran-tot.otran-(isnull(i.prv_inv_end,0)+isnull(i.inv_inv_end,0)+isnull(i.rec_inv_end,0))-tot.iuse),2) AS diff,
    ROUND(isnull(tot.dec,0.00),2) AS decreases,
    0 AS diff_money,
    0 AS falt,
    i.inv_id,
    lower(substr(ium.unit_name, 0, 5)) AS ium_unit_measure,
    i.prv_conversion_factor,
    CASE WHEN i.prv_conversion_factor = 0 THEN '' ELSE lower(substr(pum.unit_name,0,5)) END AS pum_unit_name,
    i.rcp_conversion_factor,
    lower(substr(rum.unit_name, 0, 5)) AS rum_unit_measure,
    i.unit_cost,
    isnull(e.max_variance,0.00) AS max_var,
    isnull(e.min_efficiency,0.00) AS mi_efficiency,
    isnull(e.max_efficiency,0.00) AS ma_efficiency,
    i.misc,
    0 AS week
    FROM op_invc_inventory_critics i
    JOIN (
      SELECT inv_id,SUM(inv_beg) as i_beg,sum(receptions) as rec, sum(itransfers) as itran, sum(otransfers) as otran, sum(decreases) as dec, sum(ideal_use) as iuse
      FROM (
        SELECT p.inv_id,0 as inv_beg, 
        SUM(rd.received_quantity*p.conversion_factor)+SUM(isnull(exceptions,0)) AS receptions,  
        0 AS itransfers, 0 AS otransfers, 0 as decreases, 0 as ideal_use
        FROM  op_grl_reception_detail rd 
        INNER JOIN op_grl_reception r 
        ON (r.reception_id = rd.reception_id) 
        INNER JOIN op_grl_cat_providers_product p ON 
        ( p.provider_product_code = rd.provider_product_code AND p.provider_id = rd.provider_id) 
        LEFT JOIN (
                SELECT p.inv_id, 
                SUM(ed.received_quantity*p.conversion_factor) AS exceptions
                FROM op_grl_exception e
                INNER JOIN op_grl_reception r ON r.reception_id = e.reception_id
                INNER JOIN op_grl_exception_detail ed ON ed.exception_id = e.exception_id
                INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = ed.provider_product_code AND p.provider_id = r.provider_id
                INNER JOIN op_grl_cat_unit_measure up ON up.unit_id = p.provider_unit_measure
                WHERE date_trunc('day',e.date_id) BETWEEN ld_start_date AND ld_end_date
                GROUP BY p.inv_id) ex ON (p.inv_id = ex.inv_id)
        WHERE date_trunc('day',date_id) BETWEEN ld_start_date AND ld_end_date 
        GROUP BY p.inv_id,inv_beg
        UNION   
        select td.inv_id, 0 as inv_beg, 0 AS reception, 
        SUM(td.inventory_quantity) AS itransfers, 
        0 AS otransfers, 0 as decreases, 0 as ideal_use FROM  op_grl_transfer_detail td 
        INNER JOIN op_grl_transfer t 
        ON (t.transfer_id = td.transfer_id) WHERE t.transfer_type=1 AND 
        date_trunc('day',t.date_id) 
        BETWEEN ld_start_date AND ld_end_date 
        GROUP BY td.inv_id, inv_beg
        UNION 
        select td.inv_id, 0 as inv_beg, 0 AS reception, 0 AS itransfers ,
        SUM(td.inventory_quantity) AS otransfers, 0 as decreases, 0 as ideal_use
        FROM  op_grl_transfer_detail td 
        INNER JOIN op_grl_transfer t 
        ON (t.transfer_id = td.transfer_id) WHERE t.transfer_type=0 AND  
        date_trunc('day',t.date_id) 
        BETWEEN ld_start_date AND ld_end_date 
        GROUP BY td.inv_id, inv_beg
        UNION
        SELECT inv_id, isnull(inv_beg,0.00) as inv_beg, 0 as receptions, 0 AS itransfers, 0 AS otransfers, 0 as decreases, 0 as ideal_use
        FROM op_invc_inventory_critics 
        WHERE date_id = ld_start_date
        UNION
        SELECT inv_id, 0 as inv_beg, 0 as receptions, 0 AS itransfers, 0 AS otransfers, SUM(decreases) as decreases,0 as ideal_use
        FROM op_invc_inventory_critics 
        WHERE date_trunc('day',date_id) BETWEEN ld_start_date AND ld_end_date
        GROUP BY 1
        UNION
        SELECT inv_id, 0 as inv_beg, 0 as receptions, 0 AS itransfers, 0 AS otransfers, 0 as decreases, SUM(ideal_use) as ideal_use
        FROM op_inv_ideal_use
        WHERE date_trunc('day',turn_date) BETWEEN ld_start_date AND ld_end_date
        GROUP BY inv_id
        ) tots group by 1
    ) tot ON (i.inv_id = tot.inv_id)
    JOIN op_grl_cat_inventory c ON (i.inv_id = c.inv_id)
    JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id)
    JOIN op_grl_cat_unit_measure pum ON(p.provider_unit_measure = pum.unit_id)
    JOIN op_grl_cat_unit_measure ium ON(c.inv_unit_measure = ium.unit_id)
    JOIN op_grl_cat_unit_measure rum ON(c.recipe_unit_measure = rum.unit_id)
    LEFT JOIN op_inv_exceptions e ON (i.inv_id = e.inv_id)
    WHERE p.active_flag IN(1,2)
    AND DATE_TRUNC('day', i.date_id) = ld_end_date
    order by 1;

END; $BODY$
LANGUAGE plpgsql

--- TERMINO DE NUEVA FUNCION

