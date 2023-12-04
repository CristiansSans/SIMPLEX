<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$login  = isset($_GET['login'])  ? $_GET['login']  :  "";
	$pass	= isset($_GET['pass'])  ? $_GET['pass']  :  "";
	$usua_ncorr;
	$usua_vlogin;
	$usua_vnombre;
	$usua_vapellido;
	$usua_rolncorr;
	$rol_vdescripcion;
	$autenticado;
	$permisos = array();
	
	$query = "	select	usua.usua_ncorr, usua.usua_vlogin, usua.usua_vnombre, usua.usua_vapellido1, rol.rol_ncorr, rol.rol_vdescripcion
				from	tg_usuario usua inner join tb_rolusuario rol
						on usua.rol_ncorr = rol.rol_ncorr
				where	usua.usua_vlogin = '".$login."' and usua.usua_vclave = '".$pass."'";
	
						
	$result = executeSQLCommand($query);		
	//Obtencion de usuario

	//$autenticado = FALSE;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$usua_ncorr 	= $row[usua_ncorr];
		$usua_vlogin	= $row[usua_vlogin];
		$usua_vnombre	= $row[usua_vnombre];
		$usua_vapellido	= $row[usua_vapellido1];
		$usua_rolncorr	= $row[rol_ncorr];
		$rol_vdescripcion = $row[rol_vdescripcion];
		$autenticado = TRUE;
	}

	session_start();
	
	if ($autenticado == TRUE){
		//Si el usuario se encuentra autenticado se recuperan las funciones asociadas

		if (!isset($_SESSION['login'])) {
			$_SESSION['login'] = $usua_vlogin;  
		}

		if (!isset($_SESSION['usua_ncorr'])) {
			$_SESSION['usua_ncorr'] = $usua_ncorr;  
		}
		
		if (!isset($_SESSION['nombre'])) {
		  $_SESSION['nombre'] = $usua_vnombre;
		}
		
		if (!isset($_SESSION['apellido'])) {
		  $_SESSION['apellido'] = $usua_vapellido;
		}		
	
		if (!isset($_SESSION['rol'])) {
		  $_SESSION['rol'] = $rol_vdescripcion;
		}
				
		$query2 = "	select	perm.func_ncorr, func.func_vdescripcion, func.func_vurl
					from	tb_permiso perm inner join tb_funcionalidad func
        					on perm.func_ncorr = func.func_ncorr
					where	perm.rol_ncorr = " . $usua_rolncorr ." order by perm.func_ncorr asc";		
		mysql_query("SET NAMES 'utf8'");
		$result2 = executeSQLCommand($query2);		
		//Obtencion de usuario
			
		while ($row = mysql_fetch_array($result2, MYSQL_ASSOC)) {
			$permiso = $row[func_ncorr].'|'.$row[func_vdescripcion].'|'.$row[func_vurl];
			$permisos[] = $permiso;
		}

		if (!isset($_SESSION['permisos'])) {
		  $_SESSION['permisos'] = $permisos;
		}
										
		$responce -> url = "../Core/Desktop.htm";		
	}else{
		$responce -> mensaje = "El login o contraseña ingresado es incorrecto";
		$responce -> url = "#";	
	}
	$responce -> autenticado = $autenticado;
	
	echo json_encode($responce);
?>
