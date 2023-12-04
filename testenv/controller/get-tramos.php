<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$queryparameter = "call prc_tramos_listar";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>