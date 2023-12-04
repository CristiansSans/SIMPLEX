<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_infoadicional_ingresar('.
							$id.','.
							$valuesForm['car_ntemperatura'].','.
							$valuesForm['car_nventilacion'].','.
							'"'.$valuesForm['car_vadic_otros'].'",'.
							'"'.$valuesForm['car_vadic_obs'].'")';

	$rs = executeSQLCommand(stripslashes($queryparameter));
?>