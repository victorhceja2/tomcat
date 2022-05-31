#!/bin/ksh
# Restores db and invtran to test
# by Adolfo Perez
######################
PSQL_PATH=/usr/bin/
INVTRAN_BKP_PATH=/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/transferpremio/backups/BACKUPJUGNUEVVIEJ/
INVTRAN_PATH=/usr/fms/data/
INVTRANFILE=invtran.0612

#################################
# SQL DELETES AND UPDATE ON DBEYUM
################################
$PSQL_PATH/psql -U postgres -d dbeyum -c "delete from op_grl_transfer where
transfer_id in( select t.transfer_id from op_grl_transfer
t,op_grl_transfer_detail td where t.date_id like '2006-10-17%'and t.transfer_id
= td.transfer_id and td.provider_product_code in('Y2154','Y8888'))"
$PSQL_PATH/psql -U postgres -d dbeyum -c "delete from op_inv_inventory_mov where inv_id = 11037"
$PSQL_PATH/psql -U postgres -d dbeyum -c "delete from op_inv_inventory_mov where inv_id = 11268"
$PSQL_PATH/psql -U postgres -d dbeyum -c "update op_inv_inventory_detail set otransfers=0,itransfers=0 where inv_id = 11037 and period_no=12 and week_no = 1"
$PSQL_PATH/psql -U postgres -d dbeyum -c "update op_inv_inventory_detail set otransfers=0,itransfers=0 where inv_id = 11268 and period_no=12 and week_no = 1"

#################################
# DELETE FMS, SDC_DIM, SDC_DEX FILES
###############################
#rm /usr/fms/op/rpts/sdc_dex/00021dex.a10
#rm /usr/fms/op/rpts/sdc_dim/00021dim.a10
#rm /usr/bin/ph/rpcost/06-10-10.fms

################################
# COPY INVTRAN BACKUP TO /USR/FMS/DATA
################################
#cp $INVTRAN_BKP_PATH$INVTRANFILE $INVTRAN_PATH
#RESTORE PRODUCTS IN INVENTORY
#phzap /usr/bin/ph/exe_invdrprd.s
