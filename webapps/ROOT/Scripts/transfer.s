#!/bin/ksh

set -x
exec 2> /tmp/transfer.log

FILE="$1"

#$2 record to add

PATH=$PATH:/usr/local/postgres/bin:/usr/bin/ph/rpcost:/usr/fms/op/bin:/usr/bin/ph
export PATH  

if [ -e $FILE ]
then
    phzap echo "$2" >> $FILE

else
    phzap echo "$2" > $FILE

    phzap chmod 666 $FILE
    phzap chown fms $FILE
    phzap chgrp sus $FILE
fi

/usr/bin/ph/mail2222.s $FILE
