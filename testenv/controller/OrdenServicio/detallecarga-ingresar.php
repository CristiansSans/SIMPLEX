<?php

	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$idCarga 			= $_GET['p01'];
	$codOrdenServicio 	= $_GET['p02'];	
	$codEstadoCarga 	= $_GET['p03'];
	$codTipoCarga 		= $_GET['p04'];
	$numBooking 		= $_GET['p05'];
	$operacion 			= $_GET['p06'];
	$observaciones 		= $_GET['p07'];

	$queryparameter  = 	'call prc_detalleorden_ingresar2('.
							$idCarga.','.
							$codOrdenServicio.','.
							$codEstadoCarga.','.
							$codTipoCarga.',"'.
							$numBooking.'","'.
							$operacion.'","'.
							$observaciones.'",'.
							'@lnIdCarga,'.
							'@OutStatus)';

	$rs = executeSQLCommand(stripslashes($queryparameter));

	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	$idRegistroCreado = $arr[count($arr)-1];
	echo json_encode($idRegistroCreado);
?>