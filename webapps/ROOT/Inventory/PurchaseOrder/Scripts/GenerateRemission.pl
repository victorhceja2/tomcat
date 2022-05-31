#!/usr/bin/perl
use lib "/usr/bin/ph/databases/purchase_order/lib";
use poConnect;

$usage=__FILE__ ." ".num_orden;
$help=<<EOF;
  Carga en la base de datos una remision de prueba para proveedor PFS
EOF

die "\n\nUso: $usage\n\n$help\n" if ($#ARGV<0);
($order_id)=@ARGV;
$store_id=qx/unit.s/;

$today=qx/date '+%y-%m-%d'/;
chomp($today);
$path_file="/usr/bin/ph/3w_remision/$today";
open(FS,">$path_file") or die("No pude abrir $path_file: $!\n");

$sql = "SELECT MAX(remission_id) as remission_id FROM op_grl_remission";
$get_results = $dbh->prepare($sql);
$get_results->execute();
if($get_results->rows == 0){
	$remission_id="111111";
}else{
	while( $resptr =  $get_results->fetchrow_hashref() ){
		if($resptr->{"remission_id"} eq ""){
			$remission_id="111111";
		}else{
			$remission_id=$resptr->{"remission_id"} + 1;
		}
	}
}
$sql = "SELECT o.date_id, od.* ,p.inv_id, p.stock_code_id, p.provider_unit_measure";
$sql.=" FROM op_grl_order o";
$sql.=" INNER JOIN op_grl_order_detail od ON o.order_id = od.order_id";
$sql.=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code";
$sql.=" WHERE o.order_id=$order_id";

#printf "%s\n",$sql;
#exit(0);
$get_results = $dbh->prepare($sql);
$get_results->execute();
if($get_results->rows == 0){
	printf "El numero de orden: %s no existe\n", $order_id;
	exit(0);
}

$sort_num = 1;
while( $resptr =  $get_results->fetchrow_hashref() ){
	$date_id=$resptr->{"date_id"};
	$inv_id = trim($resptr->{"inv_id"});
	$stock_code_id = trim($resptr->{"stock_code_id"});
	$provider_unit_measure = trim($resptr->{"provider_unit_measure"});
	$provider_product_code = trim( $resptr->{"provider_product_code"});
	$provider_product_code_remis = $provider_product_code;
	$provider_id = "PFS";
	$provider_unit = $resptr->{"provider_unit"};
	$unit_cost = $resptr->{"unit_cost"};
	$prv_required_quantity = $resptr->{"prv_required_quantity"};
	$prv_required_quantity_remis = $prv_required_quantity;
	$difference=0;
	if($provider_product_code == 34052){
		$prv_required_quantity_remis = $prv_required_quantity -1;
		$difference=1;

	}
	if($provider_product_code == 33116){
		$provider_product_code_remis=33118;
		$difference=1;
		#printf "Soy las papas\n";
	}
	if($provider_product_code == 34157){
		next;
	}

	printf FS "%d|%s|%s|%d|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%0.2f|%d\n", $sort_num,$remission_id,$order_id,$store_id,$date_id,$date_id, $provider_id,$inv_id, $stock_code_id, $provider_product_code,$provider_unit_measure, $prv_required_quantity,$unit_cost,$stock_code_id,$provider_product_code_remis,$prv_required_quantity_remis,$provider_unit_measure,$unit_cost,$difference;
	#printf "%d|%s|%s|%d|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%0.2f|%s|%s|%s|\n", $sort_num,$remission_id,$order_id,$store_id,$date_id,$date_id, $provider_id,$inv_id, $stock_code_id, $provider_product_code,$provider_unit_measure, $prv_required_quantity,$unit_cost,$stock_code_id,$provider_product_code_remis,$prv_required_quantity_remis,$provider_unit_measure,$unit_cost,$difference;
	$sort_num++;
}
printf FS "%d|%s|%s|%d|%s|%s|%s|10720|3731|0|CJ|0.00|0.00|3731|83731|3.00|CJ|136.92|1\n", $sort_num,$remission_id,$order_id,$store_id,$date_id,$date_id, $provider_id;
close(FS);
system("/usr/bin/ph/databases/purchase_order/bin/remission.pl",$today);

sub ltrim {
    $string = shift;
    $string =~ s/^\s*//g;
    return $string;
}
sub rtrim {
    $string = shift;
    $string =~ s/\s*$//g;
    return $string;
}
sub trim {
    $string = shift;
    $string =~ s/^\s*(\S+)\s*$/$1/g;
    return $string;
}
