
DROP FUNCTION minor_week(smallint, smallint);
CREATE FUNCTION minor_week(smallint, smallint) RETURNS smallint
	AS 'SELECT min(distinct(week_no)) FROM ss_cat_time WHERE year_no=$1 AND period_no=$2 '
	LANGUAGE sql;

DROP FUNCTION get_week_no(smallint, smallint, smallint);
CREATE FUNCTION get_week_no(smallint, smallint, smallint) RETURNS smallint
	AS 'SELECT week_no FROM ss_cat_time WHERE (week_no - minor_week($1, $2) + 1)=$3 '
	LANGUAGE sql;

DROP FUNCTION current_week_no();
CREATE FUNCTION current_week_no() RETURNS smallint
	AS 'SELECT week_no FROM ss_cat_time WHERE date_id = CURRENT_DATE'
	LANGUAGE sql;


-- Nueva funciones para obtener periodos y semanas
DROP FUNCTION get_year(timestamp);
CREATE FUNCTION get_year(timestamp) RETURNS smallint
	AS 'SELECT year_no FROM ss_cat_time WHERE date_id=$1'
	LANGUAGE sql;

DROP FUNCTION get_period(timestamp);
CREATE FUNCTION get_period(TIMESTAMP) RETURNS smallint
	AS 'SELECT period_no FROM ss_cat_time WHERE date_id=$1'
	LANGUAGE sql;

DROP FUNCTION get_week(TIMESTAMP);
CREATE FUNCTION get_week(TIMESTAMP) RETURNS int
	AS 'SELECT week_no - minor_week(get_year($1), get_period($1)) + 1 FROM ss_cat_time
	WHERE date_id=$1'
	LANGUAGE sql;


-- Ya definidas en Transfers
DROP FUNCTION current_year();
CREATE FUNCTION current_year() RETURNS smallint
	AS 'SELECT year_no FROM ss_cat_time WHERE date_id=current_date'
	LANGUAGE sql;

DROP FUNCTION current_period();
CREATE FUNCTION current_period() RETURNS smallint
	AS 'SELECT period_no FROM ss_cat_time WHERE date_id=current_date'
	LANGUAGE sql;


DROP FUNCTION current_week();
CREATE FUNCTION current_week() RETURNS int
	AS 'SELECT week_no - minor_week(current_year(), current_period()) + 1 FROM ss_cat_time
	WHERE date_id=current_date'
	LANGUAGE sql;

DROP FUNCTION current_day();
CREATE FUNCTION current_day() RETURNS int
	AS 'SELECT weekday_id-1 FROM ss_cat_time where date_id = current_date'
	LANGUAGE sql;


DROP FUNCTION isnull(float,float) ;
CREATE FUNCTION "isnull"(float, float) RETURNS float
    AS 'SELECT (CASE WHEN $1 IS NULL THEN $2 ELSE $1 END)'
    LANGUAGE sql;

