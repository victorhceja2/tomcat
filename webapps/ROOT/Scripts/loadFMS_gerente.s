#!/bin/ksh

##################################################################################################
# Nombre Archivo  : loadFMS_gerente.s                                                            #
# Compania        : Yum Brands Intl                                                              #
# Autor           : Sergio Cuellar valdes                                                        #
# Objetivo        : Ejecuta el script /home/httpd/html/php/hpedidos/loadFMS.s                    #
# Fecha Creacion  : 06/Jun/2008                                                                  #
# Parametros      : Fecha.                                                                       #
##################################################################################################

. /usr/bin/ph/sysshell.new FMS  >/dev/null 2>&1
PATH=/usr/fms/bin:/usr/fms/etc:/usr/bin/ph:$PATH:.
FMS_STORE=`sysstor -p store_number`; export FMS_STORE
#formato fecha = mm/dd/yy
fcpgchis $1 $2 |egrep "FECH|Real|Gerente|Sistem" |
awk '
BEGIN { idx_fech = 3; idx_tot1 = 42; idx_tot2 = 66; }
/FECH/ {
   tot = 1;
   for( i = 1; i <= NF ; i++ ) {
      if ( $i == "FECH" ) idx_fech = index($0,"FECH") - 1;
      if ( $i == "TOT" && tot == 2 ) {
         idx_tot2 = 49 + index(substr($0,50), "TOT") - 1;
      } 
      if ( $i == "TOT" && tot == 1 ) {
         idx_tot1 = index($0, "TOT") - 1;
         tot=2;
      } 
   }
}

/Real/ || /Gerente/ || /Sistem/ {
 if ( $NF ~ "Real" ) { fecha = substr($0,idx_fech,6); }
    tot1 = substr($0, idx_tot1, 5); 
    tot2 = substr($0, idx_tot2, 5); 
    descript = $NF;
    printf("%s|x|x|x|%d|x|x|x|%d|%s\n", fecha, tot1, tot2, descript);
}
' | grep Gerente
