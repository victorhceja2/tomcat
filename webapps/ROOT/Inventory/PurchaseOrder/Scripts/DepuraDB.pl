#!/usr/bin/perl
use lib "/usr/bin/ph/databases/purchase_order/lib";
use poConnect;

$today=qx/date '+%y-%m-%d'/;
chomp($today);
$archivo_log="/usr/local/tomcat/webapps/ROOT/Inventory/PurchaseOrder/Scripts/depuraDB.log";
open(LOG,">$archivo_log") or warn("No pude abrir $archivo_log: $!\n");
printf LOG "\n************************************\n";
printf LOG "Iniciando depuracion de $today\n";
printf LOG "************************************\n";
printf LOG "1.- Obteniendo las remisiones que se deben eliminar porque no tienen recepcion y llevan mas de 20 dias en el sistema. \n\n";
printf LOG "Las remisiones a eliminar son las siguientes: \n\n";

$sqlString = " SELECT DISTINCT ltrim(rtrim(rem.remission_id)) as remission_id, rem.date_id";
$sqlString .= " FROM op_grl_remission rem";
$sqlString .= " WHERE rem.remission_id NOT IN (SELECT r.remission_id FROM op_grl_reception r)";
$sqlString .= " AND date_id < (current_date - interval '21 days')";
$sqlString .= " ORDER BY rem.date_id ASC";

$get_results = $dbh->prepare($sqlString);
$get_results->execute();
while( $resptr =  $get_results->fetchrow_hashref() ){
	$remission_id = $resptr->{"remission_id"};
	$date_id = $resptr->{"date_id"};
	$sqlString2 = "SELECT COUNT(*) as elements FROM op_grl_remission_detail WHERE remission_id='".$remission_id."'";
	$getCount = $dbh->prepare($sqlString2);
	$getCount->execute();
	if( $resptr2 =  $getCount->fetchrow_hashref() ){
		$elements = $resptr2->{"elements"};
		printf LOG "-----------------------------------------------------------------------------------\n";
		printf LOG "$remission_id -- $date_id que tiene $elements elementos\n";
	}
	$sqlString2 = "DELETE FROM op_grl_remission_detail WHERE remission_id='".$remission_id."'";
	$sth = $dbh->prepare($sqlString2);
	if ($sth->execute()){
		printf LOG "Productos de la $remission_id eliminados!\n";
	}else{
		printf LOG "Error al eliminar elementos de la remision $remission_id\n";
	}

	$sqlString2 = "DELETE FROM op_grl_remission WHERE remission_id='".$remission_id."'";
	$sth = $dbh->prepare($sqlString2);
	if ($sth->execute()){
		printf LOG "Remision $remission_id eliminada!\n\n";
	}else{
		printf LOG "Error al eliminar la remision $remission_id\n\n";
	}
}

printf LOG "2.- Obteniendo las ordenes que se deben eliminar porque no tienen recepcion y llevan mas de 20 dias en el sistema. \n\n";
printf LOG "Las ordenes a eliminar son las siguientes: \n\n";

$sqlString = " SELECT DISTINCT o.order_id, o.date_id" ;
$sqlString .= " FROM op_grl_order o";
$sqlString .= " WHERE o.order_id NOT IN (SELECT r.order_id FROM op_grl_reception r)";
$sqlString .= " AND o.order_id <>0";
$sqlString .= " AND date_id < (current_date - interval '221 days')";
$sqlString .= " ORDER BY o.date_id ASC";

$get_results = $dbh->prepare($sqlString);
$get_results->execute();
while( $resptr =  $get_results->fetchrow_hashref() ){
	$order_id = $resptr->{"order_id"};
	$date_id = $resptr->{"date_id"};
	$sqlString2 = "SELECT COUNT(*) as elements FROM op_grl_order_detail WHERE order_id=$order_id";
	$getCount = $dbh->prepare($sqlString2);
	$getCount->execute();
	if( $resptr2 =  $getCount->fetchrow_hashref() ){
		$elements = $resptr2->{"elements"};
		printf LOG "-----------------------------------------------------------------------------------\n";
		printf LOG "$order_id -- $date_id que tiene $elements elementos\n";
	}
	$sqlString2 = "DELETE FROM op_grl_suggested_order WHERE order_id=$order_id";
	$sth = $dbh->prepare($sqlString2);
	if ($sth->execute()){
		printf LOG "Productos de la Orden $order_id de sugerido eliminados!\n";
	}else{
		printf LOG "Error al eliminar productos de sugerido de la orden $order_id\n";
	}

	$sqlString2 = "DELETE FROM op_grl_way_order WHERE order_id=$order_id";
	$sth = $dbh->prepare($sqlString2);
	if ($sth->execute()){
		printf LOG "Productos de la orden $order_id de transito eliminados!\n";
	}else{
		printf LOG "Error al eliminar productos de tr?nsito de la orden $order_id\n";
	}

	$sqlString2 = "DELETE FROM op_grl_order_detail WHERE order_id=$order_id";
	$sth = $dbh->prepare($sqlString2);
	if ($sth->execute()){
		printf LOG "Productos de la orden $order_id eliminados!\n";
	}else{
		printf LOG "Error al eliminar productos de  la orden $order_id\n";
	}

	#$sqlString2 = "DELETE FROM op_grl_order WHERE order_id=$order_id";
	#$sth = $dbh->prepare($sqlString2);
	#if ($sth->execute()){
	#	printf LOG "Orden $order_id eliminada!\n\n";
	#}else{
	#	printf LOG "Error al eliminar la orden $order_id\n\n";
	#}
        print LOG "Se deja el maestro de esta orden $order_id para no perder el consecutivo\n";
}
printf LOG "\n************************************\n";
printf LOG "Finalizando depuracion de $today\n";
printf LOG "************************************\n";
close(LOG);
