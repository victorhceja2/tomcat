#!/usr/bin/perl
#

use IO::Handle;
use lib "/usr/bin/ph/databases/purchase_order/lib";
use poConnect;

$today_completo_inicio=qx/date '+%y-%m-%d %k:%M:%S'/;
$archivo_log="/usr/local/tomcat/webapps/ROOT/Inventory/PurchaseOrder/Scripts/generatefiles.log";
open(LOG,">>$archivo_log") or warn ("No pude abrir $archivo_log: $!\n");
printf LOG "Inicio %s", $today_completo_inicio;

BEGIN
{
   open(ERR, ">/tmp/generatefiles.err") or warn ("ERROR STDERR:$!\n"); 
   open(OUT, ">/tmp/generatefiles.out") or warn ("ERROR STDOUT:$!\n"); 
   STDERR->fdopen(\*ERR, "w") or warn ("$today_completo_inicio -> No se pudo direccionar la salida de error:$!\n");
   STDOUT->fdopen(\*OUT, "w") or warn ("$today_completo_inicio -> No se pudo direccionar la salida standard:$!\n");
}

if($#ARGV < 1){
   $store_id = qx/\/usr\/bin\/ph\/unit.s/;
   chomp($store_id);
   if($#ARGV < 0){
       $today = qx/phpqdate/;
   }else{
       $today = $ARGV[0];
   }
   $today =~ s/\-//g;
   chomp($today);
   $year = substr($today,0,2);
   $month = substr($today,2,2);
   $day = substr($today,4,2);
   $today = $year."-".$month."-".$day;
}else{
   ($store_id, $reception_id)=@ARGV;
   #Obtenemos la fecha de la recepcion 
   $qry = "select to_char(date_id, 'YY-MM-DD') from op_grl_reception where reception_id = $reception_id";
   $rs_qry = $dbh->prepare($qry);
   $rs_qry->execute();
   $today = $rs_qry->fetchrow();
   chomp($today);
   ($year,$month,$day) = split("-",$today);
}

$path_file="/usr/bin/ph/rpcost/$today.fms";

open(FS,">>$path_file") or die ("No pude abrir $path_file: $!\n");

# Con este array hash se pretende no concatenar los registros que ya esten en el archivo
@arpcost = qx/cat $path_file/;
foreach $line (@arpcost){
    chomp($line);
    @field = split(",",$line);
    $field[0] =~ s/\s//g;
    $field[3] =~ s/^\s*//g;
    $field[3] =~ s/\s*$//g;
    #$field[4] =~ s/\s//g;
    #$aexist{$field[0].$field[3].$field[4]} = 1;
    $aexist{$field[0].$field[3]} = 1;
}
#Para el archivo sdc
$store_id_formated = sprintf("%05d", $store_id);

if($month eq "10"){
    $extension ="a$day";
}elsif($month eq "11"){
    $extension ="b$day";
}elsif($month eq "12"){
    $extension ="c$day";
}else{
    $extension =sprintf("%d%02d", $month, $day);
}

$path_file2="/usr/fms/op/rpts/sdc_drt/" . $store_id_formated . "drt." . $extension;
open(FS2,">>$path_file2") or die("No pude abrir $path_file2: $!\n");

