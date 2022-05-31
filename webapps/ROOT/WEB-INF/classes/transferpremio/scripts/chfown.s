#!/bin/ksh

###########################################################################################
# Nombre Archivo  : chfown.s
#
# Compania        : Yum Brands Intl
#
# Autor           : Adolfo Perez 
#
# Objetivo        : Modifica ownership, grupo y permisos de un archivo dado
#
#                   sdc_dim y sdc_dex.
#
# Fecha Creacion  : 04/Abril/2006
#
# Comentarios     : Recibe como parametro la ruta y nombre del archivo 
#
#
#
###########################################################################################

phzap chmod 666 $1
phzap chown fms $1
phzap chgrp sus $1

