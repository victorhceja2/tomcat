DROP VIEW IF EXISTS op_pps_vw_suggest;
DROP TABLE IF exists op_pps_app_parameter;
DROP TABLE IF exists op_pps_action_control;
DROP TABLE IF exists op_pps_monitor_ip;
DROP TABLE IF exists op_pps_suggest;
DROP TABLE IF exists op_pps_cook;
DROP TABLE IF exists op_pps_waste;
DROP TABLE IF exists op_pps_wasted;
DROP TABLE IF exists op_pps_mix_product;
DROP TABLE IF exists op_pps_mix;
DROP TABLE IF exists op_pps_preassembly;
DROP TABLE IF exists op_pps_index;
DROP TABLE IF exists op_pps_cat_product;

create table op_pps_app_parameter (
        param_id serial primary key,
        param_key varchar(64),
        param_value varchar(2048)
);


insert into op_pps_app_parameter (param_key, param_value) SELECT 'sus_host','10.10.10.253' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'sus_host') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'open_hour','09:20' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'open_hour') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'close_hour','23:00' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'close_hour') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'schedule_interval','1' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'schedule_interval') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'sales_interval','1' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'sales_interval') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'forecast_interval','5' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'forecast_interval') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'save_relay_interval','1' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'save_relay_interval') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'retry_interval','10' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'retry_interval') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'brand_id','KFC' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'brand_id') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'use_relay','true' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'use_relay') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'clean_hour','6' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'clean_hour') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'use_cook_monitor','false' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'use_cook_monitor') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'refresh_monitor','20' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'refresh_monitor') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'read_cook','10' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'read_cook') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'mix_time','20' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'mix_time') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'use_keyboard','true' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'use_keyboard') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'use_multiple','false' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'use_multiple') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'prepare_delay','false' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'prepare_delay') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'use_waste_monitor','true' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'use_waste_monitor') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'read_wasted','10' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'read_wasted') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'family_code','060' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'family_code') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'personal_code','358' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'personal_code') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'cook_hour','12:30' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'cook_hour') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'family_preassembly','false' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'family_preassembly') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'fcst_rpt_interval','15' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'fcst_rpt_interval') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'pabl_rpt_data','10:00|11:00|13:00,11:00|13:00|14:00,12:00|14:00|15:00,13:00|15:00|16:00,14:00|16:00|17:00,15:00|17:00|18:00,16:00|18:00|19:00,17:00|19:00|21:00,18:00|20:00|21:00,19:00|21:00|22:00' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'pabl_rpt_data') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'uses_sus','true' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'uses_sus') ;
insert into op_pps_app_parameter (param_key, param_value) SELECT 'product_type','1' WHERE NOT EXISTS(SELECT * FROM op_pps_app_parameter WHERE param_key = 'product_type') ;


create table op_pps_monitor_ip (
        ip_id serial primary key,
        ip varchar(50)
);

insert into op_pps_monitor_ip(ip) SELECT '127.0.0.1' WHERE NOT EXISTS(SELECT * FROM op_pps_monitor_ip WHERE ip = '127.0.0.1');
insert into op_pps_monitor_ip(ip) SELECT 'localhost' WHERE NOT EXISTS(SELECT * FROM op_pps_monitor_ip WHERE ip = 'localhost');
insert into op_pps_monitor_ip(ip) SELECT '10.10.10.34' WHERE NOT EXISTS(SELECT * FROM op_pps_monitor_ip WHERE ip = '10.10.10.34');
insert into op_pps_monitor_ip(ip) SELECT '10.10.10.35' WHERE NOT EXISTS(SELECT * FROM op_pps_monitor_ip WHERE ip = '10.10.10.35');


create table op_pps_action_control (
        control_id serial primary key,
        product_id integer,
        action varchar(50),
        quantity integer,
        date_id timestamp,
        ip varchar(50)
);




create table op_pps_index(
        product_id integer,
        sale_index decimal(10,2),
        date_id timestamp
);
create table op_pps_suggest(
        control_id serial primary key,
        product_id integer NOT NULL,
        quantity integer NOT NULL,
        date_id timestamp NOT NULL
);

create table op_pps_waste(
        control_id serial primary key,
        product_id integer NOT NULL,
        quantity integer NOT NULL,
        date_id timestamp NOT NULL
);

create table op_pps_wasted(
        control_id serial primary key,
        product_id integer NOT NULL,
        quantity integer NOT NULL,
        date_id timestamp NOT NULL,
        status integer NOT NULL
);


create table op_pps_cook(
        control_id serial primary key,
        product_id integer NOT NULL,
        quantity integer NOT NULL,
        date_id timestamp NOT NULL,
        status integer NOT NULL

);



create table op_pps_preassembly(
        control_id serial primary key,
        product_id integer NOT NULL,
        quantity integer NOT NULL,
        date_id timestamp NOT NULL,
        status integer NOT NULL

);


CREATE TABLE op_pps_mix_product(
        product_id SMALLINT NOT NULL,
        mix_product_id SMALLINT NOT NULL
);



CREATE TABLE op_pps_mix(
        product_id SMALLINT NOT NULL,
        mix INTEGER
);



