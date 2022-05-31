--
-- PostgreSQL database dump
--

CREATE TABLE op_grl_transfer_detail (
    transfer_id integer NOT NULL,
    inv_id character(6) NOT NULL,
    stock_code_id CHAR(6) NOT NULL,
    provider_product_code character(10),
    provider_quantity numeric(12,2) DEFAULT 0 NOT NULL,
    inventory_quantity numeric(12,2) DEFAULT 0 NOT NULL,
    prv_conversion_factor numeric(12,2) DEFAULT 0 NOT NULL,
    provider_unit_measure character(50),
    inventory_unit_measure character(50),
    provider_id character(10),
    existence float
);


ALTER TABLE ONLY op_grl_transfer_detail
    ADD CONSTRAINT "$1" FOREIGN KEY (inv_id) REFERENCES op_grl_cat_inventory(inv_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY op_grl_transfer_detail
    ADD CONSTRAINT "$2" FOREIGN KEY (transfer_id) REFERENCES op_grl_transfer(transfer_id) ON UPDATE CASCADE ON DELETE CASCADE;


