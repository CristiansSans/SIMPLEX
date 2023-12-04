<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
		
	$idcarga 			= $_GET['id'];
	$fecha_programacion = $_GET['fecha'];
	$destino 			= $_GET['codDestino'];
	$transportista		= $_GET['codTransportista']; 

	$queryparameter = "call prc_programacioninicial_ingresar($idcarga,'$fecha_programacion',$destino,$transportista)";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
?>