<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

//	$fecha_programacion	= substr($valuesForm['tise_ncorr'],0,10) . ' ' . $valuesForm['hora-programacion'];

	$idlugardestino	= $valuesForm['idlugardestino'];
	$idlugarorigen	= $valuesForm['idlugarorigen'];
	$serv_dinicio	= $valuesForm['serv_dinicio'];
	$serv_dtermino	= $valuesForm['serv_dtermino'];
	$emp_ncorr	= $valuesForm['emp_ncorr'];
	$cam_ncorr	= $valuesForm['cam_ncorr'];
	$cha_ncorr	= $valuesForm['cha_ncorr'];
	$chof_ncorr	= $valuesForm['chof_ncorr'];
	$serv_vcelular	= $valuesForm['serv_vcelular'];
	
	$queryparameter  	= "call prc_programacion_ingresar($id,'$serv_dinicio','$serv_dtermino', $idlugardestino, $emp_ncorr, $cam_ncorr, $cha_ncorr, $chof_ncorr, '$serv_vcelular')";

	$rs = executeSQLCommand(stripslashes($queryparameter));
?>