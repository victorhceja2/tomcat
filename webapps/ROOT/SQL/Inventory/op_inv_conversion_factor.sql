

CREATE TABLE op_inv_conversion_factor(
			inv_id CHAR(6) NOT NULL ,
			rcp_conversion_factor NUMERIC(12,2),
			prv_conversion_factor NUMERIC(12,2),
            prv_unit_measure character(4),
            inv_unit_measure character(4));

