
CREATE TABLE op_hh_year_transactions
(
	ageb_id VARCHAR(5) NOT NULL,
	year_no SMALLINT NOT NULL,
	transactions DECIMAL(12,2)
);

ALTER TABLE ONLY op_hh_year_transactions
    ADD CONSTRAINT op_hh_year_transactions_pkey PRIMARY KEY (ageb_id, year_no);

ALTER TABLE ONLY op_hh_year_transactions
    ADD CONSTRAINT fk1 FOREIGN KEY (ageb_id) REFERENCES op_hh_ageb(ageb_id) 
	ON DELETE CASCADE ON UPDATE CASCADE;
