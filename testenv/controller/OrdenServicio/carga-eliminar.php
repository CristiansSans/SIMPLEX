<?php 
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$id 			= $_GET['id'];

	try{
		$queryparameter = "call prc_detallecarga_eliminar($id)";
		$rs 		= executeSQLCommand(stripslashes($queryparameter));
		
		$arr = array();
		while($obj = mysql_fetch_object($rs)) {
		    $arr[] = $obj;
		}
		echo count($arr);		
	}catch(Exception $e){
		echo -1;
	}
	//$id	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	

	
	//echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>