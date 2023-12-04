<?php
	require '../database-config.php';
	mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");

	$arr = array();

	$sql = 	"select zonid, zondescripcion from zona";
			
	$result = mysql_query($sql,$connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';	
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>