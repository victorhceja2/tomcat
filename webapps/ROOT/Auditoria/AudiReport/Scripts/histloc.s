# histick.s         Reporte diario de historico de Tickets Version E-Reports
#
# Autor: GAR                      2009/07/06
# Actualizacion: 2009/07/06
#set -x
#exec 1> /tmp/histick.err 2>&1
##############################################################################
# Pone el medio ambiente de SUS
##############################################################################
#. /usr/bin/ph/sysshell.new SUS >/dev/null 2>&1
cd /usr/fms/op/bin
. ./.env

fechaNegocio=`phpqdate`
export fechaNegocio

###############################################################################
# define variables del medio ambiente
###############################################################################
DIRAWK=/usr/local/tomcat/webapps/ROOT/Auditoria/AudiReport/Scripts
DIR_REPOUT=/tmp
export DIR_REPOUT
PATH=.:$PATH
###############################################################################
# Variables utilizadas en el awk 
###############################################################################
TKPATH=/usr/bin/ph/ticket
PATH=$PATH:$TKPATH
PRPATH=/usr/fms/op/print1
LANGFILE=/usr/fms/op/cfg/lang00
LANG=C_C.C
DEVDEBUG=
DATE=`date '+%y-%m-%d'`
DEVOUT="$DIR_REPOUT/${DATE}.h"
DEVIN="$DIR_REPOUT/tmp.txt"
export PRPATH PATH TKPATH DEVOUT DEVIN LANGFILE LANG

##############################################################################
# Genera el archivo yy-mm-dd 
######################################################################
# Etapa 1. Busca el directorio q asociado a la fecha pedida
######################################################################
phpqpr 01 1 7 >  $DIR_REPOUT/tmp.txt        # Genera los tickets
awk -f $DIRAWK/histloc.awk 
rm  $DIR_REPOUT/tmp.txt
compress -f $DEVOUT
exit 0

