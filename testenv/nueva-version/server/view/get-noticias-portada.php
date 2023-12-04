<?php
	require '../database-config.php';

	$arr = array();

	$sql = 	"select pnoid, date_format(pnofecha,'%d-%m-%Y') pnofecha, CONCAT(pnomonth, ' ', date_format(pnofecha,'%Y')) pnomonthyear, date_format(pnofecha,'%Y') pnoyear, pnomonth, date_format(pnofecha,'%d') pnoday, pnotitulo, pnoautor, pnobody, (select pubpath from `portada-publicacion` where pubid=2) pubpath, pnoimagen ".
			"from `portada-noticia` pn ";
			
	$result = mysql_query($sql,$connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';	
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>