<?php 
	include_once '../model/class.php';
	include_once '../model/config.php';

	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);
	$id		= '';
	
	foreach($valuesForm as $item){
		$id  	.= ($id !='' ?',':'') .$item['idcarga'];
	}

	$queryparameter = "call prc_datosfactura_obtener('$id')";
	$rs 			= executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>