#!/bin/ksh

exec > /tmp/upd_invtran.log 2>&1

. /usr/bin/ph/sysshell.new FMS >/dev/null 


#PATH=$PATH:/usr/bin/ph/rpcost:/usr/fms/op/bin:/usr/bin/ph export PATH  
fecha=`date +%y%m%d`
anio=`/usr/bin/ph/dyps.s ${fecha}| cut -d"/" -f1`
periodo=`/usr/bin/ph/dyps.s ${fecha}| cut -d"/" -f2`

ext_resp=`date +%y%m%d_%H%M_e`
cp /usr/fms/data/invtran.$anio$periodo /usr/fms/data/invtran.$anio$periodo.$ext_resp

/usr/bin/ph/rpcost/pfsfmscst.s
phzap chmod 666 /usr/fms/data/invtran.*
phzap chown fms /usr/fms/data/invtran.*
phzap chgrp sus /usr/fms/data/invtran.*
