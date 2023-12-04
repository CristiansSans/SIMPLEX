<?php
session_start();
//include_once '../../model/class.php';
//include_once '../../model/config.php';

$usua_ncorr;
$usua_vlogin;
$usua_vnombre;
$usua_vapellido;
$usua_rolncorr;
$rol_vdescripcion;
$permisos = array();

if (isset($_SESSION['login'])) {
	isset($_SESSION['login']) ? $usua_vlogin = $_SESSION['login'] : "";
	isset($_SESSION['nombre']) ? $usua_vnombre = $_SESSION['nombre'] : "";
	isset($_SESSION['apellido']) ? $usua_vapellido = $_SESSION['apellido'] : "";
	isset($_SESSION['rol']) ? $rol_vdescripcion = $_SESSION['rol'] : "";
	isset($_SESSION['permisos']) ? $permisos = $_SESSION['permisos'] : array();

	$responce -> autenticado = true;
	$responce -> login = $usua_vlogin;
	$responce -> nombre = $usua_vnombre;
	$responce -> apellido = $usua_vapellido;
	$responce -> rol = $rol_vdescripcion;
	$responce -> permisos = $permisos;
}else{
	$responce -> autenticado = false;
	$responce -> mensaje = "Usted no se encuentra autenticado";
	$responce -> url = "../Core/Desktop.htm";
}

echo json_encode($responce);
?>
