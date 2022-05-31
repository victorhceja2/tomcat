--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'postgres';

SET search_path = public, pg_catalog;

--
-- TOC entry 3 (OID 670384)
-- Name: op_gsv_gas; Type: TABLE; Schema: public; Owner: postgres
--
DROP TABLE op_gsv_gas;

CREATE TABLE op_gsv_gas (
    store_id integer NOT NULL,
    capacity integer,
    margin numeric(2,0),
    required smallint
) WITHOUT OIDS;


--
-- Data for TOC entry 5 (OID 670384)
-- Name: op_gsv_gas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO op_gsv_gas VALUES ((select store_id from ss_cat_store), 1500, 2, 85);


--
-- TOC entry 4 (OID 670386)
-- Name: op_gsv_gas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY op_gsv_gas
    ADD CONSTRAINT op_gsv_gas_pkey PRIMARY KEY (store_id);


