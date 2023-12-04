<?php
	require '../database-config.php';

	$start  = isset($_REQUEST['start'])  ? $_REQUEST['start']  :  0;
	$limit  = isset($_REQUEST['limit'])  ? $_REQUEST['limit']  :  15;
	$id  	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;

	$arr	= array();

	$queryparameter = "call prc_detalleordenservicio_listar ($id)";

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	
	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';
	//echo ',"total":'.$total->total;
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
	
	
?>