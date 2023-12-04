<?php
	require '../database-config.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

//	$info = $_POST["data"];
//	$data = json_decode(stripslashes($info));

	$porid					= isset($_POST['porid'])  ? $_POST['porid']  :  0;
	$zonid 					= $_POST['zonid'];//$data->zonid;
	$pordescripcioncorta 	= $_POST['pordescripcioncorta'];//$data->pordescripcioncorta;
	$pordescripcionlarga 	= $_POST['pordescripcionlarga'];//$data->pordescripcionlarga;
	$porfecha 				= $_POST['porfecha'];//$data->porfecha;
	$porfecha				= substr ($porfecha, 6, 4).'-'.substr ($porfecha, 3, 2).'-'.substr ($porfecha, 0, 2);
	$porimagen 				= $_FILES['porimagen']['name'];//explode("\\",$_REQUEST["imagen"]);

	$archivo_name			= $_FILES['porimagen']['name'];
	$archivo_tmp			= $_FILES['porimagen']['tmp_name'];

	if($porid==0){
		if ($porimagen==''){
			$sqlSentencia =sprintf("INSERT INTO `portada-proyecto` (zonid, pordescripcioncorta, pordescripcionlarga, porfecha)VALUES ('%s', '%s', '%s', '%s');",
				mysql_real_escape_string($zonid),
				mysql_real_escape_string($pordescripcioncorta),
				mysql_real_escape_string($pordescripcionlarga),
				mysql_real_escape_string($porfecha));
		}
		else{
			$sqlSentencia =sprintf("INSERT INTO `portada-proyecto` (zonid, pordescripcioncorta, pordescripcionlarga, porfecha, porimagen)VALUES ('%s', '%s', '%s', '%s', '%s');",
				mysql_real_escape_string($zonid),
				mysql_real_escape_string($pordescripcioncorta),
				mysql_real_escape_string($pordescripcionlarga),
				mysql_real_escape_string($porfecha),
				mysql_real_escape_string($porimagen));
		}
	}
	else{
		if ($porimagen==''){
			$sqlSentencia =sprintf("UPDATE `portada-proyecto` SET pordescripcioncorta='%s', pordescripcionlarga='%s', porfecha='%s' WHERE porid='%s';",
				mysql_real_escape_string($pordescripcioncorta),
				mysql_real_escape_string($pordescripcionlarga),
				mysql_real_escape_string($porfecha),
				mysql_real_escape_string($porid));
		}
		else{
			$sqlSentencia =sprintf("UPDATE `portada-proyecto` SET pordescripcioncorta='%s', pordescripcionlarga='%s', porfecha='%s', porimagen='%s' WHERE porid='%s';",
				mysql_real_escape_string($pordescripcioncorta),
				mysql_real_escape_string($pordescripcionlarga),
				mysql_real_escape_string($porfecha),
				mysql_real_escape_string($porimagen),
				mysql_real_escape_string($porid));
		}
	}
	
	$rs = mysql_query($sqlSentencia);
	
	if($porid==0){
		$porid=mysql_insert_id();
	}
	
	if ($porimagen==''){
		$fileSuccess=true;
	}
	else{
		$fileSuccess 	= move_uploaded_file($archivo_tmp, "../../resources/images/proyectos/$archivo_name");
	}
	
	$erroresExists	= (!$fileSuccess || mysql_errno() != 0);
	$erroresMSG		= "";
	
	if(!$erroresExists){
		$erroresMSG .= "Datos actualizados exitosamente";
	}
	else{
		if (!$fileSuccess && mysql_errno() != 0){
			$erroresMSG .= "Archivo $archivo_name no pudo cargarse\r\n".mysql_error();
		}
		else{
			if (!$fileSuccess){
				$erroresMSG .= "Archivo $archivo_name no pudo cargarse";
			}
			else{
				$erroresMSG .= mysql_error();
			}
		}
	}

	echo json_encode(array(
		"success" 	=> !$erroresExists,//mysql_errno() == 0,
		"msg"		=> $erroresMSG,//mysql_errno() == 0?"Datos Agregados Correctamente":mysql_error(),
		"data"		=> array(
			array(
				"porid"					=> $porid,
				"zonid"					=> $zonid,
				"pordescripcioncorta"	=> $pordescripcioncorta,
				"pordescripcionlarga"	=> $pordescripcionlarga,
				"porfecha"				=> $porfecha,
				"porimagen"				=> $porimagen
			)
		)
	));
?>