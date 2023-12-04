<?php
	require '../database-config.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$info = $_POST["data"];

	$data = json_decode(stripslashes($info));

	$zonid = $data->zonid;
	$pordescripcioncorta = $data->pordescripcioncorta;
	$pordescripcionlarga = $data->pordescripcionlarga;
	$porfecha = $data->porfecha;
	$porimagen = $data->porimagen;
	
	$SqlInsert =sprintf("INSERT INTO `portada-proyecto` (zonid, pordescripcioncorta, pordescripcionlarga, porfecha, porimagen)VALUES ('%s', '%s', '%s', '%s', '%s');",
		mysql_real_escape_string($zonid),
		mysql_real_escape_string($pordescripcioncorta),
		mysql_real_escape_string($pordescripcionlarga),
		mysql_real_escape_string($porfecha),
		mysql_real_escape_string($porimagen));
			
	$rs = mysql_query($SqlInsert);
	echo json_encode(array(
		"success" 	=> mysql_errno() == 0,
		"msg"		=> mysql_errno() == 0?"Datos Agregados Correctamente":mysql_error(),
		"data"		=> array(
			array(
				"idcliente"	=> mysql_insert_id(),	// <--- importantisimo regresar el ID asignado al record, para que funcione correctamente el metodo update y delete
				"Cliente"	=> $Cliente,
				"Sexo"	=> $Sexo,
				"Edad"	=> $Edad
			)
		)
	));
?>