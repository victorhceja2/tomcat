#!/usr/bin/perl

#use warnings;
# Cargar Librerias instaladas en una ruta especifica
use lib '/usr/local/tomcat/webapps/ROOT/Scripts/perl/lib/lib/perl/5.8.4/';
use lib '/usr/local/tomcat/webapps/ROOT/Scripts/perl/lib/share/perl/5.8.4';
use OpenOffice::OODoc;

# Subrutina para eliminar espacios en blanco
sub trim {
	my @out = @_;
    for (@out) {
    	s/^\s+//;
        s/\s+$//;
        s/\s+//;
	}
    return wantarray ? @out : $out[0];
}

# Subrutina que obtiene una fecha con formato MM/DD/YY recibiendo
# una fecha con formtato YY-MM-DD
sub split_date {
    my($year, $month, $day) = split('-', $_[0]);
    
    my $date = "$month/$day/$year";
}

sub get_cong_init_unix_date {
   my $unix_init_date = `/usr/fms/bin/syspdate -s $_[0]`;
   return $unix_init_date;
}

# Sumar 6 dias
sub get_cong_final_unix_date {
    my $unix_final_date = `/usr/fms/bin/syspdate -s $_[0]` + 518400;
    return $unix_final_date;
}

# Subrutina que le da formato a la salida del comando syspdate
# Del tipo YYMMDD a MM/DD/YY
sub format_date {
    my $norm_date = `/usr/fms/bin/syspdate -x $_[0]`;
    my $norm_date = substr($norm_date, 2, 2)."/".substr($norm_date, 4, 2)."/".substr($norm_date, 0, 2);
    return $norm_date;
}

# Subrutina que obtiene los datos de congelados a travÃs del comando fcpgchis
sub gen_fcpgchis_file {
    `. /usr/bin/ph/sysshell.new FMS > /dev/null 2>&1; /usr/fms/bin/fcpgchis $_[0] $_[1] | egrep "FECH|Real|Gerente" > /tmp/fcpgchis.tmp`;
}

