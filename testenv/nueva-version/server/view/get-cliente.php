<?php
	require '../database-config.php';

	$start  = isset($_REQUEST['start'])  ? $_REQUEST['start']  :  0;
	$limit  = isset($_REQUEST['limit'])  ? $_REQUEST['limit']  :  15;
	$arr	= array();

	$queryparameter  = 	'select count(*) as total '.
						'from cliente';

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	$total = mysql_fetch_object($result);
	
	$sql  = 'select cliid,clirut,clirazonsocial,clidireccion,clicontacto,clitelefono '.
			'from cliente cli '.
			'limit '.$start.','.$limit;
			
	$result = mysql_query($sql,$connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';
	echo ',"total":'.$total->total;
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>