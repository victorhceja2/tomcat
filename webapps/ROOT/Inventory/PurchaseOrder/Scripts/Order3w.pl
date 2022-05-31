#!/usr/bin/perl
use lib "/usr/bin/ph/databases/purchase_order/lib";
use poConnect;

($date_id)=@ARGV;
$order_sus="/usr/fms/op/rpts/order/$date_id";


# Reformateo de fecha yyyy-mm-dd para el query
@date_parts=split(/\-/,$date_id);
$date_parts[0]+=2000;
$date_id=$date_parts[0]."-".$date_parts[1]."-".$date_parts[2];

$vacio=" ";
$header = sprintf("%-6s %-16s %7s %7s %8s %8s %12s %12s %12s %12s %8s %9s\n",Codigo,Producto, Cant, Pronos, Product,Sugerido, Cant,Equiv, Pedido,Pedido,Dif, Costo);
$header .=sprintf("%-6s %-16s %7s %7s %8s %8s %12s %12s %12s %12s %8s %9s\n", prod, $vacio, disp, requer, en,$vacio,requer, unidad, unidad,unidad, VS, $vacio );
$header .=sprintf("%-6s %-16s %7s %7s %8s %8s %12s %12s %12s %12s %8s %9s", $vacio,$vacio,$vacio,$vacio,transito,$vacio,$vacio, prov, prov,inv, suger,$vacio);
$separator .= sprintf("---------------------------------------------------------------------------------------------------------------------------------");
## Obteniendo las distintas ordenes que pudieron ser hechas en una fecha
$lsQuery = getQueryOrdersInADay($date_id);
$get_results = $dbh->prepare($lsQuery);
$get_results->execute();
open(FS,">>$order_sus") or die("No pude abrir $order_sus: $!\n");
if($get_results->rows == 0){
	print FS "\n\n\nNo existen ordenes para la fecha $date_id\n";
}else{
	while( $resptr =  $get_results->fetchrow_hashref() ){
		$order_id = $resptr->{"order_id"};
		printf FS "*** ORDEN:  %s *** \n", $order_id;
		##Obtener los distintos proveedores dada una orden
		$lsQuery1 = getQueryProviderInAOrder($date_id, $order_id);
		$get_results1 = $dbh->prepare($lsQuery1);
		$get_results1->execute();
		while( $resptr1 =  $get_results1->fetchrow_hashref() ){
			$provider_id = $resptr1->{"provider_id"};
			$provider_name = $resptr1->{"name"};
			printf FS "%13s  %s\n\n", Proveedor, $provider_name;
			print FS "$header\n";
			print FS "$separator\n";
			$lsQuery2 = getQueryOrder($order_id, $provider_id);
			$get_results2 = $dbh->prepare($lsQuery2);
			$get_results2->execute();
			while( $resptr2 =  $get_results2->fetchrow_hashref() ){
				$provider_product_code = $resptr2->{"provider_product_code"};
				$inv_desc = $resptr2->{"inv_desc"};
				$available_quantity = $resptr2->{"available_quantity"};
				$required_quantity = $resptr2->{"required_quantity"};
				$way_order = $resptr2->{"way_order"};
				$suggested_quantity = $resptr2->{"suggested_quantity"};
				$qty_required = $resptr2->{"qty_required"};
				$unit_name1 = $resptr2->{"unit_name1"};
				$equiv_prov = $resptr2->{"equiv_prov"};
				$unit_name2 = $resptr2->{"unit_name2"};
				$order_prov_unit = $resptr2->{"order_prov_unit"};
				$order_inv_unit = $resptr2->{"order_inv_unit"};
				$dif_vs_sug = $resptr2->{"dif_vs_sug"};
				$price = $resptr2->{"price"};

				printf FS "%-6s %-16s %7.2f %7.2f %8.2f %8.2f %7.2f %-4s %7.2f %-4s %7.2f %-4s %7.2f  %-4s %8.2f %9.2f\n", $provider_product_code,substr($inv_desc,0,16), $available_quantity,  $required_quantity,$way_order,$suggested_quantity,$qty_required,substr($unit_name1,0,4),$equiv_prov,substr($unit_name2,0,4), $order_prov_unit, substr($unit_name2,0,4),$order_inv_unit, substr($unit_name1,0,4),$dif_vs_sug, $price;
			}
			$subtotal = getSubtotal($order_id, $provider_id);
			print FS "$separator\n";
			printf FS "%110s %8s %9.2f\n\n", $vacio,Subtotal,$subtotal;
		}
			$total = getTotal($order_id);
			print FS "$separator\n";
			printf FS "%106s %12s %9.2f\n\n", $vacio, "TOTAL ORDEN", $total;
	}
}
close(FS);



sub getQueryOrdersInADay{
	my $date_idt=shift@_;
	local $sql = "";
	$sql .= "SELECT ";
	$sql .= "DISTINCT order_id ";
	$sql .= "FROM op_grl_order ";
	$sql .= "WHERE CAST(date_id AS CHAR(10)) LIKE '".$date_idt."%'";
	return $sql;
}

