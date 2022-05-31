#!/bin/ksh

##################################################################################################
# Nombre Archivo  : load_rsg.s                                                                   #
# Compania        : Yum Brands Intl                                                              #
# Autor           : Eduardo Zarate                                                               #
# Objetivo        : Ejecuta el script de perl /usr/bin/ph/databases/graphics/bin/carga_rsg.pl    #
#                   para actualizar la tabla op_gt_real_sist_mng                                 #
# Fecha Creacion  : 27/Mar/2006                                                                  #
# Parametros      : Ninguno.                                                                     #
##################################################################################################


exec > /tmp/carga_rsg.log 2>&1

. /usr/bin/ph/sysshell.new SUS >/dev/null


export PATH=/usr/bin/ph:$PATH


#Respaldo real_sistema_gerente.txt
phzap cp /usr/bin/ph/tables/real_sistema_gerente.txt /usr/bin/ph/tables/real_sistema_gerente.txt.soptjn

#Ejecuta carga_rsg.pl ...
/usr/bin/ph/databases/graphics/bin/carga_rsg.pl

#Cambio duenio en real_sistema_gerente.txt por si quedan con root.root
phzap chown admin.sus /usr/bin/ph/tables/real_sistema_gerente.txt
