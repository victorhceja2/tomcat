#!/bin/bash


PATH=$PATH:/usr/bin/ph:/usr/fms/op/bin
export PATH

# Script para mandar correos
JMAIL="/usr/bin/ph/jmail.s"

# Sender del correo
SENDER="mx"`/usr/bin/ph/unit.s`"r"

WGET="/usr/bin/wget"

URL="http://poleo.yum.com.mx/sisdevel/ccard_mails"

STORE_ID=$1

MAILS_FILE="afiliacion_mails.dat"
AFILIACION_FILE="afiliacion_nums.dat"

if [ -s /tmp/$MAILS_FILE ]; then
    /bin/rm -f /tmp/$MAILS_FILE
fi

if [ -s /tmp/$AFILIACION_FILE ]; then
    /bin/rm -f /tmp/$AFILIACION_FILE
fi

$WGET --quiet --output-document=/tmp/$MAILS_FILE $URL/$MAILS_FILE
$WGET --quiet --output-document=/tmp/$AFILIACION_FILE $URL/$AFILIACION_FILE

DESTS="`/bin/cat /tmp/$MAILS_FILE`"

AF=`grep "\<${STORE_ID}\>" /tmp/$AFILIACION_FILE | cut -d\| -f2`

FECHA=`date +%d/%m/%y`

MSG=`psql -U postgres -d dbeyum -c "SELECT terminal_id as terminal, monto, fecha, hora FROM tmp_mov_sales WHERE termFailed = 1" | grep -v row`

SUBJ="Cierre de Venta de Moviles Fallido Afiliacion ${AF} Fecha ${FECHA}"

$JMAIL "${SENDER}" "${DESTS}" "${SUBJ}" "${MSG}"