$sql  = "SELECT rtrim(p.inv_id) as inv_id,TO_CHAR(r.date_id,'YY-MM-DD') as date_id, TO_CHAR(r.date_id,'MMDDYY') as date_id2, ";
$sql .= "rd.received_quantity as received_quantity, p.conversion_factor, rtrim(r.document_num) as document_num, " ;
$sql .= "p.provider_price, rtrim(p.provider_id) as provider_id, r.store_id as store_id, rtrim(p.stock_code_id) as stock_code_id, ";
$sql .= "(rd.received_quantity * rd.unit_cost) as cost ";
$sql .= "FROM op_grl_reception r ";
$sql .= "LEFT JOIN op_grl_reception_detail rd ON rd.reception_id = r.reception_id and rd.store_id=r.store_id ";
$sql .= "LEFT JOIN op_grl_cat_providers_product p ON p.provider_id =rd.provider_id AND p.provider_product_code = rd.provider_product_code ";
$sql .= "WHERE r.store_id=$store_id ";
$sql .= "AND CAST(r.date_id AS CHAR(10)) like '20$today%' ";
$get_results = $dbh->prepare($sql);
$get_results->execute();
while( $resptr =  $get_results->fetchrow_hashref() ){
    $inv_id = $resptr->{"inv_id"};
    $inv_id =~ s/\s//g;
    $date_id = $resptr->{"date_id"};
    $date_id2 = $resptr->{"date_id2"};
    $received_quantity = $resptr->{"received_quantity"};
    $conversion_factor = $resptr->{"conversion_factor"};
    $document_num= $resptr->{"document_num"};
    $document_num =~ s/^\s*//g;
    $document_num =~ s/\s*$//g;
    $provider_price = $resptr->{"provider_price"};
    $provider_price =~ s/\s//g;
    $provider_id = $resptr->{"provider_id"};
    $store_id = $resptr->{"store_id"};
    $stock_code_id = $resptr->{"stock_code_id"};
    $unit_cost = $resptr->{"cost"};
    $provider_id = $resptr->{"provider_id"};
    
    # Con esto solo escribe los que no esten
    if($aexist{$inv_id.$document_num} != 1){ # Con esto solo escribe los que no esten
        printf FS ("%s, %s, %9.2f, %s, %15.2f, %s,\n", $inv_id, $date_id, $received_quantity * $conversion_factor, $document_num, $provider_price, $provider_id);
        printf FS2 ("%05d, %s, %s, %9.2f, %s, %15.2f, %s,\n", $store_id, $stock_code_id, $date_id2, $received_quantity, $document_num, $unit_cost, $provider_id);
    }
}
# Esta parte es para excepciones
$qry ="SELECT rtrim(ltrim(p.inv_id)) as inv_id, TO_CHAR(e.date_id,'YY-MM-YY') as date_ide, ";
$qry.="rtrim(ltrim(e.document_num)) as document_num, rtrim(ltrim(r.provider_id)) as provider_id, ";
$qry.="ed.unit_cost, Ltrim(to_char((p.conversion_factor * ed.received_quantity),'9999990.99')) as inv_received ";
$qry.="FROM op_grl_exception e ";
$qry.="INNER JOIN op_grl_reception r ON r.reception_id = e.reception_id ";
$qry.="INNER JOIN op_grl_exception_detail ed ON ed.exception_id = e.exception_id ";
$qry.="INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = ed.provider_product_code ";
$qry.="INNER JOIN op_grl_cat_unit_measure up ON up.unit_id = p.provider_unit_measure ";
$qry.="WHERE CAST(e.date_id AS CHAR(10))like '20$today%' ";
print "psql -U postgres -c\"$qry\" -d dbeyum \n";
$get_exceptions = $dbh->prepare($qry);
$get_exceptions->execute();
while( $rs_exceptions = $get_exceptions->fetchrow_hashref() ){
    $document_num = $rs_exceptions->{"document_num"}; 
    $provider_id = $rs_exceptions->{"provider_id"}; 
    $inv_id = $rs_exceptions->{"inv_id"}; 
    $unit_cost = $rs_exceptions->{"unit_cost"}; 
    $inv_received = $rs_exceptions->{"inv_received"}; 
    $date_ide = $rs_exceptions->{"date_ide"}; 

    if($aexist{$inv_id.$document_num} != 1){ # Con esto solo escribe los que no esten
         printf FS "%s, %s, %9.2f, %s, %14.2f, %s,\n", $inv_id, $date_ide, $inv_received, $document_num, $unit_cost, $provider_id;
    }
}

$today_completo_fin=qx/date '+%y-%m-%d %k:%M:%S'/;
printf LOG "Fin    %s", $today_completo_fin;
close(FS2);
close(FS);
close(LOG);
