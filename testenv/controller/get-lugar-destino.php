<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  			= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$subID  		= isset($_REQUEST['subID'])  ? $_REQUEST['subID']  :  0;
	
	$queryparameter = "call prc_combolugardestino_listar ($id, $subID)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>