#!/bin/bash


PATH=$PATH:/usr/bin/ph:/usr/fms/op/bin
export PATH

# Script para mandar correos
JMAIL="/usr/bin/ph/jmail.s"

# Script para mandar sms
SMS_SEND="/usr/bin/ph/sop/sendSMS.sh"

# Sender del correo
SENDER="mx"`/usr/bin/ph/unit.s`"r"

WGET="/usr/bin/wget"

URL="http://poleo.yum.com.mx/sisdevel/ccard_mails"

DIF=$1
BDATE=$2
SUS_ID=$3
STORE_ID=$4

MAILS_FILE="${STORE_ID}.txt"
SMS_FILE="${STORE_ID}.sms"

if [ -s /tmp/ccard_mails.txt ]; then
    /bin/rm -f /tmp/ccard_mails.txt
fi

if [ -s /tmp/ccard_sms.txt ]; then
    /bin/rm -f /tmp/ccard_sms.txt
fi

$WGET --quiet --output-document=/tmp/ccard_mails.txt $URL/$MAILS_FILE
$WGET --quiet --output-document=/tmp/ccard_sms.txt   $URL/$SMS_FILE

DESTS="`/bin/cat /tmp/ccard_mails.txt`"
SMS="`/bin/cat /tmp/ccard_sms.txt`"

MSG="Existe una diferencia en el CC ${STORE_ID} por ${DIF} en sus cierre de venta de dispositivos moviles realizado por ${SUS_ID} en la fecha de negocio ${BDATE}."

MSG_SMS="Dif en el CC ${STORE_ID} de ${DIF} en su cierre de venta de dispositivos moviles, realizado por ${SUS_ID} con fecha neg ${BDATE}"

SUBJ="Diferencia en Cierre de venta de dispositivos moviles en CC ${STORE_ID} ${BDATE}"

$JMAIL "${SENDER}" "${DESTS}" "${SUBJ}" "${MSG}"
$SMS_SEND "${SMS}" "${MSG_SMS}"

