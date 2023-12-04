<?php

	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$idCarga 			= $_GET['p01'];
	$car_ntemperatura 	= $_GET['p02'];	
	$car_nventilacion 	= $_GET['p03'];
	$car_vadic_otros 	= $_GET['p04'];
	$car_vadic_obs 		= $_GET['p05'];

	/*
	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);*/

	$queryparameter  = 	'call prc_infoadicional_ingresar('.
							$idCarga.','.
							$car_ntemperatura.','.
							$car_nventilacion.','.
							'"'.$car_vadic_otros.'",'.
							'"'.$car_vadic_obs.'")';

	$rs = executeSQLCommand(stripslashes($queryparameter));
	return 1;
?>