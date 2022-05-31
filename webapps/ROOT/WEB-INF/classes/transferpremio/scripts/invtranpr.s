. /usr/bin/ph/sysshell.new FMS >/dev/null 2>&1
# arguments: $1: YY
#			 $2: MM
#  			 $3: W
# 			 $4: inv_id
/usr/bin/ph/invtranpr $1 $2 $3 | col -b | grep $4
