#!/bin/ksh

exec > /tmp/upd_agebs.log 2>&1

. /usr/bin/ph/sysshell.new SUS >/dev/null 


/usr/bin/ph/databases/ml/bin/ml_update.pl
