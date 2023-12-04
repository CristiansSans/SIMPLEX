<?php
	require '../database-config.php';

	$start  = isset($_REQUEST['start'])  ? $_REQUEST['start']  :  0;
	$limit  = isset($_REQUEST['limit'])  ? $_REQUEST['limit']  :  15;
	$arr	= array();

	$queryparameter  = 	'select count(*) as total '.
						'from ot '.
						'inner join zona zon '.
						'on zon.zonid=ot.zonid '.
						'inner join cliente cli '.
						'on cli.cliid=ot.cliid ';

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	$total = mysql_fetch_object($result);

	$queryparameter  = 	'select otid,otinterno,otoc,otobra,ot.cliid,clirazonsocial otmandante,zon.zonid,zondescripcion,otdireccion,otcontacto,ottelefono,otrecepcion,otemision,otabono,otrecepcionabono, otsaldo '.
						'from ot '.
						'inner join zona zon '.
						'on zon.zonid=ot.zonid '.
						'inner join cliente cli '.
						'on cli.cliid=ot.cliid '.
						'order by otrecepcion '.
						'limit '.$start.','.$limit;
						
	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	
	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';
	echo ',"total":'.$total->total;
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>