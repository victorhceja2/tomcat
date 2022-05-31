CREATE TABLE op_inv_exceptions (
	inv_id CHAR(6) NOT NULL,
	family_id CHAR(10) NOT NULL,
	min_efficiency FLOAT,
	max_efficiency FLOAT,
	max_variance FLOAT,
	PRIMARY KEY (inv_id, family_id));
