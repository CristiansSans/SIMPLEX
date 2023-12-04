<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 		= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  '';

	$queryparameter  = 	"call prc_ordenservicio_obtener2($id)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	if (count($arr)>0){
		echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
	}
?>
