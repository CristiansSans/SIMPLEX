<?php
	// Conexion a la Bd
    require '../eonsisDatabase.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$info = $_POST["data"];
	$data = json_decode(stripslashes($info));
	$id = $data->idcliente;

	$SqlDelete = sprintf("DELETE FROM `Clientes` WHERE `idcliente`=%d LIMIT 1;",
		mysql_real_escape_string($id));

	$rs  = mysql_query($SqlDelete);
	
	echo json_encode(array(
		"success" 	=> mysql_errno() == 0,
		"msg"		=> mysql_errno() == 0?"Datos Borrados Correctamente":mysql_error()
	));