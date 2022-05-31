#!/usr/bin/perl 
################################################################################
#
# Autor: GAR
# Fecha: 2008/Abr/03
# Descripcion: Genera salida reporte tckets de auditoria KFC
#
################################################################################
########## Declaracion de Variables ############

#Archivo tar contenedor de los pana "Entrada de usuario"
$arctar = "";
#Archivo Z contenedor de los tickets de delivery "Entrada de usuario"
$achtick = "";
#Ruta absoluta de directiori pana
$ruta = "/usr/fms/op/rpts/pana/";
#Ruta absoluta de directiori pana
#$dir	= "/pana/";
#Ruta directorio histick
$hist	= "/usr/fms/op/rpts/histick/";
#fecha archivo zip a descomprimir "Entrada usuario"
$arczip	= "";
#Nombre archivo a consultar "Entrada usuario"
$arcnom	= "";
#Ticket a consultar "Entrada usuario"
$ticket 	= "";
$ticketh	= "";
#Nombre de archivo de salida "Entrada usuario"
$arch 		= "";
#Banderas de impresion de archivo
$sav 		= "0";
$imp		= "0";
#Contador
$count 		= 0;
#array para poner el ticket en el orden correcto ya que esta invertido
@array_pastick 	= ();
#Bandera de impresion
$dif = "0";
#Arreglo con tickets de delivery
@array_saltick = ();
#bandera de busqueda en archivos del dia
$ftoday     = "";


$busq = "0";

########### Recepcion de Parametros #########
($arctar,$arczip,$arcnom,$arch,$achtick,$ftoday,$ticket) = @ARGV;
#($arctar,$caja,$arczip,$arcnom,$arch,$ticket) = @ARGV;

$ticketh = $ticket;

########### Formateo de Ticket ###########

if($ftoday eq "1"){
	`./histloc.s`;
    $archiv = "/usr/fms/op/print1/pana.0?.sus";
	chomp($archiv);
	@array_tickcom =qx/cat $archiv/;
	#Recupera ticket de pana
	### @array_panatick =qx/grep -a 'TICKET UNICO:' $archiv | cut -d":" -f3/;
    @array_panatick =qx/egrep -a 'TICKET UNICO:|No. ticket unico:' $archiv | cut -d":" -f3/;
	$dirtempo = qx/mktemp -d/;
	chomp($dirtempo);
	$archiv = "/tmp/$arch.h.Z";
	chomp($archiv);
	`zcat $archiv > $dirtempo/deliver.txt`;
	#Recupera los numeros de ticket de el histick
	@array_histick =qx/egrep -a '\/[0-9][0-9]\-[0-9][0-9][0-9][0-9]' $dirtempo\/deliver.txt | cut -d"-" -f2 | cut -d" " -f1/;
}
else{
	########### Extraxion y desempaquetado de archivo ##############
	$archiv = "$ruta$arctar";

	chomp($archiv);
	$dirtempo = qx/mktemp -d/;
	chomp($dirtempo);
	`tar xf $archiv -C $dirtempo`;
	`gunzip $dirtempo/*.*.$arczip`;
	########### Extraccion y copia de archivo histick ##############
	$archiv = "$hist$achtick";
	chomp($archiv);
	`zcat $archiv > $dirtempo/deliver.txt`;
	@array_tickcom =qx/cat $dirtempo\/pana.0?.$arcnom/;
	#Recupera los numeros de ticket de el histick
	@array_histick =qx/egrep -a '\/[0-9][0-9]\-[0-9][0-9][0-9][0-9]' $dirtempo\/deliver.txt | cut -d"-" -f2 | cut -d" " -f1/;
	#Recupera ticket de pana
	@array_panatick =qx/egrep -a 'TICKET UNICO:|No. ticket unico:' $dirtempo\/pana.0?.* | cut -d":" -f3/;
}


########## Generacion y Formateo de archivo de salida ###########
open (LOG, ">/tmp/$arcnom.txt") or warn ("No se pudo abrir el archivo: $!");

