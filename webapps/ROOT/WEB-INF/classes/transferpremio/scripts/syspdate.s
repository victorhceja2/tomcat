#Written by Adolfo P.
#Executes syspdate with MM/DD/YY format
#The input arguments should come like YY MM DD
#Returns: Period Week for the requested date
################################################
. /usr/bin/ph/sysshell.new FMS >/dev/null 2>&1

	if [ $# -eq 3 ]
		then
			syspdateout=`syspdate $2/$3/$1 | egrep -i "Period Number|Week Number" | cut -d ":" -f2`
			echo $syspdateout
	else
			echo "usage: syspdate.s YY MM DD"
	fi
