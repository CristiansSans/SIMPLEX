<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$codServicio	= $_GET['codServicio'];
	$empresaGuia	= $_GET['empresaGuia'];
	$fechaGuia		= $_GET['fechaGuia'];	
	$numGuia		= $_GET['numGuia'];
	$codGuia		= $_GET['codGuia'];
	
	$queryparameter = 'UPDATE tg_guiatransporte SET EMP_NCORR ='.$empresaGuia.', guia_dfecha ='.$fechaGuia.', guia_numero ='.$numGuia.' where guia_ncorr ='.$codGuia;
	
	$rs = executeSQLCommand(stripslashes($queryparameter));
	$responce -> status = true;
	$responce -> mensaje = "Guia actualizada correctamente";
	echo json_encode($responce);
?>