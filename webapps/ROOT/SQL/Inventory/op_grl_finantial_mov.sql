
CREATE TABLE op_grl_finantial_mov(
	finantial_code VARCHAR(5) NOT NULL,
	quantity NUMERIC(12,2) NOT NULL,
	store_id smallint NOT NULL,
    date_id TIMESTAMP NOT NULL,
	PRIMARY KEY(finantial_code, date_id));

ALTER TABLE op_grl_finantial_mov ADD CONSTRAINT fk1 FOREIGN KEY(store_id)
REFERENCES ss_cat_store(store_id) ON UPDATE CASCADE ON DELETE CASCADE;
