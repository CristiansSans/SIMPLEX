<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$codorden  	 		= isset($_REQUEST['codorden'])  ? $_REQUEST['codorden']  :  0;
	$codcliente  		= isset($_REQUEST['codcliente'])  ? $_REQUEST['codcliente']  :  0;
	$codtransportista  	= isset($_REQUEST['codtransportista'])  ? $_REQUEST['codtransportista']  :  0;
	$inicioperiodo 		= isset($_REQUEST['inicioperiodo'])  ? $_REQUEST['inicioperiodo']  :  '';
	$terminoperiodo 	= isset($_REQUEST['terminoperiodo'])  ? $_REQUEST['terminoperiodo']  :  '';
	
	$queryparameter = "call prc_seguimientotransporte_listar ($codorden, $codcliente, $codtransportista, '$inicioperiodo', '$terminoperiodo')";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}

	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>
