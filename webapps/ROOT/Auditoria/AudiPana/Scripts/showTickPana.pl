#!/usr/bin/perl 
################################################################################
#
# Autor: GAR
# Fecha: 2008/Abr/03
# Descripcion: Genera salida reporte tickets de auditoria pana KFC
#
################################################################################
########## Declaracion de Variables ############

#Archivo tar contenedor de los pana "Entrada de usuario"
$arctar 	= "";
#Ruta absoluta de directiori pana
$ruta 		= "/usr/fms/op/rpts/pana/";
#Ticket a consultar "Entrada usuario"
$ticket 	= "";
#Banderas de impresion de archivo
$sav 		= "0";
#array para poner el ticket en el orden correcto 
@array_pastick 	= ();
#bandera de busqueda en archivos del dia
$ftoday		= "";

########### Recepcion de Parametros #########
($arctar,$ftoday,$ticket) = @ARGV;

if(length($ticket) == 1){
	$ticket = "0$ticket";
}

if($ftoday eq "1"){
	$archiv = "/usr/fms/op/print1/pana.AU";
	@array_tickcom =qx/cat $archiv/;
}
else{
	$archiv = "$ruta$arctar.au.gz";
	chomp($archiv);
	@array_tickcom =qx/zcat $archiv/;	
}



########## Generacion y Formateo de archivo de salida ###########
open (LOG, ">/tmp/$arctar.au.txt") or warn ("No se pudo abrir el archivo: $!");

#Ordeno los arreglos.
chomp(@array_tickcom);
foreach $line1 (@array_tickcom){
	chomp($line1);
	$line1 =~ s/[\xd]//g;
	$line1 =~ s/[^\w.\s\:\/\-\(\)\,\.\=\>\<\%\$\#\+\*\']//g;
	if($ticket eq ""){
		push(@array_pastick, $line1);
		if(($line1 =~/REG[0-9][0-9][0-9][0-9]/)){
			$salto = "***SALTO***\n";
			chomp($salto);
			push(@array_pastick, $salto);
		}
	}
	else{
		if($line1 =~/#[0-9]$ticket/){
			$sav = "1";
		}
		if(($line1 =~/REG[0-9][0-9][0-9][0-9]/)){
			if($sav eq "1"){
				push(@array_pastick, $line1);
				$salto = "***SALTO***\n";
				chomp($salto);
				push(@array_pastick, $salto);
			}
			$sav = "0";
		}
		if($sav eq "1"){
			push(@array_pastick, $line1);
		}
	}
}
foreach $line2 (@array_pastick){
	chomp($line2);
	print LOG "$line2 \n";
}
close LOG;

