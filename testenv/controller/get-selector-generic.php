<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  '';
	$sp	= isset($_REQUEST['sp'])  ? $_REQUEST['sp']  :  '';
	
	$queryparameter = "call $sp ($id)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	//echo $queryparameter;
	echo '{"total":'.count($arr).'},{"msg":"'.$queryparameter.'","success":true,"data":'.json_encode($arr).'}';
?>