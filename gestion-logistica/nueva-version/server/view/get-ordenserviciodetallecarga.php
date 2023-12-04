<?php
	require '../database-config.php';

	$id  	 		= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$queryparameter = "call prc_detalleordenservicio_listar ($id)";

	$result = mysql_query($queryparameter, $connection) or die('La consulta fall&oacute;: '.mysql_error());		
	
	$arr			= array();
	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';
	echo ',"success":' . (mysql_errno($connection)==0 ? "true" : "false") . ', "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>
	