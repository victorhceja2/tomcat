#!/bin/ksh

set -x
exec 2>> /tmp/rootup.log


WEBAPPS=/usr/local/tomcat/webapps
CACHE=/usr/local/tomcat/work/Catalina/localhost/_/org/apache/jsp/
FECHA=$1

CHANGES=CHANGES.${FECHA}.txt
SQLCHANGES=CHANGES.${FECHA}.sql
GZFILE=/tmp/ROOTUP.${FECHA}.tar.gz


cd $WEBAPPS

	#Se cambian los permisos para los nuevos archivos
	if [ -e $GZFILE ]
	then
		tar ztf $GZFILE | xargs phzap chown root.root
	fi

	#Se fija el timestamp para los nuevos archivos
	if [ -e $GZFILE ]
	then
		tar ztf $GZFILE | xargs phzap touch
	fi

	#Para borrar los archivos JSP que ya existen en cache de Tomcat.
	files=`grep -v "#" ROOT/$CHANGES | grep jsp | cut -d "." -f 1`

	for filename in $files; do

		source=`find $CACHE -name ${filename}_jsp.java`
		class=`find $CACHE -name ${filename}_jsp.class`

		if [ $source ] && [ -e $source ]
		then
			phzap rm -rf $source 
		fi

		if [ $class ] && [ -e $class ]
		then
			phzap rm -rf $class 
		fi
	done


	#Si hay cambios en la BD se aplican ...
	if [ -e ROOT/SQL/$SQLCHANGES ]
	then
		PATH=/usr/local/postgres/bin:$PATH

		phzap psql -U postgres dbeyum < ROOT/SQL/$SQLCHANGES
	fi



	#Se renombra un archivo JSP
	if [ -e ROOT/Inventory/PurchaseOrder/Proc/OrderTriggerYum.jsp ]
	then
		phzap mv ROOT/Inventory/PurchaseOrder/Proc/OrderTriggerYum.jsp  ROOT/Inventory/PurchaseOrder/Proc/OrderTriggerLibYum.jsp

	fi


