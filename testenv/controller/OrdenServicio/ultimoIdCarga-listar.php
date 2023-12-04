<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$codOrden = $_GET['codOrden'];
	$codResultado;
	$query = "SELECT 	MAX(car_ncorr) car_ncorr
				FROM 	tg_carga car 
				WHERE 	car.ose_ncorr = ".$codOrden;

	$result = executeSQLCommand($query);		
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$codResultado =  $row[car_ncorr];
	}

	echo json_encode($codResultado);
?>