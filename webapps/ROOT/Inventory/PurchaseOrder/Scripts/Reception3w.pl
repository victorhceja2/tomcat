#!/usr/bin/perl
use lib "/usr/bin/ph/databases/purchase_order/lib";
use poConnect;

($date_id)=@ARGV;
$recep_sus="/usr/fms/op/rpts/reception/$date_id";
#$recep_sus="/tmp/$date_id";
open(FS,">>$recep_sus") or die("No pude abrir $recep_sus: $!\n");
# Reformateo de fecha yyyy-mm-dd para el query
@date_parts=split(/\-/,$date_id);
$date_parts[0]+=2000;
$date_id=$date_parts[0]."-".$date_parts[1]."-".$date_parts[2];
$vacio=" ";
$header = sprintf("%3s %-6s %-26s %11s  %-26s %-11s %9s %9s\n",$vacio,Codigo, Producto,Cant, Discrepancia, Unidad, Precio, Subtotal);
$header .= sprintf("%3s %-6s %-26s %11s  %-26s %-11s %9s %9s",$vacio,Prod,$vacio,recib,$vacio, inv, unit, $vacio);
$separator .= sprintf("--------------------------------------------------------------------------------------------------------------");
$lsQuery = getQueryRecepsInADay($date_id);
$get_results = $dbh->prepare($lsQuery);
$get_results->execute();
if($get_results->rows == 0){
	print FS "\n\n\nNo existen recepciones para la fecha $date_id\n";
}else{
	while( $resptr =  $get_results->fetchrow_hashref() ){
		$reception_id = $resptr->{"reception_id"};
		$registro =  getProvider($reception_id);
		($provider_name,$provider_id)=split(/\|/,$registro);
		print FS "Recepcion: $reception_id\n" ;
		printf FS "%13s  %s\n\n", Proveedor, $provider_name;
		$lsQuery1 = getQueryRecep($reception_id, $provider_id);
		$get_results1 = $dbh->prepare($lsQuery1);
		$get_results1->execute();
		print FS "$header\n";
		print FS "$separator\n";
		while( $resptr1 =  $get_results1->fetchrow_hashref() ){
			$sort_num = $resptr1->{"sort_num"};
			$provider_product_code = $resptr1->{"provider_product_code"};
			$provider_product_desc = $resptr1->{"provider_product_desc"};
			$qty_received = $resptr1->{"qty_received"};
			$provider_unit = $resptr1->{"provider_unit"};
			$dif_desc = $resptr1->{"dif_desc"};
			$qty_received_inv = $resptr1->{"qty_received_inv"};
			$inv_unit = $resptr1->{"inv_unit"};
			$unit_cost = $resptr1->{"unit_cost"};
			$subtotal = $resptr1->{"subtotal"};

			printf FS "%-3s %-6s %-26s %7.2f %-4s %-26s %7.2f %4s %9.2f %9.2f\n",$sort_num, $provider_product_code, substr($provider_product_desc,0,25),$qty_received, substr($provider_unit,0,4), substr($dif_desc,0,25),$qty_received_inv,substr($inv_unit,0,4), $unit_cost,$subtotal;
		}
		print FS "$separator\n";
		$total = getTotal($reception_id);
		printf FS "%100s %9.2f\n",TOTAL,$total;
	}
}
close(FS);

sub getQueryRecepsInADay{
	my $date_idt=shift@_;
	local $sql = "";
	$sql .= "SELECT ";
	$sql .= "DISTINCT reception_id ";
	$sql .= "FROM op_grl_reception ";
	$sql .= "WHERE CAST(date_id AS CHAR(10)) LIKE '".$date_idt."%'";
	return $sql;
}

sub getProvider{
	my $reception_idt=shift@_;
	local $sql = "SELECT DISTINCT trim(prv.name) as name, prv.provider_id";
	$sql .= " FROM op_grl_cat_provider prv";
	$sql .= " INNER JOIN op_grl_reception_detail rd ON rd.provider_id = prv.provider_id";
	$sql .= " AND rd.reception_id = $reception_idt";
	$result = $dbh->prepare($sql);
	$result->execute();
	while( $resultptr =  $result->fetchrow_hashref() ){
		$name = $resultptr->{"name"};
		$provider_id= $resultptr->{"provider_id"};
	}
	$registro = "$name|$provider_id";
	return $registro;
}

sub getQueryRecep{
	my $reception_idt = shift@_;
	my $provider_idt = shift@_;
	local $sql = "SELECT";
	$sql .= " isnull(rd.sort_num,0) as sort_num,";
	$sql .= " trim(rd.provider_product_code) as provider_product_code,";
	$sql .= " p.provider_product_desc as provider_product_desc,";
	$sql .= " Ltrim(to_char(rd.received_quantity,'9999990.99')) as qty_received,";
	$sql .= " Ltrim(m.unit_name) as provider_unit,";
	$sql .= " dif_desc,";
	$sql .= " Ltrim(to_char(rd.received_quantity*p.conversion_factor,'9999990.99')) as qty_received_inv,";
	$sql .= " Ltrim(mm.unit_name) as inv_unit,";
	$sql .= " Ltrim(to_char(unit_cost,'9999990.99')) as unit_cost,";
	$sql .= " Ltrim(to_char(ROUND((rd.received_quantity*unit_cost),2),'9999990.99')) as subtotal";
	$sql .= " FROM";
	$sql .= " op_grl_reception r";
	$sql .= " INNER JOIN op_grl_reception_detail  rd ON r.reception_id=rd.reception_id";
	$sql .= " INNER JOIN op_grl_cat_providers_product p ON rd.provider_product_code=p.provider_product_code";
	$sql .= " LEFT JOIN op_grl_cat_difference d ON d.difference_id=rd.difference_id";
	$sql .= " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
	$sql .= " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p.provider_unit_measure";
	$sql .= " INNER JOIN op_grl_cat_unit_measure mm ON mm.unit_id = i.inv_unit_measure";
	$sql .= " WHERE r.reception_id = $reception_idt";
	$sql .= " AND p.provider_id = '$provider_idt'";
	$sql .= " ORDER BY 1";
	return $sql;
}

sub getTotal{
	my $reception_idt = shift@_;
	local $sql = " SELECT";
	$sql .= " to_char(ROUND(SUM((Case  When rd.received_quantity = Null then '0' else rd.received_quantity end)*rd.unit_cost),2),'9999990.99') as total";
	$sql .= " FROM op_grl_reception_detail rd";
	$sql .= " WHERE rd.reception_id = $reception_idt";
	$result = $dbh->prepare($sql);
	$result->execute();
	while( $resultptr =  $result->fetchrow_hashref() ){
		$total = $resultptr->{"total"};
	}
	return $total;
}
