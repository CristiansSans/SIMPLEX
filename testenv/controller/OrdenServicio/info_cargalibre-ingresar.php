<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$idCarga 				= $_GET['p01'];
	$carlibre_um 			= $_GET['p02'];	
	$carlibre_cantidad 		= $_GET['p03'];
	
	/*
	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);*/

	$queryparameter  = 	'call prc_cargalibre_ingresar('.
							$idCarga.','.
							$carlibre_um.','.
							$carlibre_cantidad.')';

	$rs = executeSQLCommand(stripslashes($queryparameter));
	return 1;
?>