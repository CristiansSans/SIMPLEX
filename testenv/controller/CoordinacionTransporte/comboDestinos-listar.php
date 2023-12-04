<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$codServicio	= $_GET['codServicio'];
	$codLugar 		= $_GET['codLugar'];
	$resp 			= "|";
	
	$sql = "select	vista.lug_ncorr_destino as value, vista.nombre as text
			from	tg_tramo_subtiposervicio tss 
					inner join tg_tramo tra on tss.tra_ncorr = tra.tra_ncorr
			        inner join tb_lugar lug on lug.lug_ncorr = tra.lug_ncorr_destino
			        inner join vw_tramo vista on vista.tra_ncorr = tra.tra_ncorr
			where	tss.sts_ncorr = ".$codServicio." and vista.lug_ncorr_origen = ".$codLugar." order by vista.nombre asc";
		
	$result = executeSQLCommand($sql);

	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp.$row[value].":".$row[text]."|";
	}	
	echo json_encode($resp);	
?>