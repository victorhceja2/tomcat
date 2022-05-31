#!/bin/bash

function uso(){
   echo -e "Uso:\t$0 [OPC]"
   echo -e ""
   echo "Opciones:"
   echo -e "\t-f|-F FMS"
   echo -e "\t-s|-S SUS"
}

#--------------------------------------------------------------
# Se parsean los argumentos
#--------------------------------------------------------------
function parseArgs(){
   val=0;
   if [ $# -gt 0 ]; then
   	# las opciones se procesan por pares
   	while [ $# -gt 0 ]; do
       		case $1 in
      		     -f|-F) readEmplFMS $2
          	    	    exit 0
          	    	    ;;
      		     -a|-A) readAllEmplFMS
          	    	    exit 0
          	    	    ;;
      		     -i|-I) readEmplIDs $2
          	    	    exit 0
          	    	    ;;
      		     -s|-S) readEmplSUS $2
          	    	    exit 0
          	    	    ;;
      		     -d|-D) readEmplDB $2
          	    	    exit 0
          	    	    ;;
			-C) readEmplSUSSecLev
          	    	    exit 0
          	    	    ;;
      			*)  echo "$0: Opcion no reconocida --> $1"
          	    	    echo "Intente $0 -h para más informacion."
          	    	    val=1
		    	    ;;
      		esac
      		shift
    	done
   else
   	val=1
   fi

   return $val
}

#--------------------------------------------------------------
# readEmplFMS
# 1: RFC
# 2: NOMBRE
# 3: ACC
# 4: AP PATERNO
# 5: AP MATERNO
# 6: NO. CASA
# 7: CALLE
# 8: CLAVE
# 9: CP
#10: TELEFONO
#11: FECHA NAC
#12: SEXO
#13: NO EMPL
#14: FECHA EFECTIVA
#15: TIPOEMPL NO
#16: TIPOEMPL DESC
#17: DEPTO
#18: PUESTO
#19: LICENCIA
#20: LICENCIA VENC
#21: SEGID
#--------------------------------------------------------------
function readEmplFMS(){
  if [ $# -eq 0 ]; then
    /usr/bin/ph/emplalt/bin/empl2ascii.s /usr/fms/data/hrcempl.dat | 
      cut -f 1,3,4,5,10-16,18,22,23,31,32,81,82,91,93,98,102 -d'|' | sort |  egrep -v "^[0-9]" | sed 's/||/| |/g' | sed 's/||/| |/g' |
	awk -F\| '{  if ($13 != " " && $22 !~ "010") print $13"|"$4" "$5"|"$2}'
  else
    /usr/bin/ph/emplalt/bin/empl2ascii.s /usr/fms/data/hrcempl.dat |
      cut -f 1,3,4,5,10-16,18,22,23,31,32,81,82,91,93,98 -d'|' |  egrep -v "^[0-9]" | sed 's/||/| |/g' | sed 's/||/| |/g' | grep -i "|${1}|" 
  fi
}

function readAllEmplFMS(){
    /usr/bin/ph/emplalt/bin/empl2ascii.s /usr/fms/data/hrcempl.dat | 
      cut -f 1,3,5,10,22,23,31,102 -d'|' |  egrep -v "^[0-9]" | sed 's/||/| |/g' | sed 's/||/| |/g' |
        awk -F\| '{  if ($5 != " " && $8 !~ "010") print $5"|"$1"|"$2"|"$3"|"$4"|"$6"|"$7"|"$8}'
}

function readEmplSUS(){
  . /usr/bin/ph/sysshell.new SUS >/dev/null 2>&1
  if [ $# -eq 0 ]; then
    /usr/fms/op/bin/phtbpr -u empl 2> /dev/null | egrep -v "RESTAURANTE" | cut -f 3,4,8-12,16 -d'|'
  else
    /usr/fms/op/bin/phtbpr -u empl 2> /dev/null | egrep -v "RESTAURANTE|records" | cut -f 3,4,8-12,16 -d'|' | grep -i "|${1}" > /tmp/dattmp.asc
    cat /tmp/dattmp.asc
  fi
}

function readEmplDB(){

  psql -d dbeyum -U postgres -c "select employee_id from ss_cat_emp_sorpi UNION select employee_id from ss_cat_emp_sarpi" | sed 's/ *|/|/g'  | sed 's/^ *//g' | sed 's/| */|/g' | egrep '^[0-9]' | cut -d'|' -f1,2,3,4 | awk -F\| '{  if ($1 != " " ) print $1"|"$2" "$3"|"$4}'

}

function readEmplSUSSecLev(){
  . /usr/bin/ph/sysshell.new SUS >/dev/null 2>&1
  /usr/fms/op/bin/phtbpr -u sect 2> /dev/null | cut -f 3,7 -d'|'
}

function readEmplIDs(){
  . /usr/bin/ph/sysshell.new SUS >/dev/null 2>&1
  if [ $# -eq 0 ]; then
    /usr/bin/ph/emplalt/bin/emplshowpass.s /usr/fms/data/hrcempl.dat | 
      awk ' $4 !~ '010'  { print $1","$NF }' 
  else
    /usr/bin/ph/emplalt/bin/emplshowpass.s /usr/fms/data/hrcempl.dat | 
      awk ' $4 !~ '010'  { print $1","$NF }' | grep $1
  fi
}

# Main
parseArgs $@
ret=$?

if [ $ret -ne 0 ]; then
    uso
    exit
fi