# Subrutina que parsea los datos generados por la subrutina gen_fcpgchis
sub parse_fcpgchis_file {
    open(FCPGCHIS_FILE, "/tmp/fcpgchis.tmp") || die("No se pudo abrir el archivo");
    $idx_fech = 3;
    $idx_tot1 = 41;
    $idx_tot2 = 65;

    while (<FCPGCHIS_FILE>) {
        chomp;	# strip record separator
        @Fld = split(' ', $_, -1);
        if (/FECH/) {
	    $tot = 1;
	    for ($i = 1; $i <= $#Fld; $i++) {
	        if ($Fld[$i] eq 'FECH') {
		    $idx_fech = index($_, 'FECH') - 1;
	        }
	        if ($Fld[$i] eq 'TOT' && $tot == 2) {
	            $idx_tot2 = 49 + index(substr($_, 50), 'TOT') - 1;
	        }
	        if ($Fld[$i] eq 'TOT' && $tot == 1) {
	            $idx_tot1 = index($_, 'TOT') - 1;
		    $tot = 2;
	        }
	    }
        }

       if (/Gerente/) {
           if ($Fld[$#Fld] =~ 'Real') {
	       $fecha = substr($_, $idx_fech, 6);
	   }
	   $tot1 = substr($_, $idx_tot1, 5);

	   $tot2 = substr($_, $idx_tot2, 6);

	   $descript = $Fld[$#Fld];
	   printf "%s|x|x|x|%d|x|x|x|%d|%s\n", $fecha, $tot1, $tot2, $descript;
	   unshift(@tot_day,  $tot1 + $tot2);
       }
    } 
    print "@tot_day\n";
    close(FCPGCHIS_FILE);
    return @tot_day;
}

# este archivo es generado por el JSP:
# /usr/local/tomcat/webapps/ROOT/Statistic/ReportHours/Rpt/HourTransReportYum.jsp
my $query_file = "/tmp/queries_horarios_od_report";
# La hoja de calculo que se va a llenar
my $calcsheet = ooDocument(file => '/usr/local/tomcat/webapps/ROOT/Statistic/ReportHours/Rpt/Horarios.sxc');
# Se deben normalizar las celdas. Si no se hace, se tendran errores al llenarlas. Existe una especie
# de mapeo erroneo de estas.
my $sheet = $calcsheet->normalizeSheet("BD", 90, 14);

open(QUERY_FILE, $query_file) || die("No se pudo abrir el archivo");

my $data = <QUERY_FILE>;

close(QUERY_FILE);

# Se hace un preprocesamiento del archivo.
# eliminando espacios en blanco, dando saltos de linea, etc
$data =~ s/\)//g;
$data =~ s/\(//g;
$data =~ s/new\ Array/\n/g;
$data =~ s/^\n//g;
$data =~ s/^\s*//g;
$data =~ s/'//g;
$data =~ s/%//g;



open(TMP_FILE, ">/tmp/query.tmp");

#print "$data\n";
print TMP_FILE "$data\n";

close(TMP_FILE);

open(TMP_FILE, "/tmp/query.tmp");

my $f_destino  = 0;
my $f_delivery = 0;
my $f_carryout = 0;

# Ciclo que parsea cada linea del archivo query.tmp
# y llena las celdas correspondientes en la hoja de calculo
foreach $line (<TMP_FILE>) {
	chomp($line);
	chop($line);
	($uk1, $col1, $mar, $mier, $juev, $vie, $sab, $dom, $lun,$null) = split(',', $line);

	$uk1  = trim($uk1);
	$mar  = trim($mar);
	$mier = trim($mier);
	$juev = trim($juev);
	$vie  = trim($vie);
	$sab  = trim($sab);
	$dom  = trim($dom);
	$lun  = trim($lun);

	@days = ($mar, $mier, $juev, $vie, $sab, $dom, $lun);

	#print "$uk1|$col1|$mar|$mier|$juev|$vie|$sab|$dom|$lun\n";
	
	my $i = 0;

	# Porcentajes de Distribucion
	if($uk1 eq "a" && $f_destino == 0) {
		my @columns = qw(C D E F G H I);
		$f_destino = 1;
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."41", $days[$i]/100);
		}
	}	

	# Porcentajes de Delivery
	if($uk1 eq "c" && $f_delivery== 0) {
		my @columns = qw(C D E F G H I);
		$f_delivery = 1;
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."10", $days[$i]/100);
		}
	}	

	# Porcentajes de Delivery
	if($uk1 eq "d" && $f_carryout == 0) {
		my @columns = qw(C D E F G H I);
		$f_carryout = 1;
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."11", $days[$i]/100);
		}
	}	

	# Porcentajes de Dine In 
	if($uk1 eq "e") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."12", $days[$i]/100);
		}
	}	

	# De 11 a 12
	if($uk1 eq "g") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."14", $days[$i]/100);
		}
	}	

	# De 12 a 13
	if($uk1 eq "h") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."15", $days[$i]/100);
		}
	}	

	# De 13 a 14
	if($uk1 eq "i") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."16", $days[$i]/100);
		}
	}	

	# De 14 a 15
	if($uk1 eq "j") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."17", $days[$i]/100);
		}
	}	

	# De 15 a 16
	if($uk1 eq "k") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."18", $days[$i]/100);
		}
	}	

	# De 16 a 17
	if($uk1 eq "l") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."19", $days[$i]/100);
		}
	}	

	# De 17 a 18
	if($uk1 eq "m") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."20", $days[$i]/100);
		}
	}	

	# De 18 a 19
	if($uk1 eq "n") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."21", $days[$i]/100);
		}
	}	

	# De 19 a 20
	if($uk1 eq "o") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."22", $days[$i]/100);
		}
	}	

	# De 20 a 21 
	if($uk1 eq "p") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."23", $days[$i]/100);
		}
	}	

	# De 21 a 22 
	if($uk1 eq "q") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."24", $days[$i]/100);
		}
	}	

	# De 22 a 23 
	if($uk1 eq "r") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."25", $days[$i]/100);
		}
	}	

	# De 23 a 24 
	if($uk1 eq "s") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."26", $days[$i]/100);
		}
	}	

	# HutCheese 
	if($uk1 eq "u") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."29", $days[$i]/100);
		}
	}	

	# Pizzas x Pedido
	if($uk1 eq "v") {
		my @columns = qw(C D E F G H I);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."30", $days[$i]);
		}
	}	

	# Actual
	if($uk1 eq "b" && $col1 eq "Actual") {
		my @columns = qw(B C D E F G H);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."36", $days[$i]);
		}
	}	

	# Anterior
	if($uk1 eq "d" && $col1 eq "Anterior") {
		my @columns = qw(B C D E F G J);
		for($i = 0; $i < 7; $i++) {
			$calcsheet->updateCell($sheet, $columns[$i]."37", $days[$i]);
		}
	}	
	# Year
	if($uk1 eq "Year") {
		$calcsheet->updateCell($sheet, "C4", $col1);
	}
	# Period
	if($uk1 eq "Period") {
		$calcsheet->updateCell($sheet, "C2", $col1);
	}
	# Week
	if($uk1 eq "Week") {
		$calcsheet->updateCell($sheet, "C3", $col1);
	}
	# Date
	if($uk1 eq "Date") {
		$calcsheet->updateCell($sheet, "C5", $col1);
		$od_date = split_date($col1);
	}
}

$cong_init_date = format_date(get_cong_init_unix_date($od_date));
print "cong_init_date = $cong_init_date\n";
my $cong_final_date= format_date(get_cong_final_unix_date($od_date));
print "cong_final_date = $cong_final_date\n";

# Se genera el archivo cno los datos del congelado en base a las fechas calculadas
gen_fcpgchis_file($cong_init_date, $cong_final_date);
# Se parsea el archivo para obtener la suma de los congelados del Gerente
my @cong_data = parse_fcpgchis_file();

# Se llenan las celdas correspondientes con los datos del congelado
my @columns = qw(C D E F G H I);
for($i = 0; $i < 7; $i++) {
    $calcsheet->updateCell($sheet, $columns[$i]."43", pop(@cong_data));
}

close(TMP_FILE);
$calcsheet->save;

#unlink $query_file;
#unlink "/tmp/query.tmp"; 