#Ordeno los arreglos.
@array_histick = sort(@array_histick);
@array_panatick = sort(@array_panatick);
@array_tickcom = reverse @array_tickcom;
chomp(@array_tickcom);
foreach $line1 (@array_tickcom){
	chomp($line1);
	$line1 =~ s/[\xd]//g;
	$line1 =~ s/[^\w.\s\:\/\-\(\)\,\.\=\>\<\%\$\#\+\*\']//g;
	if($ticket eq ""){
		push(@array_pastick, $line1);
		if(($line1 =~/YB OPERADORA S/) || ($line1 =~/- - - - - - -/) || $line1 =~ /PREMIUM RESTAURANT/ ){
			$salto = "***SALTO***\n";
			chomp($salto);
			push(@array_pastick, $salto);
		}
	}
	else{
		### if($line1 =~/UNICO:$ticket/){
		if($line1 =~/UNICO:\s+${ticket}$/ || $line1 =~/unico:\s${ticket}\s+$/ ){
			push(@array_pastick, (@array_tickcom[($count - 1)]));
			$sav = "1";
		}
		### if(($line1 =~/solo se factura/) || ($line1 =~/- - - - - - -/)){
		if(($line1 =~/solo se factura/) || ($line1 =~/- - - - - - -/)){
			$sav = "0";
		}
		if($sav eq "1"){
			push(@array_pastick, $line1);
		}
	}
	$count++;
}
@array_pastick = reverse @array_pastick;
foreach $line2 (@array_pastick){
	chomp($line2);
	print LOG "$line2 \n";
}

#Formateo de tickets de pana para comparacion con tickets histick
foreach $line2 (@array_panatick){
	chomp($line2);
	$line2 =~ s/[^\d.]//g;
	if(length($line2) > 0){
		$numblan = 0;
		for($i=4;length($line2)<$i;$i--){
			$numblan++;
		}
		if($numblan == 1){
			$line2 = "0$line2";
		}
		elsif($numblan == 2){
			$line2 = "00$line2";
		}
		elsif($numblan == 3){
			$line2 = "000$line2";
		}
	}
}
#Busqueda de tickets de delivery
foreach $line4 (@array_histick){
	chomp($line4);
	foreach $line2 (@array_panatick){
		chomp($line2);
		if($line4 =~/$line2/){
			$dif = "1";
		}
	}
	if($dif eq "0"){
		push(@array_saltick, $line4);		
	}
	$dif = "0";
}
$sav = "0";

if(length($ticketh) > 0){
	$numblan = 0;
	for($i=4;length($ticketh)<$i;$i--){
		$numblan++;
	}
	if($numblan == 1){
		$ticketh = "0$ticketh";
	}
	elsif($numblan == 2){
		$ticketh = "00$ticketh";
	}
	elsif($numblan == 3){
		$ticketh = "000$ticketh";
	}
}

foreach $line9 (@array_saltick){
	chomp($line9);
	if($line9 =~/$ticketh/){
		$busq = "1";
	}
}


if($ticket eq ""){
	#print LOG "\n\n *********************** DELIVERY *********************** \n\n";
	foreach $line6 (@array_saltick){
		chomp($line6);
		@array_infotick =qx/cat $dirtempo\/deliver.txt/;
		chomp(@array_infotick);
		print LOG "***SALTO***\n";
		foreach $line5 (@array_infotick){
			chomp($line5);
			$line5 =~ s/[\xd]//g;
			$line5 =~ s/[^\w.\s\:\/\-\(\)\,\.\=\>\<\%\$\#\+\*]//g;
			if(($line5 =~/\-$line6/) || ($line5 =~/\s\s$line6/)){
				$sav = "1";
				$imp = "1";
			}
			if(($line5 =~/[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]\-[0-9][0-9][0-9][0-9]/) && !($line5 =~/$line6/)){
				$sav = "0";
				if($imp eq "1"){
					print LOG "\n";
					print LOG "\n";
					$imp = "0";
				}
			}
			if($sav eq "1"){
				print LOG "$line5 \n";
			}
		}
		$sav = "0";
		$imp = "0";
	}
}
elsif($busq eq "1"){
	#print LOG "\n\n *********************** DELIVERY *********************** \n\n";
	@array_infotick =qx/cat $dirtempo\/deliver.txt/;
	chomp(@array_infotick);
	#print LOG "***SALTO***\n";
	foreach $line5 (@array_infotick){
		chomp($line5);
		$line5 =~ s/[\xd]//g;
		$line5 =~ s/[^\w.\s\:\/\-\(\)\,\.\=\>\<\%\$\#\+\*]//g;
		if(($line5 =~/\-$ticketh/) || ($line5 =~/\s\s$ticketh/)){
			$sav = "1";
			$imp = "1";
		}
		if(($line5 =~/[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]\-[0-9][0-9][0-9][0-9]/) && !($line5 =~/$ticketh/)){
			$sav = "0";
			if($imp eq "1"){
				print LOG "\n";
				print LOG "\n";
				$imp = "0";
			}
		}
		if($sav eq "1"){
			print LOG "$line5 \n";
		}
	}
}
close LOG;

`rm -rf $dirtempo`;
`rm -rf /tmp/*.h.Z`;
