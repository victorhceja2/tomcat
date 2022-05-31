
CREATE TABLE op_hh_week_transactions
(
	ageb_id VARCHAR(5) NOT NULL,
	date_id TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	transactions INT
);

ALTER TABLE ONLY op_hh_week_transactions
    ADD CONSTRAINT op_hh_week_transactions_pkey PRIMARY KEY (ageb_id, date_id);

ALTER TABLE ONLY op_hh_week_transactions
    ADD CONSTRAINT fk1 FOREIGN KEY (ageb_id) REFERENCES op_hh_ageb(ageb_id) 
	ON DELETE CASCADE ON UPDATE CASCADE;

