CREATE OR REPLACE FUNCTION ss_grl_fn_create_table_if_not_exists (ps_table_name text, ps_create_table text)
RETURNS text AS
$_$
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
$_$ LANGUAGE plpgsql;


SELECT ss_grl_fn_create_table_if_not_exists('op_wco_app_parameter','
CREATE TABLE op_wco_app_parameter
(
  param_id serial NOT NULL,
  param_key character varying(64),
  param_value character varying(2048),
  CONSTRAINT op_wco_app_parameter_pkey PRIMARY KEY (param_id)
);');

insert into op_wco_app_parameter (param_key, param_value) 
select 'sus_host','10.10.10.253' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='sus_host');
insert into op_wco_app_parameter (param_key, param_value) 
select 'type','2' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='type');
insert into op_wco_app_parameter (param_key, param_value) 
select 'brand_id','KFC' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='brand_id');
insert into op_wco_app_parameter (param_key, param_value)
select 'use_pkds','true' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='use_pkds');
insert into op_wco_app_parameter (param_key, param_value) 
select 'delivery_destinations','2' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='delivery_destinations');
insert into op_wco_app_parameter (param_key, param_value) 
select 'home_destinations','1,3,4' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='home_destinations');
insert into op_wco_app_parameter (param_key, param_value) 
select 'trx_interval','1' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='trx_interval');
insert into op_wco_app_parameter (param_key, param_value) 
select 'with_home','true' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='with_home');
insert into op_wco_app_parameter (param_key, param_value) 
select 'use_qsr','false' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='use_qsr');
insert into op_wco_app_parameter (param_key, param_value) 
select 'qsr_host','10.10.10.10' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='qsr_host');
insert into op_wco_app_parameter (param_key, param_value) 
select 'refresh_time','60' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key='refresh_time');
INSERT INTO op_wco_app_parameter(param_key,param_value)
SELECT 'aloha_host','127.0.0.1' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key = 'aloha_host');
INSERT INTO op_wco_app_parameter(param_key,param_value)
SELECT 'use_aloha','false' WHERE NOT EXISTS(SELECT * FROM op_wco_app_parameter WHERE param_key = 'use_aloha');

