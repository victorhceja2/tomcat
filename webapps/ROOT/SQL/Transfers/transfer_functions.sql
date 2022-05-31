
--DROP FUNCTION current_year();
CREATE FUNCTION current_year() RETURNS smallint
	AS 'SELECT year_no FROM ss_cat_time WHERE date_id=current_date'
	LANGUAGE sql;

--DROP FUNCTION current_period();
CREATE FUNCTION current_period() RETURNS smallint
	AS 'SELECT period_no FROM ss_cat_time WHERE date_id=current_date'
	LANGUAGE sql;

--DROP FUNCTION minor_week(smallint, smallint);
CREATE FUNCTION minor_week(smallint, smallint) RETURNS smallint
	AS 'SELECT min(distinct(week_no)) FROM ss_cat_time WHERE year_no=$1 AND period_no=$2 '
	LANGUAGE sql;

--DROP FUNCTION current_week();
CREATE FUNCTION current_week() RETURNS int
	AS 'SELECT week_no - minor_week(current_year(), current_period()) + 1 FROM ss_cat_time
	WHERE date_id=current_date'
	LANGUAGE sql;

--DROP FUNCTION current_day();
CREATE FUNCTION current_day() RETURNS int
	AS 'SELECT weekday_id-1 FROM ss_cat_time where date_id = current_date'
	LANGUAGE sql;


