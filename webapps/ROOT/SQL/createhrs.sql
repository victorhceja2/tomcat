-- PostgreSQL database dump

DROP TABLE op_call_out_step;
DROP INDEX pk_dat_rpts;
DROP TABLE gc_stats_dat;
DROP TABLE sus_report_codes;
CREATE TABLE sus_report_codes (
    code_id smallint default '0' NOT NULL,
    desc_dat varchar(15) default NULL,
    PRIMARY KEY (code_id)
    );

CREATE UNIQUE INDEX pk_rpts ON sus_report_codes(code_id);

DROP INDEX pk_rpts;
CREATE TABLE gc_stats_dat (
	code_id smallint default '0' NOT NULL,
    date_id date default '1970-01-01' NOT NULL,
	tot_trans decimal(9,2) default '0.00' NOT NULL,
	PRIMARY KEY (code_id,date_id),
    FOREIGN KEY (code_id) REFERENCES sus_report_codes (code_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
	);

CREATE UNIQUE INDEX pk_dat_rpts ON gc_stats_dat (code_id, date_id);

--DROP INDEX pk_trans;
--DROP TABLE gc_trans_for_time;
--CREATE TABLE gc_trans_for_time (
   --date_id date default '1970-01-01' NOT NULL,
   --hour_id time default '00:00:00' NOT NULL,
   --transc integer default '0' NOT NULL,
   --PRIMARY KEY (date_id,hour_id)
   --);

--CREATE UNIQUE INDEX pk_trans ON gc_trans_for_time (date_id, hour_id);

CREATE TABLE op_call_out_step (
    phone character varying(25),
    line character(2) DEFAULT '0'::bpchar NOT NULL,
    hour_b time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    hour_e time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    duration_call time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    date_id date DEFAULT '1970-01-01'::date NOT NULL
);


