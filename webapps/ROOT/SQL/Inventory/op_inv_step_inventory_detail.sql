

CREATE TABLE op_inv_step_inventory_detail
(
	inv_id char(6),
	inv_beg NUMERIC(12,2),
	receptions numeric(12,2),
	itransfers numeric(12,2),
	otransfers numeric(12,2),
	prv_inv_end numeric(12,2),
	inv_inv_end numeric(12,2),
	rec_inv_end numeric(12,2),
	inv_end numeric(12,2),
	decreases numeric(12,2),
	ideal_use numeric(12,2),
	real_use numeric(12,2),
	unit_cost numeric(12,2),
	prv_conversion_factor numeric(12,2),
	rcp_conversion_factor numeric(12,2),
    prv_unit_measure character(4),
    inv_unit_measure character(4),
	misc boolean,
	date_id TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	year_no SMALLINT,
	period_no SMALLINT,
	week_no SMALLINT,
	PRIMARY KEY(inv_id, year_no, period_no, week_no)
);

	ALTER TABLE op_inv_step_inventory_detail ADD CONSTRAINT fk1 FOREIGN KEY(inv_id) 
	REFERENCES op_grl_cat_inventory(inv_id) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;
