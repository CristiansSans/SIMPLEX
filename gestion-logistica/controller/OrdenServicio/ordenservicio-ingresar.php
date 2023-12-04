<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$id 					= $_GET['p01'];
	$ose_dfechaservicio 	= $_GET['p02'];	
	$clie_vrut 				= $_GET['p03'];
	$clie_vrutsubcliente 	= $_GET['p04'];
	$tise_ncorr 			= $_GET['p05'];
	$sts_ncorr 				= $_GET['p06'];
	$ose_vnombrenave 		= $_GET['p07'];
	$lug_ncorr_origen 		= $_GET['p08'];;
	$lug_ncorr_puntocarguio	= $_GET['p09'];	
	$lug_ncorr_destino 		= $_GET['p10'];
	$ose_vobservaciones 	= $_GET['p11'];
	$usua_ncorr 			= $_GET['p12'];	
	
	session_start();
	
	if($id==0){
		$usua_ncorr = $_SESSION['usua_ncorr'];
	}
	
	$queryparameter  		= 	'call prc_ordenservicio_ingresar2('.$id.','.$clie_vrut.','.$clie_vrutsubcliente.','.$usua_ncorr.',"'.$ose_dfechaservicio.'","'.$ose_vnombrenave.'",'.$lug_ncorr_origen.','.$tise_ncorr.','.$sts_ncorr.','.$lug_ncorr_puntocarguio.',"'.$ose_vobservaciones.'",'.$lug_ncorr_destino.')';	
		
	$rs = executeSQLCommand(stripslashes($queryparameter));	
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	echo json_encode(count($arr));
?>