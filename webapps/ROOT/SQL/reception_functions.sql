/*
 * void load_reception_limits()
 *   
 * Se obtienen las cantidades recibidas de las ultimas 4 recepciones para
 * cada producto de todos los proveedores.
 * 
 *
 * @author  Eduardo Zarate (laliux)
 */
CREATE OR REPLACE FUNCTION load_reception_limits() RETURNS void AS '
    DECLARE
        recep    RECORD;
        results  INTEGER;
    BEGIN
        results  := 0;

        DELETE FROM op_grl_reception_limits;

        FOR recep IN
            SELECT distinct(provider_id) AS provider_id FROM op_grl_reception
        LOOP
            results := load_reception_limits(recep.provider_id);

            RAISE NOTICE ''Provider %, % products ..'', recep.provider_id, results;
        END LOOP;

        return ;
    END
' LANGUAGE plpgsql;

/*
 * int load_reception_limits(text providerId)
 *   
 * Para un proveedor en particular se determinan los productos que 
 * tienen por lo menos 4 recepciones.
 *
 * @author  Eduardo Zarate (laliux)
 * @param   providerId     El id del proveedor
 */
CREATE OR REPLACE FUNCTION load_reception_limits(text) RETURNS int AS '
    DECLARE
        providerId ALIAS FOR $1;
        recep      RECORD;
        results    INTEGER;
    BEGIN
        results  := 0;

        FOR recep IN

            SELECT distinct(p.provider_product_code) AS provider_product_code FROM 
            op_grl_cat_providers_product p INNER JOIN op_grl_reception_detail r 
            ON(p.provider_product_code=r.provider_product_code) 
            WHERE r.provider_id=providerId AND p.reception_limit=1 
            AND p.inv_id IN(SELECT DISTINCT(inv_id) FROM op_inv_inventory_detail) 
            GROUP BY p.provider_product_code HAVING COUNT(received_quantity) >= 4
        
        LOOP
            results := results + load_reception_limits(providerId, recep.provider_product_code);
        END LOOP;

        return results;
    END
' LANGUAGE plpgsql;

/*
 * int load_reception_limits(text providerId, text productId)
 *   
 * Se calculan los limites para un producto en particular en base a las
 * ultimas 4 recepciones.
 *
 * @author  Eduardo Zarate (laliux)
 * @param   providerId     El id del proveedor
 * @param   productId      El codigo de producto del proveedor
 */
CREATE OR REPLACE FUNCTION load_reception_limits(text, text) RETURNS int AS '
    DECLARE
        providerId ALIAS FOR $1;
        productId  ALIAS FOR $2;
        recep      RECORD;
        quantity   NUMERIC;
        results    INTEGER;
    BEGIN
        quantity := 0;
        results  := 0;

        DELETE FROM op_grl_reception_limits WHERE provider_id=providerId 
        AND provider_product_code=productId;

        FOR recep IN
            SELECT received_quantity FROM op_grl_reception_detail WHERE
            provider_id=providerId AND provider_product_code= productId ORDER
            BY reception_id DESC LIMIT 4
        LOOP
            quantity := quantity + recep.received_quantity;
        END LOOP;

            results := results + add_reception_limit(providerId, productId, quantity);

        return results;
    END
' LANGUAGE plpgsql;

/*
 * int add_reception_limit(text providerId, text productId, numeric quantity)
 *   
 * Inserta un registro en la tabla de limites.
 *
 * @author  Eduardo Zarate (laliux)
 * @param   providerId     El id del proveedor
 * @param   productId      El codigo de producto del proveedor
 * @param   quantity       El limite permitido
 */
CREATE OR REPLACE FUNCTION add_reception_limit(text, text, numeric) RETURNS int AS '
    DECLARE
        provider_id  ALIAS FOR $1;
        product_code ALIAS FOR $2;
        quantity     ALIAS FOR $3;
        results      INTEGER;
    BEGIN

        INSERT INTO op_grl_reception_limits VALUES(provider_id, product_code, quantity);

        GET DIAGNOSTICS results=ROW_COUNT;

        return results;
    END
' LANGUAGE plpgsql;
