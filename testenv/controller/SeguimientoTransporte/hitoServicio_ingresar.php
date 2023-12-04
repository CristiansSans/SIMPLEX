<?php 
	include_once '../../model/class.php';
	include_once '../../model/config.php';


	$codservicio= isset($_REQUEST['codservicio'])  ? $_REQUEST['codservicio']  :  0;
	$numhito	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$hora		= isset($_REQUEST['horareal'])  ? $_REQUEST['horareal']  :  '';
	list($auxFecha, $auxHora) = explode (" ",$hora);
	list($auxDia, $auxMes, $auxAnio) = explode ("/",$auxFecha);
	$fecha = $auxAnio .'-'.$auxMes.'-'.$auxDia.' '.$auxHora.':00';
	//$queryparameter = "call prc_hitoingresado_editar($codservicio, $numhito, '$hora')";
	$queryparameter = "call prc_hitoingresado_editar($codservicio, $numhito, '$fecha')";
	//echo $queryparameter;
	$rs 		= executeSQLCommand(stripslashes($queryparameter));
?>