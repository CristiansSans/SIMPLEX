<?php
	require '../database-config.php';

	$arr = array();

	$sql = 	"select zn.zonid, zn.zondescripcion, porid, pordescripcioncorta, pordescripcionlarga, date_format(porfecha,'%d-%m-%Y') porfecha, (select pubpath from `portada-publicacion` where pubid=1) pubpath, porimagen ".
			"from `portada-proyecto` pm ".
			"inner join zona zn ".
			"on zn.zonid=pm.zonid";
			
	$result = mysql_query($sql,$connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';	
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>