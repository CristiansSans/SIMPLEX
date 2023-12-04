<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$idCarga 				= $_GET['p01'];
	$car_dfecharetiro 		= $_GET['p02'];	
	$car_dfechapresentacion = $_GET['p03'];
	$car_vcontactoentrega 	= $_GET['p04'];
	
	/*
	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);
	*/
	$queryparameter  = 	'call prc_infotraslado_ingresar2('.
							$idCarga.','.
							'"'.$car_dfecharetiro.'",'.
							'"'.$car_dfechapresentacion.'",'.
							'"'.$car_vcontactoentrega.'")';

	$rs = executeSQLCommand(stripslashes($queryparameter));
?>
