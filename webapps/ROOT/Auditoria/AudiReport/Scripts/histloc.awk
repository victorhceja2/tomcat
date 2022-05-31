#
# Toma su entrada del comando phpqpr 01 1 7 >  $DIR_REPOUT/tmp.txt  
#
function inicia()
{ 			## Inicializa variables

	LANGFILE= "lang00"
	TKPATH  = ENVIRON["TKPATH"]
	OUTFILE = ENVIRON["DEVOUT"]
	INFILE  = ENVIRON["DEVIN"]
	PRFOOT1 = "F"
	PRFOOT2 = "T"
	TKDEF   = TKPATH "/tkdef"   # Archivo machote para ticket
	LOGFILE = "/dev/null"        		# Archivo de log
	DATFILE = TKPATH "/tkdata"	# Archivo de info de unidad
	INITICK = "[0-9][0-9]:[0-9][0-9] ..* [0-9][0-9]/[0-9][0-9]/[0-9][0-9]-[0-9][0-9][0-9][0-9]"
	FHPOS   = 4			# Posicion de la fecha en linea 1
	HRPOS   = 3			# Posicion de la fecha en linea 1
	USPOS   = 2			# Posicion de la fecha en linea 1
	TAMTICK = 24		# Longitud del ticket
	tick = 0
	princ = 1
	fin = 1
	itnum = 1
}

BEGIN {
    ## Programa principal
    flg_final = 0;

	debug = "" #"datos llaves flujo logic salida"

	inicia()    # inicializa variables globales
	get_data()  # obtiene las leyendas en espanol para escribir el ticket
    j = 0;      # el indice j avanza de TAMTICK en TAMTICK(24)
	while ( ( getline line < INFILE ) > 0 ) {
        j++;
        if ( j == TAMTICK ) {               ### imprime paginas de tamano 24
			for(i=1; i<= TAMTICK ; i++ ) {  ### no necesita mas
				imprime( ticket[i])
				ticket[i] = "";             ### blanquea la linea
				ESDELI=0
            }
            j = 0;
        }
		if ( j == 1 ) {
			tick  = 1
			tot = ""
			princ = 0 
			get_pllaves();
		}

	    if ( line ~ total ) {
		    var=match(line,"[0-9][0-9]*\\\.[0-9][0-9]")
		    len = RLENGTH
		    totcad = substr(line,int(var),int(len))
		    tot = sprintf("%" len ".2f", totcad/1.1 )
		    totlin = j
		    princ = 1
		    flg_final = 1;
	    }

		if ( line ~ subtotal ) {
			var = match(line,"[0-9][0-9]*\\\.[0-9][0-9]")
			len = RLENGTH
			stotcad = substr(line, int(var), int(len) )
			subtot = sprintf("%" len ".2f", stotcad/1.1 )
		}

		if ( line ~ /REPETIR/  || line ~ /CLNTE NUEVO/ ) {
		   ESDELI=1
                }

		ticket[j]=line	 ### acumula las lineas 

		if ( flg_final == 1 ) {
			tick = 0
			exe = "letra " totcad    ### convierte a letras
			exe | getline exe_sal    ### convierte a letras
			close(exe)
			if( princ == 1 ) {
				ticket[totlin+1] = " " exe_sal   ### para imprimir cantidad
				ticket[totlin+2] = " " UNIDAD    ### para imprimir unidad
				ticket[totlin+3] = " " UADDR     ### para imprimir direccion
			} else {
                ticket[totlin+1] = " "
                ticket[totlin+2] = " "
                ticket[totlin+3] = " "
            }

            if ( ESDELI == 1 ) {
			   cargo=totcad-stotcad
               leyenda=sprintf("Cargo por Servicio    %6.2f", cargo)

			   linea=sprintf("%-13s              Cargo por Servicio %6.2f", ticket[totlin-1], cargo)
	           ticket[totlin-1]=linea


		ESDELI=0
            }  

            elim_sobr(); 
            j = j + 3; 
			flg_final = 0;     # reset a la bandera
		}
	}
	close(INFILE)
} 

