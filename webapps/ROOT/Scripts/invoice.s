#!/bin/ksh

FILE="$1"
RECORD="$2"

exec > /tmp/invoice.log 2>&1

PATH=$PATH:/usr/local/postgres/bin:/usr/bin/ph/rpcost:/usr/fms/op/bin:/usr/bin/ph ; export PATH  

UNIT=`unit.s`

if [ -e $FILE ]
then
    phzap echo $RECORD >> $FILE
else
    phzap echo "UNIT|NOTE_ID|NOTE_TAX|NOTE_QTY|NOTE_DATE|SUPP_ID|NOTE_DESC|ACC_SUB_ACC|NOTE_COMMENT|NOTE_AMOUNT|FOLIO|SN_MOTO|" > $FILE
    $RECORD = "${UNIT}$RECORD"
    phzap echo $RECORD >> $FILE
fi

    phzap chmod 666 $FILE
    phzap chown fms $FILE
    phzap chgrp sus $FILE
