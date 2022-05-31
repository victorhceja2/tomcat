CREATE TABLE op_gt_real_sist_mng (
	date_id timestamp without time zone NOT NULL,
	ppt_real float DEFAULT 0.00,
	ppt_sist float DEFAULT 0.00,
	ppt_mng float DEFAULT 0.00,
	trans_real float DEFAULT 0.00,
	trans_sist float DEFAULT 0.00,
	trans_mng float DEFAULT 0.00
);

ALTER TABLE ONLY op_gt_real_sist_mng
    ADD CONSTRAINT op_gr_real_sist_mng_pkey PRIMARY KEY (date_id);
