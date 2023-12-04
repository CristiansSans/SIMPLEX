<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$codUbicacion	= $_GET['codUbicacion'];
	$codDestino 	= $_GET['codDestino'];
	$resp 			= "|";
	
	$sql = "	select distinct emp.emp_ncorr as value, upper(left(emp_vnombre,30)) as text 
				from tg_empresatransporte emp 
				      inner join tg_tarifa tra on emp.emp_ncorr = tra.emp_ncorr
					  inner join tg_tramo trm on trm.tra_ncorr = tra.tra_ncorr
				where trm.lug_ncorr_origen = ".$codUbicacion." and trm.lug_ncorr_destino = ".$codDestino." order by emp.emp_vnombre asc";
		
	$result = executeSQLCommand($sql);

	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp.$row[value].":".$row[text]."|";
	}	
	echo json_encode($resp);	
?>