<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$login  = isset($_REQUEST['username'])  ? $_REQUEST['username']  :  '';
	$passw	= isset($_REQUEST['password'])  ? $_REQUEST['password']  :  '';
	
	$queryparameter = "call prc_autenticacion_obtener ('$login', '$passw')";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	if (count($arr)>0){
		foreach($arr as $usuario){
			session_start();
			
			$_SESSION['usua_ncorr']=$usuario->usua_ncorr;
			$_SESSION['rol_ncorr']=$usuario->rol_ncorr;
			$_SESSION['usua_vnombre']=$usuario->usua_vnombre;
			$_SESSION['usua_vapellido1']=$usuario->usua_vapellido1;
			$_SESSION['usua_vapellido2']=$usuario->usua_vapellido2;
			$_SESSION['usua_vmail']=$usuario->usua_vmail;
			
			$_SESSION['inicio_session']=round(microtime(true));
		}	
	}
	
	echo '{"total":'.count($arr).',"success":true,"data":'.json_encode($arr).'}';	
?>