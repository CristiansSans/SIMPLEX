<?php
	require '../database-config.php';

	$arr = array();
	$sqlSentencia = 	"select ptpid, ptpdescripcion from `portada-tipo-proyecto`";
			
	$result = mysql_query($sqlSentencia,$connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';	
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>