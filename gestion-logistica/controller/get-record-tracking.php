<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$codservicio  	 = isset($_REQUEST['codservicio'])  ? $_REQUEST['codservicio']  :  0;
	
	$queryparameter = "call prc_hitosingresados_listar ($codservicio)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}

	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>
