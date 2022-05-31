
DROP FUNCTION get_week_no(smallint, smallint, smallint);
CREATE FUNCTION get_week_no(smallint, smallint, smallint) RETURNS smallint
	AS 'SELECT week_no FROM ss_cat_time WHERE (week_no - minor_week($1, $2) + 1)=$3 '
	LANGUAGE sql;

--DROP FUNCTION current_week_no();
CREATE FUNCTION current_week_no() RETURNS smallint
	AS 'SELECT week_no FROM ss_cat_time WHERE date_id = CURRENT_DATE'
	LANGUAGE sql;

--DROP FUNCTION get_receptions(char);
CREATE FUNCTION get_receptions(char) RETURNS numeric
        AS 'SELECT SUM(receptions) FROM op_inv_inventory_mov WHERE inv_id=$1'
        LANGUAGE sql;

--DROP FUNCTION get_itransfers(char);
CREATE FUNCTION get_itransfers(char) RETURNS numeric
        AS 'SELECT SUM(input_transfers) FROM op_inv_inventory_mov WHERE inv_id=$1'
        LANGUAGE sql;

--DROP FUNCTION get_otransfers(char);
CREATE FUNCTION get_otransfers(char) RETURNS numeric
        AS 'SELECT SUM(output_transfers) FROM op_inv_inventory_mov WHERE inv_id=$1'
        LANGUAGE sql;

-- Nueva funciones para obtener periodos y semanas
--DROP FUNCTION get_year(timestamp);
CREATE FUNCTION get_year(timestamp) RETURNS smallint
	AS 'SELECT year_no FROM ss_cat_time WHERE date_id=$1'
	LANGUAGE sql;

--DROP FUNCTION get_period(timestamp);
CREATE FUNCTION get_period(TIMESTAMP) RETURNS smallint
	AS 'SELECT period_no FROM ss_cat_time WHERE date_id=$1'
	LANGUAGE sql;

DROP FUNCTION get_week(TIMESTAMP);
CREATE FUNCTION get_week(TIMESTAMP) RETURNS int
	AS 'SELECT week_no - minor_week(get_year($1), get_period($1)) + 1 FROM ss_cat_time
	WHERE date_id=$1'
	LANGUAGE sql;



--DROP FUNCTION isnull(float,float) ;

CREATE FUNCTION "isnull"(float, float) RETURNS float
    AS 'SELECT (CASE WHEN $1 IS NULL THEN $2 ELSE $1 END)'
    LANGUAGE sql;