function elim_sobr()
{
	## Elimina 3 lineas finales sobrantes
    getline bas < INFILE
    getline bas < INFILE
	getline bas < INFILE
}

  function get_data()
  { 		# Extrae datos del archivo lang00.r (SUS)
	
	getline UNIDAD < DATFILE
	getline UADDR < DATFILE
	getline MESG < DATFILE
	close(DATFILE)

    # lee las leyendas en Español del
    # archivo de configuracion del lenguaje
    #
	"sed -n '2252p' /usr/fms/op/cfg/" LANGFILE | getline total 
	close("sed '2252p' /usr/fms/op/cfg/" LANGFILE)
	"sed -n '2244p' /usr/fms/op/cfg/" LANGFILE | getline subtotal 
	close("sed '2244p' /usr/fms/op/cfg/" LANGFILE)
	"sed -n '1491p' /usr/fms/op/cfg/" LANGFILE | getline final 
	close("sed -n '1491p' /usr/fms/op/cfg/" LANGFILE) 
	"sed -n '2241p' /usr/fms/op/cfg/" LANGFILE | getline empml
	close("sed -n '2241p' /usr/fms/op/cfg/" LANGFILE ) 
	"sed -n '2223p' /usr/fms/op/cfg/" LANGFILE | getline cancel
	close("sed -n '2223p' /usr/fms/op/cfg/" LANGFILE )
	"sed -n '2216p' /usr/fms/op/cfg/" LANGFILE | getline extras
	close("sed -n '2216p' /usr/fms/op/cfg/" LANGFILE )
	"sed -n '2217p' /usr/fms/op/cfg/" LANGFILE | getline abajo
	close("sed -n '2217p' /usr/fms/op/cfg/" LANGFILE )
	"sed -n '2228p' /usr/fms/op/cfg/" LANGFILE | getline mealdeal
	close("sed -n '2228p' /usr/fms/op/cfg/" LANGFILE )
	"sed -n '2225p' /usr/fms/op/cfg/" LANGFILE | getline reimpr
	close("sed -n '2225p' /usr/fms/op/cfg/" LANGFILE )
	reimpr = substr(reimpr,1,6)

    #
    # Asigna los destinos EN COMEDOR, ENTREGA, P/LLEVAR, VENTANA
    #
	for( i=0 ; i<5 ; i++) {
		"sed -n '2050,2053p' /usr/fms/op/cfg/" LANGFILE | getline occ[i] 
		if( debug ~ "datos" ) print "ocasiones " i "  : " occ[i]
	}
	close("sed -n '2050,2053p' /usr/fms/op/cfg/" LANGFILE )
	split(occ[3],args,"\%")
	split(args[1],nargs,"\(")
	occ[3] = nargs[1]

    #
    # CUPONES(%d), COM EMPL, DESCUENT, CREDIT
    #
	for( i=0 ; i<4 ; i++) {
		"sed -n '2240,2243p' /usr/fms/op/cfg/" LANGFILE | getline desc[i]
		if( debug ~ "datos" ) print "descuentos " i " : " desc[i]
	}
	close("sed -n '2240,2243p' /usr/fms/op/cfg/" LANGFILE )
	split(desc[0],args,"\%")
	split(args[1],nargs,"\(")
	desc[0] = nargs[1]

	if( debug ~ "datos" ) {
		print "total        :" total
		print "subtotal     :" subtotal
		print "final        :" final
		print "unidad       :" UNIDAD 
		print "direccion    :"  UADDR
		print "empml        :"  empml
		print "cancel       :"  cancel
		print "extras       :"  extras
		print "abajo        :"  abajo
		print "mealdeal     :"  mealdeal
		print "Reimpr : " reimpr 
		print " Oprima ENTER para continuar ... "
		getline bas < "/dev/tty"
	}
 }

function imprime(cadena)
{
	###print "debug: " cadena
	print cadena > OUTFILE
	print cadena > LOGFILE
}

function get_pllaves()
{
	if( debug ~ "flujo" ) print "INICIO ---------------->" line
	phone = ""
	sub(" CAMBIO ","_CAMBIO_",line)
	split(line, nargs, " ")
	if( line ~ "[012][0-9]:[0-9][0-9]  *[0-9][0-9]/[0-9]"){
		FHPOS = 4
		pr_case = " "
	}
	else {
		FHPOS = 4
		pr_case = nargs[FHPOS] 
		FHPOS = 5
	}
	split(nargs[FHPOS], args, "-")
	date = args[1] 
	hour =  nargs[HRPOS] 
	user = nargs[USPOS] 
	ticknum = args[2] 
}


