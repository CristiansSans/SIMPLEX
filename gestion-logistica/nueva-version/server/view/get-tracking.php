<?php
	require '../database-config.php';

	$start  	 	= isset($_REQUEST['start'])  ? $_REQUEST['start']  :  0;
	$limit  	 	= isset($_REQUEST['limit'])  ? $_REQUEST['limit']  :  15;
	$cliente	 	= isset($_REQUEST['cliente'])  ? $_REQUEST['cliente']  :  0;
	$ejecucion	 	= isset($_REQUEST['ejecucion'])  ? $_REQUEST['ejecucion']  :  1;
	$arr	= array();

	$queryparameter  = 	'select count(*) as total '.
						'from proyecto pro '.
						'inner join ot ot '.
						'on ot.otid=pro.otid '.
						'inner join zona zon '.
						'on zon.zonid=ot.zonid '.
						'left join estado est '.
						'on est.estid=ot.estid ';

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	$total = mysql_fetch_object($result);

	$queryparameter  = 	'select proid,cliid,ot.otinterno,otoc,otobra,zondescripcion,otdireccion,DATE_FORMAT(otrecepcion,"%Y/%m/%d") otrecepcion,otabono,DATE_FORMAT(otrecepcionabono,"%Y/%m/%d") otrecepcionabono,ot.estid,estdescripcion,ifnull(DATE_FORMAT(profechatermino,"%Y/%m/%d"),"") profechatermino, otsaldo, null logs, null files '.
						'from proyecto pro '.
						'inner join ot ot '.
						'on ot.otid=pro.otid '.
						'inner join zona zon '.
						'on zon.zonid=ot.zonid '.
						'left join estado est '.
						'on est.estid=ot.estid '.
						'order by proid desc '.
						'limit '.$start.','.$limit;
						
	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	
	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';	
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>