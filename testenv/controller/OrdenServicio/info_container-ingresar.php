<?php

	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$idCarga 			= $_GET['p01'];
	$marca 				= $_GET['p02'];	
	$contenedor 		= $_GET['p03'];
	$contenido 			= $_GET['p04'];
	$terminoStacking	= $_GET['p05'];
	$codLugarDevolucion	= $_GET['p06'];
	$diasLibres			= $_GET['p07'];
	$sello				= $_GET['p08'];
	$ada				= $_GET['p09'];
	$cada				= $_GET['p10'];
	$peso				= $_GET['p11'];
	$med				= $_GET['p12'];
	$cond				= $_GET['p13'];
	
	/*
	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$sub_id  	= isset($_REQUEST['sub_id'])  ? $_REQUEST['sub_id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);
	*/
	$queryparameter  = 	'call prc_infocontenedor_ingresar2('.
							$idCarga.','.
							'"'.$marca.'",'.
							'"'.$contenedor.'",'.
							'"'.$contenido.'",'.
							'"'.$terminoStacking.'",'.
							$codLugarDevolucion.','.
							$diasLibres.','.
							'"'.$sello.'",'.
							$ada.','.
							$cada.','.
							$peso.','.
							$med.','.
							$cond.')';

//echo $queryparameter;
	$rs = executeSQLCommand(stripslashes($queryparameter));
	echo json_encode(1);
?>