#!/bin/ksh

SUBMIT="$1"
QUERY="$2"
FILE="$3"
LOGFILE=/tmp/PGDBUtils.log

#exec > /tmp/jj 2>&1
PATH=$PATH:/usr/local/postgres/bin:/usr/bin/ph/rpcost:/usr/fms/op/bin:/usr/bin/ph ; export PATH  

psql -d dbeyum -U postgres -c "$QUERY" -F "|" -t -P format=unaligned >> "$FILE"
. /usr/bin/ph/sysshell.new SUS >/dev/null 2>&1
UNIT=`unit.s`

#if [ $SUBMIT == "true" ]
#then
#    wget -O submit_order.log http://192.168.101.17/purchaseOrder/SubmitStoreData?psStoreId=${UNIT}
#fi

 	
if [ $# = 5 ]
then
	TODAY=`date +%y-%m-%d_%H:%M:%S`
	echo "------------------------------------------------"  >> ${LOGFILE}
	echo "${TODAY} , con recepcion: $5" >> ${LOGFILE}
	fecha=`date +%y%m%d`
	anio=`/usr/bin/ph/dyps.s ${fecha}| cut -d"/" -f1`
	periodo=`/usr/bin/ph/dyps.s ${fecha}| cut -d"/" -f2`
	ext_resp=`date +%y%m%d_%H%M_r`
	cp /usr/fms/data/invtran.$anio$periodo /usr/fms/data/invtran.$anio$periodo.$ext_resp
	/usr/local/tomcat/webapps/ROOT/Inventory/PurchaseOrder/Scripts/GenerateFiles.pl $4 $5;
	/usr/bin/ph/rpcost/pfsfmscst.s
	phzap chmod 666 /usr/fms/data/invtran.*
	phzap chown fms /usr/fms/data/invtran.*
	phzap chgrp sus /usr/fms/data/invtran.*
fi
