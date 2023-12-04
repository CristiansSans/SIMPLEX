<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$codServicio	= $_GET['codServicio'];
	$empresaGuia	= $_GET['empresaGuia'];
	$fechaGuia		= $_GET['fechaGuia'];	
	$numGuia		= $_GET['numGuia'];
	
	$queryparameter  = 	'call prc_guiatransporte_crear('.$codServicio.','.$numGuia.','.$empresaGuia.','.$fechaGuia.')';
	
	$rs = executeSQLCommand(stripslashes($queryparameter));
	$responce -> status = true;
	$responce -> mensaje = "Guia ingresada correctamente";
	echo json_encode($responce);
?>