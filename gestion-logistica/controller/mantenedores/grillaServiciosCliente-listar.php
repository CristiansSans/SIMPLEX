<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$CLIE_VRUT = $_GET['CLIE_VRUT'];	
	$page = 1;
	$total_pages = 1;
	$limit = $_GET['rows'];
	$start = $limit * $page - $limit;
	$sidx = $_GET['sidx'];
	$sord = $_GET['sord'];
	
	$query = "	SELECT	sts.sts_ncorr, 	
						sts.sts_vnombre, 	
				        sts.tise_ncorr, 	
				        sts.lug_ncorr_origen, 
				        sts.lug_ncorr_destino, 
				        sts.clie_vrut, 
				        sts.sts_nmonto,
				        tise.tise_vdescripcion
				FROM	tb_subtiposervicio sts
				INNER 	JOIN tb_tiposervicio tise on sts.tise_ncorr = tise.tise_ncorr
				WHERE	sts.clie_vrut = ".$CLIE_VRUT."
				ORDER 	by sts_vnombre ASC";
	

	$result = executeSQLCommand($query);
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[sts_ncorr];
		$responce -> rows[$i]['cell'] = array(	$row[sts_ncorr],
												$row[sts_vnombre], 
												$row[tise_ncorr],
												$row[lug_ncorr_origen],
												$row[lug_ncorr_destino],
												$row[clie_vrut],
												$row[sts_nmonto],
												$row[tise_vdescripcion]);
		$i++;
	}
	$responce -> page = 1;
	$responce -> total = 1;
	$responce -> records = 10;
	echo json_encode($responce);
?>