<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$codorden  	 		= isset($_REQUEST['codorden'])  ? $_REQUEST['codorden']  :  0;
	$codcliente  		= isset($_REQUEST['codcliente'])  ? $_REQUEST['codcliente']  :  0;
	$codestado  		= isset($_REQUEST['codestado'])  ? $_REQUEST['codestado']  :  0;
	
	$queryparameter = "call prc_serviciosinfacturar_listar ($codorden, $codcliente, $codestado)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}

	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>
