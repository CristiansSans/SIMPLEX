<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$codTipoServicio = $_GET['codTipoServicio'];
	$query = "";
	$resp = "|";
	
	$query = "	select	lug_ncorr_origen, lug_ncorr_destino, sts_ncorr
				from	tb_subtiposervicio
				where	sts_ncorr = ".$codTipoServicio;	
		
	$result = executeSQLCommand($query);
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $row[lug_ncorr_origen]."|".$row[lug_ncorr_destino];
	};	
	echo json_encode($resp);
?>