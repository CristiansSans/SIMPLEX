<?php
	require '../database-config.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$cliid		= isset($_POST['cliid'])  ? $_POST['cliid']  :  0;
	
	if($cliid==0){
		$sqlSentencia  = 	sprintf("insert cliente (clirut,clirazonsocial,clidireccion,clicontacto,clitelefono) values ('%s','%s','%s','%s','%s');",
							mysql_real_escape_string($_POST['clirut']),
							mysql_real_escape_string($_POST['clirazonsocial']),
							mysql_real_escape_string($_POST['clidireccion']),
							mysql_real_escape_string($_POST['clicontacto']),
							mysql_real_escape_string($_POST['clitelefono']));
	}
	else{
		$sqlSentencia  = 	sprintf("update cliente set clirut='%s',clirazonsocial='%s',clidireccion='%s',clicontacto='%s',clitelefono='%s' where cliid='%s';",
							mysql_real_escape_string($_POST['clirut']),
							mysql_real_escape_string($_POST['clirazonsocial']),
							mysql_real_escape_string($_POST['clidireccion']),
							mysql_real_escape_string($_POST['clicontacto']),
							mysql_real_escape_string($_POST['clitelefono']),
							mysql_real_escape_string($cliid));
	}

	$rs = mysql_query($sqlSentencia);
	
	echo json_encode(array(
		"success" 	=> mysql_errno() == 0,
		"msg"		=> mysql_errno() == 0 ? "Informacion actualizada correctamente" : mysql_error(),
		"data"		=> array(
			array(
				"cliid"			=> $_POST['cliid'],
				"clirut"		=> $_POST['clirut'],
				"clirazonsocial"=> $_POST['clirazonsocial'],
				"clidireccion"	=> $_POST['clidireccion'],
				"clicontacto"	=> $_POST['clicontacto'],
				"clitelefono"	=> $_POST['clitelefono']
			)
		)
	));
?>