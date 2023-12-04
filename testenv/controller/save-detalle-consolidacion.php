<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_infoconsolidacion_ingresar('.
							$id.','.
							'"'.$valuesForm['car_vcontacto'].'",'.
							'"'.$valuesForm['car_dfecha'].'",'.
							$valuesForm['lug_ncorr_consolidacion'].')';

	$rs = executeSQLCommand(stripslashes($queryparameter));
?>
