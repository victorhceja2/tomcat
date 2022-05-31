DROP TABLE sus_clients;

CREATE TABLE sus_clients (
  store_id smallint   default '0' NOT NULL,
  client varchar(14) default '0' NOT NULL,
  dwel_code varchar(1) default '0' NOT NULL,
  street varchar(30) default '0' NOT NULL,
  section char(4) default '0' NOT NULL,
  ac_code smallint default '0' NOT NULL,
  address_com varchar(60) default NULL,
  instructions varchar(30) default NULL,
  postal_code varchar(6),
--  local_phone varchar(15) default NULL,
  name varchar(30) default NULL,
  frecuency smallint default NULL,
  d_sold_avg decimal(10,2) default NULL,
  first_gc_date date default '1970-01-01' NOT NULL, 
  last_gc_date date default '1970-01-01' NOT NULL,
  PRIMARY KEY (store_id, client)
  );

CREATE UNIQUE INDEX ip_clients ON sus_clients(store_id,client);

--CREATE INDEX if_clients ON sus_clients(store_id,client);

CREATE INDEX ip_index01 ON sus_clients(store_id,client,dwel_code);

CREATE INDEX ip_index02 ON sus_clients(store_id,client,ac_code);

DROP TABLE sus_dweling;

CREATE TABLE sus_dweling (
  dwel_code varchar(1) default '0' NOT NULL,
  dwel_desc varchar(15) default NULL,
  PRIMARY KEY (dwel_code)
  );

CREATE UNIQUE INDEX ip_dweling ON sus_dweling(dwel_code);
--CREATE INDEX if_dweling ON sus_dweling(dwel_code);

DROP TABLE sus_streets;

CREATE TABLE sus_streets (
  store_id smallint   default '0' NOT NULL,
  street varchar(30) default '0' NOT NULL,
  section char(4) default '0' NOT NULL,
  beg_num smallint default NULL,
  end_num int default NULL,
  last_upd date default '1970-01-01' NOT NULL,
  PRIMARY KEY (store_id, street,section)
  );

CREATE UNIQUE INDEX ip_streets ON sus_streets(store_id,street,section);
--CREATE INDEX if_streets ON sus_streets(store_id,street);

DROP TABLE area_code;

CREATE TABLE area_code (
  area_code varchar(10) default '0' NOT NULL,
  ac_code smallint default NULL,
  ac_desc varchar(20) default NULL,
  mail_code varchar(6),
  PRIMARY KEY (ac_code)
  );

CREATE UNIQUE INDEX ip_area_code ON area_code(ac_code);

ALTER TABLE sus_clients ADD CONSTRAINT fk1_clients FOREIGN KEY (dwel_code)
REFERENCES sus_dweling (dwel_code) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE sus_clients ADD CONSTRAINT fk2_clients FOREIGN KEY (ac_code)
REFERENCES area_code (ac_code) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE sus_clients ADD CONSTRAINT fk3_clients FOREIGN KEY (store_id,street,section)
REFERENCES sus_streets (store_id,street,section) ON UPDATE CASCADE ON DELETE NO ACTION;

--ALTER TABLE gc_delivery ADD CONSTRAINT fk_delivery FOREIGN KEY (store_id,client)
--REFERENCES sus_clients (store_id,client) ON UPDATE CASCADE ON DELETE NO ACTION;
