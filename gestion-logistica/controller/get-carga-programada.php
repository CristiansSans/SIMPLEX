<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$fecha_programacion	= isset($_REQUEST['fecha'])  ? "'".$_REQUEST['fecha']."'"  :  'NULL';
	//$fecha_programacion	= substr($fecha_programacion,0,10);

	$queryparameter 	= "call prc_cargaprogramada_listar ($fecha_programacion)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>
