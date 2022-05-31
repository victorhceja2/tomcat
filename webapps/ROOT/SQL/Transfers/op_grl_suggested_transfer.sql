--
-- PostgreSQL database dump
--

CREATE TABLE op_grl_suggested_transfer (
    local_store_id smallint DEFAULT (0)::smallint NOT NULL,
    inv_id character(6) DEFAULT ''::bpchar NOT NULL,
    available_quantity numeric(12,2) DEFAULT 0.00,
    required numeric(12,2) DEFAULT 0.00,
    suggested_quantity numeric(12,2) DEFAULT 0.00,
    transfer_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE ONLY op_grl_suggested_transfer
    ADD CONSTRAINT op_grl_suggested_transfer_pkey PRIMARY KEY (local_store_id, inv_id, transfer_id);

ALTER TABLE ONLY op_grl_suggested_transfer
    ADD CONSTRAINT "$1" FOREIGN KEY (inv_id) REFERENCES op_grl_cat_inventory(inv_id);


