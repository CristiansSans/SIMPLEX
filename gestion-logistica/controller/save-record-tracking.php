<?php 
	include_once '../model/class.php';
	include_once '../model/config.php';

	$codservicio= isset($_REQUEST['codservicio'])  ? $_REQUEST['codservicio']  :  0;
	$numhito	= isset($_REQUEST['numhito'])  ? $_REQUEST['numhito']  :  0;
	$hora		= isset($_REQUEST['hora'])  ? $_REQUEST['hora']  :  '';

	$queryparameter = "call prc_hitoingresado_editar($codservicio, $numhito, '$hora')";
	$rs 		= executeSQLCommand(stripslashes($queryparameter));
?>