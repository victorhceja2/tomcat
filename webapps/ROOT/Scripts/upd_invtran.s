#!/bin/ksh

exec > /tmp/upd_invtran.log 2>&1

. /usr/bin/ph/sysshell.new FMS >/dev/null 


#PATH=$PATH:/usr/bin/ph/rpcost:/usr/fms/op/bin:/usr/bin/ph export PATH  

/usr/bin/ph/rpcost/pfsfmscst.s
phzap chmod 666 /usr/fms/data/invtran.*
phzap chown fms /usr/fms/data/invtran.*
phzap chgrp sus /usr/fms/data/invtran.*
