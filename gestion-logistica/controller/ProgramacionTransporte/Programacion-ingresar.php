<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$id				= $_GET['p0'];
	$idlugardestino	= $_GET['p1'];
	$idlugarorigen	= $_GET['p2'];
	$serv_dinicio	= $_GET['p3'];
	$serv_dtermino	= $_GET['p4'];
	$emp_ncorr		= $_GET['p5'];
	$cam_ncorr		= $_GET['p6'];
	$cha_ncorr		= $_GET['p7'];
	$chof_ncorr		= $_GET['p8'];
	$serv_vcelular	= $_GET['p9'];
	$tipoNegocio	= $_GET['p10'];
	$fechaETA		= $_GET['p11'];
	
	$queryparameter  	= "call prc_programacion_ingresar($id,'$serv_dinicio','$serv_dtermino', $idlugardestino, $emp_ncorr, $cam_ncorr, $cha_ncorr, $chof_ncorr, '$serv_vcelular')";
	$rs = executeSQLCommand(stripslashes($queryparameter));
	if ($tipoNegocio==5){
		$query = "update tg_carga set car_fechaeta = '" . $fechaETA ."' where car_ncorr = "	.$id;
		$rs2 = executeSQLCommand(stripslashes($query));
	}
?>