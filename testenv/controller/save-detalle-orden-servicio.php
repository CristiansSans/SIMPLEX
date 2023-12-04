<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$sub_id  	= isset($_REQUEST['sub_id'])  ? $_REQUEST['sub_id']  :  0;
	$esca_ncorr  	= isset($_REQUEST['esca_ncorr'])  ? $_REQUEST['esca_ncorr']  :  0;
	
	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_detalleorden_ingresar2('.
							$id.','.
							$sub_id.','.
							$esca_ncorr.','.
							$valuesForm['tica_ncorr'].',"'.
							$valuesForm['car_nbooking'].'","'.
							$valuesForm['car_voperacion'].'","'.
							$valuesForm['car_vobservaciones'].'",'.
							'@lnIdCarga,'.
							'@OutStatus)';
//echo $queryparameter;
	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>