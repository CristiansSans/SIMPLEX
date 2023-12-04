<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	//$codServicio  	 		= isset($_GET['codServicio'])  ? $_GET['codServicio']  :  0;
	$codCarga			= $_GET['idCarga'];
	$codLugarDevolucion	= $_GET['codLugar'];
	$fechaDevolucion	= $_GET['fecha'];

	$queryparameter = "update tg_carga set esca_ncorr = 6, lug_ncorr_devolucion = ".$codLugarDevolucion.", car_fechadevolucion='".$fechaDevolucion."' where car_ncorr=".$codCarga;
	
	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$responce -> resultado = true;
	$responce -> mensaje = "Carga actualizada exitosamente";
	echo json_encode($responce);		
?>
