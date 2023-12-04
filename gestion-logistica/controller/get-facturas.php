<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$factura  	 	= isset($_REQUEST['factura'])  ? $_REQUEST['factura']  :  0;
	$orden  		= isset($_REQUEST['orden'])  ? $_REQUEST['orden']  :  0;
	$cliente  		= isset($_REQUEST['cliente'])  ? $_REQUEST['cliente']  :  0;
	
	$queryparameter = "call prc_facturas_listar ($factura, $orden, $cliente)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}

	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>
