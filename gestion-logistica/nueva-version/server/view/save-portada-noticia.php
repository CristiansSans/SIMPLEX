<?php
	require '../database-config.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$pnoid		= isset($_POST['pnoid'])  ? $_POST['pnoid']  :  0;
	$pnofecha	= $_POST['pnofecha'];
	$pnofecha	= substr ($pnofecha, 6, 4).'-'.substr ($pnofecha, 3, 2).'-'.substr ($pnofecha, 0, 2);
	$pnotitulo 	= $_POST['pnotitulo'];
	$pnoautor 	= $_POST['pnoautor'];
	$pnobody 	= $_POST['pnobody'];
	$pnoimagen 	= $_FILES['pnoimagen']['name'];

	$mesesArray	= array(
		'01'	=> 'Enero',
		'02'	=> 'Febrero',
		'03'	=> 'Marzo',
		'04'	=> 'Abril',
		'05'	=> 'Mayo',
		'06'	=> 'Junio',
		'07'	=> 'Julio',
		'08'	=> 'Agosto',
		'09'	=> 'Septiembre',
		'10'	=> 'Octubre',
		'11'	=> 'Noviembre',
		'12'	=> 'Diciembre'
	);
	
	$pnomonth				= $mesesArray[substr ($pnofecha, 5, 2)];
	$archivo_name			= $_FILES['pnoimagen']['name'];
	$archivo_tmp			= $_FILES['pnoimagen']['tmp_name'];

	if($pnoid==0){
		if ($pnoimagen==''){
			$sqlSentencia =sprintf("INSERT INTO `portada-noticia` (pnofecha, pnomonth, pnotitulo, pnoautor, pnobody)VALUES ('%s', '%s', '%s', '%s', '%s');",
				mysql_real_escape_string($pnofecha),
				mysql_real_escape_string($pnomonth),
				mysql_real_escape_string($pnotitulo),
				mysql_real_escape_string($pnoautor),
				mysql_real_escape_string($pnobody));
		}
		else{
			$sqlSentencia =sprintf("INSERT INTO `portada-noticia` (pnofecha, pnomonth, pnotitulo, pnoautor, pnobody, pnoimagen)VALUES ('%s', '%s', '%s', '%s', '%s', '%s');",
				mysql_real_escape_string($pnofecha),
				mysql_real_escape_string($pnomonth),
				mysql_real_escape_string($pnotitulo),
				mysql_real_escape_string($pnoautor),
				mysql_real_escape_string($pnobody),
				mysql_real_escape_string($pnoimagen));
		}
	}
	else{
		if ($pnoimagen==''){
			$sqlSentencia =sprintf("UPDATE `portada-noticia` SET pnofecha='%s', pnomonth='%s', pnotitulo='%s', pnoautor='%s', pnobody='%s' WHERE pnoid='%s';",
				mysql_real_escape_string($pnofecha),
				mysql_real_escape_string($pnomonth),
				mysql_real_escape_string($pnotitulo),
				mysql_real_escape_string($pnoautor),
				mysql_real_escape_string($pnobody),
				mysql_real_escape_string($pnoid));
		}
		else{
			$sqlSentencia =sprintf("UPDATE `portada-noticia` SET pnofecha='%s', pnomonth='%s', pnotitulo='%s', pnoautor='%s', pnobody='%s', pnoimagen='%s' WHERE pnoid='%s';",
				mysql_real_escape_string($pnofecha),
				mysql_real_escape_string($pnomonth),
				mysql_real_escape_string($pnotitulo),
				mysql_real_escape_string($pnoautor),
				mysql_real_escape_string($pnobody),
				mysql_real_escape_string($pnoimagen),
				mysql_real_escape_string($pnoid));
		}
	}
	
	$rs = mysql_query($sqlSentencia);
	
	if($pnoid==0){
		$pnoid=mysql_insert_id();
	}
	
	if ($pnoimagen==''){
		$fileSuccess=true;
	}
	else{
		$fileSuccess 	= move_uploaded_file($archivo_tmp, "../../resources/images/noticias/$archivo_name");
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
				"pnoid"		=> $pnoid,
				"pnofecha"	=> $pnofecha,
				"pnotitulo"	=> $pnotitulo,
				"pnoautor"	=> $pnoautor,
				"pnobody"	=> $pnobody,
				"pnoimagen"	=> $pnoimagen
			)
		)
	));
?>