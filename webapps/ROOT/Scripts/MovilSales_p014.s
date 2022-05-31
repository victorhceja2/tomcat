#!/bin/bash

VERSION=`cat /usr/fms/op/cfg/Release`
LOG=/tmp/MovilSales_p014.log
set -x 
exec 2>$LOG 
PHASDEF="/usr/fms/op/parms/phasdef"

DIDI=`grep DiDi $PHASDEF | grep PAY | awk '{printf("%d",$3)}'`
RAPPI=`grep Rappi $PHASDEF | grep PAY | awk '{printf("%d",$3)}'`
UBER=`grep Uber-Eats $PHASDEF | grep PAY | awk '{printf("%d",$3)}'`
BRINGG=`grep Bringg $PHASDEF | grep PAY | awk '{printf("%d",$3)}'`

DIDI=`grep DiDi $PHASDEF | grep VOUCHDEP | awk '{printf("%d",$3)}'`
RAPPI=`grep Rappi $PHASDEF | grep VOUCHDEP | awk '{printf("%d",$3)}'`
UBER=`grep Uber-Eats  $PHASDEF | grep VOUCHDEP | awk '{printf("%d",$3)}'`
BRINGG=`grep Bringg $PHASDEF | grep VOUCHDEP | awk '{printf("%d",$3)}'`

SDELANTAL=`grep Sin-Delan $PHASDEF | grep PAY | awk '{printf("%d",$3)}'`

if [ $# -gt 1 ] ; then 
    if [ "$VERSION" = "5.3_INTERNATIONAL_SUS" ]; then
        /usr/bin/ph/phdppr /usr/fms/op/print1/p014 | cut -d'|' -f5,8 | awk -F'|' -vCONCEP=$1 '{if($1 == CONCEP ) total= total+$2}; END {print total/100}'
    else
        /usr/fms/op/bin/phdppr /usr/fms/op/print1/p014 | cut -d'|' -f4,7 | awk -F'|' -vCONCEP=$1 '{if($1 == CONCEP ) total= total+$2}; END {print total/100}'
    fi
else
    if [ "$VERSION" = "5.3_INTERNATIONAL_SUS" ]; then
        /usr/bin/ph/phdppr /usr/fms/op/print1/p014 | cut -d'|' -f5,8 | awk -F'|' -vRP=$RAPPI -vUE=$UBER -vSD=$SDELANTAL -vDD=$DIDI -vBR=$BRINGG '{if($1 == RP || $1 == UE || $1 == SD || $1 == DD || $1 == BR ) total+=$2}; END {print total/100}'
    else
        /usr/fms/op/bin/phdppr /usr/fms/op/print1/p014 | cut -d'|' -f4,7 | awk -F'|' -vRP=$RAPPI -vUE=$UBER -vSD=$SDELANTAL -vDD=$DIDI -vBR=$BRINGG '{if($1 == RP || $1 == UE || $1 == SD || $1 == DD || $1 == BR ) total+=$2}; END {print total/100}'
    fi
fi
