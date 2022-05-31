#!/bin/ksh

##################################################################################################
# Nombre Archivo  : finantial_mov.s                                                              #
# Compania        : Yum Brands Intl                                                              #
# Autor           : Eduardo Zarate                                                               #
# Objetivo        : Carga los movimientos financieros de la fecha de negocio actual              #
# Fecha Creacion  : 30/Ago/2005                                                                  #
# Parametros      : Ninguno. Calcula la fecha de de negocio y en base a esta se hace la carga.   #
##################################################################################################

#exec > /tmp/finantial_mov.log 2>&1

qdate=`/usr/fms/op/bin/phpqdate`
yy=`expr substr $qdate 1 2`
mm=`expr substr $qdate 3 2`
dd=`expr substr $qdate 5 2`
cdate="$yy-$mm-$dd"

echo "Using date ($qdate)... $yy, $mm, $dd"

echo "Executing phasrp.s ... "

#. /usr/bin/ph/sysshell.new SUS >/dev/null 
#/usr/bin/ph/phasrp1.S 01 $qdate
/usr/local/tomcat/webapps/ROOT/Scripts/phasrp.s 01 $qdate




echo "Executing /usr/bin/ph/phdftgen.s ... "

#. /usr/bin/ph/sysshell.new FMS >/dev/null 
export PATH=/usr/bin/ph:$PATH


/usr/bin/ph/phdftgen.s $cdate

res=$?
echo "Result: $res"

phzap chmod 666 /usr/fms/op/rpts/sdc_dft/*
phzap chown fms /usr/fms/op/rpts/sdc_dft/*
phzap chgrp sus /usr/fms/op/rpts/sdc_dft/*

cc=`unit.s`

echo "Executing .finantialPop.pl ... "

cd /usr/bin/ph/databases/finantial/bin

./finantialPop.pl $cc $qdate
