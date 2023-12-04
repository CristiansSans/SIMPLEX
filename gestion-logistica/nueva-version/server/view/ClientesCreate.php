<?php

// Conexion a la Bd
require '../eonsisDatabase.php';
mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$info = $_POST["data"];

	$data = json_decode(stripslashes($info));

	$Cliente = $data->Cliente;
	$Sexo = $data->Sexo;
	$Edad = $data->Edad;
	
			 $SqlInsert =sprintf("INSERT INTO `Clientes` (`Cliente`,`Sexo`,`Edad`)VALUES ('%s', '%s', '%s');",
					mysql_real_escape_string($Cliente),
					mysql_real_escape_string($Sexo),
					mysql_real_escape_string($Edad));
			
			
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