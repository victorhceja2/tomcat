#Agregado al inicio
RPTPATH=/usr/fms/op/rpts
UNIT=$1
DATE=$2
. /usr/bin/ph/sysshell.new SUS >/dev/null 2>&1


OUTFILE=$PRPATH/phasrp1.out
ERRFILE=$PRPATH/phasrp1.err
NETWK=`echo $NETWORK | cut -c1-6`
PQHOLD=$PQPATH

exec 1>$OUTFILE 2>$ERRFILE

echo "Starting phasrp1.s" 
echo "`date`" 

if [ $NETWK = "norand" ]
then
	## 	if an FMS site, sleep for a while
	##	until jobs are NOT active

	while [ `ps -ef|egrep -i 'GETGC|GETPCA|NSMERGE'| \
			grep -v grep|wc -l` -gt 0 ]
	do
		# wait for SUS Sales report to finish
		echo "PHASRP1.S Waiting"
		sleep 10
	done

	echo "Executing the Norand merge" 

	#
	## Copy the Current SUS Print Que to a Temporary Print Que
	#

	cp ${PQPATH}/iAU1 /usr/tmp/
	cp ${PQPATH}/pAU1 /usr/tmp/
	cp ${PQPATH}/p${UNIT}[1-4] /usr/tmp/
	PQPATH=/usr/tmp; export PQPATH
	
	#
	## Copy the Current Norand Sales to the BOHP
	#

	##	Check if Norand is closed
	##	if YES, set VAR to previous day else NOT

	tcflag="`norutil tcflag 2>/dev/null`"
	case "$tcflag" in
		0|4|8|c)
			VAR=dat ;;
		1|2|3|5|6|7|9|a|b|d|e|f)
			VAR=1 ;;
		*)
			VAR=dat ;;
	esac

	echo "Polling NORAND'S mkting.$VAR"

	nor get finance.${VAR} ${SAPATH}/norand/finance.dat
	[ $? = 0 ] && nor get mkting.${VAR} ${SAPATH}/norand/mkting.dat
	[ $? = 0 ] && nor get cash.${VAR} ${SAPATH}/norand/cash.dat
	#
	## Merge the Current Norand Sales to the Temporary Print Que
	#
	[ $? = 0 ] && phcnvmkt -b -t
	[ $? = 0 ] && phcnvcsh -b -t
	if [ $? != 0 ]
	then
		#
		## Print message of incomplete data to the report printer
		#
		echo "Norand to SUS Merge was unsuccessful!"
		#
		# MEXICO - LINUX Avoid print this report for triweb
		#phpq7 -u RP -c "cat ${PARMPATH}/phnormsg.3"
	fi
fi

#	extract sales analysis data from print qs
#
echo "Executing phrepdvr" 
phrepdvr $1 phasbt phcxrp

#	create daily and weekly sales analysis reports
phasrp.s $1 $2
if [ $? -ne 0 ]
then
	echo "PHASRP.S Abended!"
	exit 9
fi

if [ $NETWK = "norand" ]
then
	#
	## Remove the Temporary Print Que and Reset the Print Que Path
	#
	rm ${PQPATH}/iAU1 
	rm ${PQPATH}/pAU1 
	rm ${PQPATH}/p${UNIT}[1-4] 
	rm ${PQPATH}/h${UNIT}[1-4] 
	PQPATH=${PQHOLD}; export PQPATH
fi

#	print daily report at unit, report printer if SUS
echo "Producing the Sales Report" 
#phreport SD $1
#phreport CX $1
echo "phasrp1.s is now complete!" 


#Agregado al final
DIR=`phtbpr -u rept 2>/dev/null | grep $filename | cut -f10 -d"|" | sed 's/ //g' `
OUTFILE=$RPTPATH/$DIR
DAY=`expr $DATE : "....\(..\)"`
MONTH=`expr $DATE : "..\(..\).."`
YEAR=`expr $DATE : "\(..\)...."`

cp -f $OUTFILE/01 $OUTFILE/${YEAR}-${MONTH}-${DAY}
