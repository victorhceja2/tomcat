DROP TABLE op_call_conm;
CREATE TABLE op_call_conm (
    type_call char(1) default '0' NOT NULL,
    date_id date default '1970-01-01' NOT NULL,
    hour_b time default '00:00:00' NOT NULL,
    phone_line smallint default '0' NOT NULL,
    phone varchar(25) default NULL,
    duration_call time default NULL,  
    phone_ext smallint default NULL,
    dialog_time time default NULL,
    bell_number smallint default NULL,
    phone_up char(1) default NULL,
    PRIMARY KEY (type_call,date_id,hour_b,phone_line,phone)
    );

CREATE UNIQUE INDEX pk_call ON op_call_conm(type_call,date_id,hour_b,phone_line,phone);
DROP TABLE op_call_conf;
CREATE TABLE op_call_conf (
	manager_line smallint default '0' NOT NULL,
	number_lines smallint default '0' NOT NULL,
	init_hour time default '00:00:00' NOT NULL,
	final_hour time default '00:00:00' NOT NULL,
	date_id date default NULL,
	lada varchar(5) default NULL,
	long_phone smallint default NULL,
	PRIMARY KEY (manager_line,number_lines,init_hour,final_hour)
	);

DROP TABLE op_call_step_report_conm;
CREATE TABLE op_call_step_report_conm (
    phone varchar(25) default NULL,
    hour_take time default '00:00:00' NOT NULL,
    hour_b time default '00:00:00' NOT NULL,
    hour_e time default '00:00:00' NOT NULL,
    duration time default '00:00:00' NOT NULL,  
    difference time default '00:00:00' NOT NULL,  
    date_id date default '1970-01-01' NOT NULL,
    gc_sequence smallint default '0' NOT NULL 
);
