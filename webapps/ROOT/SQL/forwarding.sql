CREATE TABLE op_grl_invtran (
    inv_id character(6) NOT NULL,
    quantity double precision
);

ALTER TABLE ONLY op_grl_invtran ADD CONSTRAINT op_grl_invtran_pkey PRIMARY KEY (inv_id);

CREATE TABLE op_grl_cat_forwarding (
    forwarding_id character(2) DEFAULT '0'::bpchar NOT NULL,
    forw_desc character varying(20) DEFAULT ''::character varying NOT NULL
);

ALTER TABLE op_grl_step_reception_detail ADD COLUMN forwarding_id varchar(2);               
ALTER TABLE op_grl_reception_detail ADD COLUMN forwarding_id varchar(2);               
ALTER TABLE op_grl_cat_config_difference ADD COLUMN active_flag varchar(2);               

ALTER TABLE op_grl_cat_forwarding ADD CONSTRAINT forwarding_id_pk PRIMARY KEY (forwarding_id); 

INSERT INTO op_grl_cat_forwarding VALUES (0,'No reenviar');
INSERT INTO op_grl_cat_forwarding VALUES (1,'Reenviar');
INSERT INTO op_grl_cat_forwarding VALUES (3,'Ninguno');
INSERT INTO op_grl_cat_forwarding VALUES (4,'No aplica');

INSERT INTO op_grl_cat_difference VALUES ('15','Negado');
INSERT INTO op_grl_cat_difference VALUES ('16','Faltante en almacen');
INSERT INTO op_grl_cat_difference VALUES ('17','Sobrante no esta en remision');
INSERT INTO op_grl_cat_difference VALUES ('18','Producto en malas condiciones');
INSERT INTO op_grl_cat_difference VALUES ('19','Caducidad corta/caduco');
INSERT INTO op_grl_cat_difference VALUES ('20','Producto equivocado');

INSERT INTO op_grl_cat_config_difference VALUES (1,'15',22);
INSERT INTO op_grl_cat_config_difference VALUES (1,'16',23);
INSERT INTO op_grl_cat_config_difference VALUES (1,'17',24);
INSERT INTO op_grl_cat_config_difference VALUES (1,'18',25);
INSERT INTO op_grl_cat_config_difference VALUES (1,'19',26);
INSERT INTO op_grl_cat_config_difference VALUES (1,'20',27);

INSERT INTO op_grl_cat_config_difference VALUES (2,'15',22);
INSERT INTO op_grl_cat_config_difference VALUES (2,'16',23);
INSERT INTO op_grl_cat_config_difference VALUES (2,'17',24);
INSERT INTO op_grl_cat_config_difference VALUES (2,'18',25);
INSERT INTO op_grl_cat_config_difference VALUES (2,'19',26);
INSERT INTO op_grl_cat_config_difference VALUES (2,'20',27);

INSERT INTO op_grl_cat_config_difference VALUES (3,'15',22);
INSERT INTO op_grl_cat_config_difference VALUES (3,'16',23);
INSERT INTO op_grl_cat_config_difference VALUES (3,'17',24);
INSERT INTO op_grl_cat_config_difference VALUES (3,'18',25);
INSERT INTO op_grl_cat_config_difference VALUES (3,'19',26);
INSERT INTO op_grl_cat_config_difference VALUES (3,'20',27);

INSERT INTO op_grl_cat_config_difference VALUES (4,'15',22);
INSERT INTO op_grl_cat_config_difference VALUES (4,'16',23);
INSERT INTO op_grl_cat_config_difference VALUES (4,'17',24);
INSERT INTO op_grl_cat_config_difference VALUES (4,'18',25);
INSERT INTO op_grl_cat_config_difference VALUES (4,'19',26);
INSERT INTO op_grl_cat_config_difference VALUES (4,'20',27);

INSERT INTO op_grl_cat_config_difference VALUES (5,'15',22);
INSERT INTO op_grl_cat_config_difference VALUES (5,'16',23);
INSERT INTO op_grl_cat_config_difference VALUES (5,'17',24);
INSERT INTO op_grl_cat_config_difference VALUES (5,'18',25);
INSERT INTO op_grl_cat_config_difference VALUES (5,'19',26);
INSERT INTO op_grl_cat_config_difference VALUES (5,'20',27);

INSERT INTO op_grl_cat_config_difference VALUES (6,'15',22);
INSERT INTO op_grl_cat_config_difference VALUES (6,'16',23);
INSERT INTO op_grl_cat_config_difference VALUES (6,'17',24);
INSERT INTO op_grl_cat_config_difference VALUES (6,'18',25);
INSERT INTO op_grl_cat_config_difference VALUES (6,'19',26);
INSERT INTO op_grl_cat_config_difference VALUES (6,'20',27);

UPDATE op_grl_cat_config_difference SET active_flag = 'N';
UPDATE op_grl_cat_config_difference SET active_flag = 'Y' WHERE difference_id IN ('0','15','16','17','18','19','20');

CREATE OR REPLACE FUNCTION num_forwarding(integer)
  RETURNS integer AS '
  	SELECT CAST(COUNT(*) AS int) FROM op_grl_reception_detail WHERE reception_id = $1 AND forwarding_id like ''1%'';
  'LANGUAGE 'sql' VOLATILE
  COST 100;
ALTER FUNCTION num_forwarding(integer) OWNER TO postgres;

CREATE OR REPLACE FUNCTION forwarding_exists(integer)
  RETURNS boolean AS '
	SELECT (CASE WHEN num_forwarding($1) > 0 THEN TRUE ELSE FALSE END);
  'LANGUAGE 'sql' VOLATILE
  COST 100;
ALTER FUNCTION diff_exists(integer) OWNER TO postgres;

CREATE OR REPLACE FUNCTION get_forwarding(integer, character varying)
  RETURNS character varying AS '
	SELECT (CASE WHEN forwarding_exists($1) THEN ''Con reenvio'' ELSE $2 END)
  'LANGUAGE 'sql' VOLATILE
  COST 100;
ALTER FUNCTION get_report_num(integer, character varying) OWNER TO postgres;
