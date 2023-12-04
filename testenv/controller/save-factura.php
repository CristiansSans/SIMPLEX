<?php 
	include_once '../model/class.php';
	include_once '../model/config.php';

	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);
	$numerofactura	= isset($_REQUEST['numerofactura'])  ? $_REQUEST['numerofactura']  :  0;
	$observaciones	= isset($_REQUEST['observaciones'])  ? $_REQUEST['observaciones']  :  '';
	$descuento	= isset($_REQUEST['descuento'])  ? $_REQUEST['descuento']  :  0;
	$id		= '';
	
	foreach($valuesForm as $item){
		$id  	.= ($id !='' ?',':'') .$item['idcarga'];
	}


	$queryparameter = "call prc_factura_crear('$id', $numerofactura, '$observaciones', $descuento)";
	$rs 		= executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>