<?php 
	include_once '../model/class.php';
	include_once '../model/config.php';

	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);
	$numeroguia	= isset($_REQUEST['numeroguia'])  ? $_REQUEST['numeroguia']  :  0;
	$id		= '';
	
	foreach($valuesForm as $item){
		$id  	.= ($id !='' ?',':'') .$item['car_ncorr'];
	}


	$queryparameter = "call prc_guiatransporte_crear('$id', $numeroguia, @mensajeerror)";
	$rs 		= executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>