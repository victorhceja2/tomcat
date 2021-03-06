#!/bin/ksh

##################################################################################################
# Nombre Archivo  : load_ideal_use.s                                                             #
# Compania        : Yum Brands Intl                                                              #
# Autor           : Eduardo Zarate                                                               #
# Objetivo        : Actualiza el uso ideal del dia actual en el archivo de inventario de FMS     #
# Fecha Creacion  : 12/Oct/2005                                                                  #
# Parametros      : Ninguno. Calcula la fecha de negocio y en base a esta se hace la carga.      #
##################################################################################################
#Carga ambiente FMS
. /usr/bin/ph/sysshell.new FMS >/dev/null 
#. /usr/bin/ph/sysshell.new FMS >/dev/null 2>&1

set -x
exec > /tmp/load_ideal_use.log 2>&1

PQDATE=`/usr/fms/op/bin/phpqdate`
YEAR=`expr substr $PQDATE 1 2`
MONTH=`expr substr $PQDATE 3 2`
DAY=`expr substr $PQDATE 5 2`

su fms -c "/usr/bin/ph/sop/usecheck.s v ${YEAR}-${MONTH}-${DAY}"
su fms -c "/usr/bin/ph/valUseWeek.s"

#FMS_STORE=`uname -n | cut -c2-5 | sed 's/^0//'`; export FMS_STORE

#syspos GETGC

#if [ $? -ne 6 ]
#then
#    invusage -d$MONTH/$DAY/$YEAR 
#fi
    
#su fms -c "/usr/bin/ph/sop/usecheck.s r ${YEAR}-${MONTH}-${DAY}"

echo "res=$?"

chown admin.sus /usr/fms/data/gcdata.dat

su fms -c "/usr/bin/ph/sop/usecheck.s v ${YEAR}-${MONTH}-${DAY}"

echo "---------------------------------------------------"
date
echo "---------------------------------------------------"