sub getQueryProviderInAOrder{
	my $date_idt = shift@_;
	my $order_idt = shift@_;
	local $sql = "";
	$sql .= " SELECT";
	$sql .= " DISTINCT od.provider_id, prv.name";
	$sql .= " FROM op_grl_order_detail od";
	$sql .= " INNER JOIN op_grl_order o ON o.order_id = od.order_id";
	$sql .= " INNER JOIN op_grl_cat_provider prv on prv.provider_id = od.provider_id";
	$sql .= " WHERE CAST(o.date_id AS CHAR(10)) LIKE '".$date_idt."%'";
	$sql .= " AND o.order_id=" . $order_idt;
	return $sql;
}

sub getQueryOrder{
	my $order_idt = shift@_;
	my $provider_idt = shift@_;
	local $sql = " SELECT";
	$sql .= " Rtrim(p.provider_product_code) as provider_product_code,";
	$sql .= "  i.inv_desc as inv_desc,";
	$sql .= " prv.name as provider_name,";
	$sql .= " Ltrim(to_char((Case  When s.available_quantity IS NULL then 0 else s.available_quantity end),'9999990.99')) as available_quantity ,";
	$sql .= " Ltrim(to_char((Case  When s.required  IS NULL then 0 else s.required end),'9999990.99')) as qty_required,";
	$sql .= " to_char(isnull(w.way_quantity,0),'9999990.99') as way_order,";
	$sql .= " Ltrim(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99')) as suggested_quantity,";
	$sql .= " Ltrim((' '||to_char((Case  When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end),'9999990.99')||' '||rtrim(vwm.unit_name))) as qty_required,";
	$sql .= " rtrim(vwm.unit_name) as unit_name1,";
	$sql .= " Ltrim(to_char(CAST((Case  When od.inv_required_quantity IS NULL then '0' else od.inv_required_quantity end)/(Case  When p.conversion_factor IS NULL then '0' else p.conversion_factor end) as decimal(12,2)),'9999990.99')||' '||rtrim(m.unit_name)) as equiv_prov,";
	$sql .= " rtrim(m.unit_name) as unit_name2, ";
	$sql .= " Ltrim((' '||to_char(CAST(ceil((Case  When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)) as decimal(12,2)),'9999990.99')||' '||rtrim(m.unit_name))) as order_prov_unit,";
	$sql .= " Ltrim(to_char(ceil((Case  When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)*(Case  When p.conversion_factor IS NULL then 0 else p.conversion_factor end)),'9999990.99')||' '||Rtrim(vwm.unit_name)) as order_inv_unit,";
	$sql .= " Ltrim((to_char((ceil(((Case  When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)))*(Case  When p.conversion_factor IS NULL then 0 else p.conversion_factor end) - difference(s.suggested_quantity, w.way_quantity) ),'9999990.99'))) AS dif_vs_sug,";
	$sql .= " Ltrim(to_char(CAST((Case  When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)*(Case  When  p.provider_price  IS NULL then 0 else p.provider_price end) as decimal(12,2)),'9999990.99')) as price";
	$sql .= " FROM op_grl_order o";
	$sql .= " LEFT JOIN  op_grl_order_detail  od   ON o.order_id=od.order_id AND o.store_id=od.store_id";
	$sql .= " LEFT JOIN op_grl_cat_providers_product p    ON p.provider_product_code=od.provider_product_code AND p.provider_id=od.provider_id";
	$sql .= " INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id";
	$sql .= " INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id";
	$sql .= " LEFT JOIN op_grl_suggested_order s   ON  s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id=$order_idt";
	$sql .= " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
	$sql .= " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
	$sql .= " LEFT JOIN op_grl_way_order w ON (w.provider_product_code=od.provider_product_code AND w.order_id=$order_idt)";
	$sql .= " WHERE o.order_id=$order_idt";
	$sql .= " AND p.provider_id='".$provider_idt."'";
	return $sql;
}

sub getSubtotal{
	my $order_idt = shift@_;
	my $provider_idt = shift@_;
	local $sql = "SELECT";
	$sql .= " Ltrim(to_char(SUM(isnull(od.prv_required_quantity,0)*isnull(p.provider_price,0)),'9999990.99')) as subtotal";
	$sql .= " FROM  op_grl_order_detail od";
	$sql .= " INNER JOIN op_grl_cat_providers_product p ON p.provider_id=od.provider_id AND p.provider_product_code = od.provider_product_code";
	$sql .= " WHERE od.order_id = $order_idt";
	$sql .= " AND p.provider_id= '".$provider_idt."'";
	$result = $dbh->prepare($sql);
	$result->execute();
	while( $resultptr =  $result->fetchrow_hashref() ){
		$subtotal = $resultptr->{"subtotal"};
	}
	return $subtotal;
}

sub getTotal{
	my $order_idt = shift@_;
	local $sql = "SELECT";
	$sql .= " Ltrim(to_char(SUM(isnull(od.prv_required_quantity,0)*isnull(p.provider_price,0)),'9999990.99')) as total";
	$sql .= " FROM  op_grl_order_detail od";
	$sql .= " INNER JOIN op_grl_cat_providers_product p ON p.provider_id=od.provider_id AND p.provider_product_code = od.provider_product_code";
	$sql .= " WHERE od.order_id = $order_idt";
	$result = $dbh->prepare($sql);
	$result->execute();
	while( $resultptr =  $result->fetchrow_hashref() ){
		$total = $resultptr->{"total"};
	}
	return $total;
}
