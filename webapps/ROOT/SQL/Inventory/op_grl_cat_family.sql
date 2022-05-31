
ALTER TABLE op_grl_cat_family  ADD COLUMN family_order smallint;

UPDATE op_grl_cat_family SET family_order=0  WHERE family_id=12020000;
UPDATE op_grl_cat_family SET family_order=1  WHERE family_id=12100000;
UPDATE op_grl_cat_family SET family_order=2  WHERE family_id=12500000;
UPDATE op_grl_cat_family SET family_order=3  WHERE family_id=12030000;
UPDATE op_grl_cat_family SET family_order=4  WHERE family_id=12010000;
UPDATE op_grl_cat_family SET family_order=5  WHERE family_id=12250000;
UPDATE op_grl_cat_family SET family_order=6  WHERE family_id=12110000;
UPDATE op_grl_cat_family SET family_order=7  WHERE family_id=12070000;
UPDATE op_grl_cat_family SET family_order=8  WHERE family_id=12200000;
UPDATE op_grl_cat_family SET family_order=9  WHERE family_id=12050000;
UPDATE op_grl_cat_family SET family_order=10 WHERE family_id=12150000;
UPDATE op_grl_cat_family SET family_order=11 WHERE family_id=12160000;
UPDATE op_grl_cat_family SET family_order=12 WHERE family_id=12090000;
UPDATE op_grl_cat_family SET family_order=13 WHERE family_id=12040000;
UPDATE op_grl_cat_family SET family_order=14 WHERE family_id=12700000;

