<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  '';
	
	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);
	$valuesId	= json_decode($id,true);
	
//	$fecha_programacion	= substr($valuesForm['fecha-programacion'],0,10) . ' ' . $valuesForm['hora-programacion'];
	$fecha_programacion	= $valuesForm['fecha-programacion'];
	$destino		= $valuesForm['destino'];
	$transportista		= $valuesForm['transportista'];

	foreach ($valuesId as $item) {
		$idcarga	= $item['idcarga'];
		$queryparameter = "call prc_programacioninicial_ingresar($idcarga,'$fecha_programacion',$destino,$transportista)";

		$rs = executeSQLCommand(stripslashes($queryparameter));
	}	
	
?>