CREATE TABLE op_pps_cat_product(
product_id SMALLINT PRIMARY KEY NOT NULL,
product_name VARCHAR(100) NOT NULL,
image_name VARCHAR(50) NOT NULL,
retention_time SMALLINT NOT NULL,
cook_time SMALLINT NOT NULL,
prepare_time SMALLINT NOT NULL,
unit_amount SMALLINT NOT NULL,
unit_desc VARCHAR(50) NOT NULL,
min_cook_amount SMALLINT NOT NULL,
max_cook_amount SMALLINT NOT NULL,
max_prepare_amount SMALLINT NOT NULL,
relay_capacity SMALLINT NOT NULL,
forecast_time SMALLINT NOT NULL,
suggest_time  SMALLINT NOT NULL,
active bit NOT NULL,
interact bit NOT NULL,
cook_monitor bit NOT NULL,
price_unit NUMERIC,
product_type INTEGER,
cook_multiple BIT,
use_trunc BIT
);


CREATE OR REPLACE FUNCTION op_pps_fn_sync_product_table()
  RETURNS VOID AS
$BODY$

DELETE FROM op_pps_cat_product;
INSERT INTO op_pps_cat_product(product_id,product_name,image_name,retention_time,
cook_time,prepare_time,unit_amount,unit_desc,min_cook_amount,max_cook_amount,
max_prepare_amount,relay_capacity,forecast_time,suggest_time,
active,interact,cook_monitor,price_unit,product_type,cook_multiple,use_trunc)
SELECT product_id,product_name,image_name,retention_time,cook_time,prepare_time,
unit_amount,unit_desc,min_cook_amount,max_cook_amount,max_prepare_amount,
relay_capacity,forecast_time,suggest_time,active,interact,cook_monitor,price_unit,product_type,cook_multiple,use_trunc
 FROM dblink('hostaddr='||(SELECT param_Value FROM op_pps_app_parameter
 WHERE param_key = 'sus_host')||' dbname=dbeyum user=postgres','SELECT *
FROM op_pps_cat_product')
AS (product_id SMALLINT,product_name VARCHAR(100),image_name VARCHAR(50), retention_time SMALLINT,
cook_time SMALLINT,
prepare_time SMALLINT,unit_amount SMALLINT,unit_desc VARCHAR(50),min_cook_amount SMALLINT,
max_cook_amount SMALLINT,max_prepare_amount SMALLINT, relay_capacity SMALLINT,
forecast_time SMALLINT, suggest_time SMALLINT, active BIT, interact BIT,
cook_monitor BIT, price_unit NUMERIC,product_type INTEGER,cook_multiple BIT,use_trunc BIT);

$BODY$
  LANGUAGE sql VOLATILE
  COST 100;


 CREATE OR REPLACE FUNCTION ss_grl_fn_create_table_if_not_exists(ps_table_name text, ps_create_table text)
          RETURNS text AS
        $BODY$
        BEGIN

         IF EXISTS (
            SELECT *
            FROM   pg_catalog.pg_tables
            WHERE    tablename  = ps_table_name
            ) THEN
           RETURN 'TABLE ' || '''' || ps_table_name || '''' || ' ALREADY EXISTS';
         ELSE
           EXECUTE ps_create_table;
   RETURN 'CREATED';
         END IF;
         END;
         $BODY$
          LANGUAGE plpgsql VOLATILE
          COST 100;
         ALTER FUNCTION ss_grl_fn_create_table_if_not_exists(text, text)
          OWNER TO postgres;
         SELECT ss_grl_fn_create_table_if_not_exists('op_pps_sold_detail','CREATE TABLE op_pps_sold_detail(  product_id smallint,  quantity numeric,  status_id integer,  date_id date,  hour_id time without time zone)');;


SELECT ss_grl_fn_create_table_if_not_exists('op_pps_relay','
create table op_pps_relay(
        control_id text primary key,
        product_id integer,
        amount integer,
        time integer,
        status integer,
        sorter integer,
        date_id timestamp
);');


CREATE OR REPLACE FUNCTION ss_grl_fn_get_days_from_sql_member(IN text)
  RETURNS TABLE(date_id timestamp without time zone, date_desc date, year_no smallint, quarter_no smallint, period_no smallint, week_no
 smallint, weekday_id smallint, time_member_out text, itemvalue_out text) AS
$BODY$
DECLARE
        ps_time ALIAS FOR $1;

BEGIN

        RETURN QUERY

SELECT * FROM (
 SELECT  m1.date_id, CAST( m1.date_id AS date), m1.year_no, m1.quarter_no,m1.period_no, m1.week_no, m1.weekday_id,
     RTRIM(CAST(m1.year_no AS VARCHAR)) || '.' || RTRIM(CAST(m1.quarter_no AS VARCHAR)) || '.' || RTRIM(CAST(m1.period_no AS VARCHAR))
     || '.' || RTRIM(CAST(m1.week_no AS VARCHAR)) || '.' || REPLACE(CAST(CAST(m1.date_id AS DATE) AS TEXT),'-','') AS time_member
  FROM   dblink('hostaddr='||(SELECT param_value FROM op_pps_app_parameter WHERE param_key = 'sus_host')||' dbname=dbeyum user=postgres
 ' ,'SELECT * FROM ss_cat_time')
  AS m1(date_id TIMESTAMP,weekday_id SMALLINT, year_no SMALLINT, quarter_no SMALLINT,period_no SMALLINT, week_no SMALLINT)
) AS gm1
  inner join (select unnest(string_to_array(ps_time, ',')) AS itemValue) m2 on ('.' || time_member || '.' like '%.' || itemValue || '.%') ;

 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION ss_grl_fn_get_days_from_sql_member(text)
  OWNER TO postgres;


 SELECT ss_grl_fn_create_table_if_not_exists('op_pps_cooked_detail','CREATE TABLE op_pps_cooked_detail (  
 product_id smallint,  quantity numeric, 
 date_id date,  hour_id time without time zone);');


		 