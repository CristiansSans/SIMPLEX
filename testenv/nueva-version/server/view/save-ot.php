<?php
	require '../database-config.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$otid				= $_POST['otid']!='' ? $_POST['otid']  :  0;
	$otinterno			= $_POST['otinterno'];
	$otoc				= $_POST['otoc'];
	$otrecepcion		= convertDateToFormatYYMMDD($_POST['otrecepcion']);
	$otemision			= $_POST['otemision']!='' ? convertDateToFormatYYMMDD($_POST['otemision'])  :  null;
	$cliid				= $_POST['cliid'];
	$otobra				= $_POST['otobra'];
	$zonid				= $_POST['zonid'];
	$otdireccion		= $_POST['otdireccion'];
	$otcontacto			= $_POST['otcontacto'];
	$ottelefono			= $_POST['ottelefono'];
	$otabono  			= isset($_POST['otabono'])  ? 1  :  0;
	$otrecepcionabono	= $_POST['otrecepcionabono']!='' ? convertDateToFormatYYMMDD($_POST['otrecepcionabono'])  :  null;
	$otsaldo  			= isset($_POST['otsaldo'])  ? 1  :  0;

	if($otid==0){
		$sqlSentencia  = 	sprintf("insert ot (cliid,otinterno,otoc,otobra,zonid,otdireccion,otcontacto,ottelefono,otrecepcion,otemision,otabono,otrecepcionabono, otsaldo ) ".
									"values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');",
									mysql_real_escape_string($cliid),
									mysql_real_escape_string($otinterno),
									mysql_real_escape_string($otoc),
									mysql_real_escape_string($otobra),
									mysql_real_escape_string($zonid),
									mysql_real_escape_string($otdireccion),
									mysql_real_escape_string($otcontacto),
									mysql_real_escape_string($ottelefono),
									mysql_real_escape_string($otrecepcion),
									mysql_real_escape_string($otemision),
									mysql_real_escape_string($otabono),
									mysql_real_escape_string($otrecepcionabono),
									mysql_real_escape_string($otsaldo));
	}
	else{
		$sqlSentencia  = 	sprintf("update ot set cliid='%s',otinterno='%s',otoc='%s',otobra='%s',zonid='%s',otdireccion='%s',otcontacto='%s',ottelefono='%s',otrecepcion='%s',otemision='%s',otabono='%s',otrecepcionabono='%s',otsaldo='%s' where otid='%s';",
									mysql_real_escape_string($cliid),
									mysql_real_escape_string($otinterno),
									mysql_real_escape_string($otoc),
									mysql_real_escape_string($otobra),
									mysql_real_escape_string($zonid),
									mysql_real_escape_string($otdireccion),
									mysql_real_escape_string($otcontacto),
									mysql_real_escape_string($ottelefono),
									mysql_real_escape_string($otrecepcion),
									mysql_real_escape_string($otemision),
									mysql_real_escape_string($otabono),
									mysql_real_escape_string($otrecepcionabono),
									mysql_real_escape_string($otsaldo),
									mysql_real_escape_string($otid));
	}

	$rs = mysql_query($sqlSentencia);
	
	echo json_encode(array(
		"success" 	=> mysql_errno() == 0,
		"msg"		=> mysql_errno() == 0 ? "Informacion actualizada correctamente" : mysql_error(),
		"data"		=> array()
	));
?>