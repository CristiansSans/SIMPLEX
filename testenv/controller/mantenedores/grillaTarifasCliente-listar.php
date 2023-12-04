<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$CLIE_VRUT = $_GET['CLIE_VRUT'];	
	$page = $_GET['page'];
	$limit = $_GET['rows'];
	$start = $limit * $page - $limit;
	$sidx = $_GET['sidx'];
	$sord = $_GET['sord'];
	/*$join = "tg_tarifaservicio TAR, tb_tiposervicio TISE, tb_subtiposervicio STS, tb_lugar ORIGEN, tb_lugar DESTINO ";
	$join = $join." WHERE TAR.CLIE_VRUT = '".$CLIE_VRUT."'";
	$join = $join." AND TAR.TISE_NCORR = TISE.TISE_NCORR AND TAR.STS_NCORR = STS.STS_NCORR AND TAR.LUG_NCORR_ORIGEN = ORIGEN.LUG_NCORR AND TAR.LUG_NCORR_DESTINO = DESTINO.LUG_NCORR";
	$select = "TASI_NCORR, TAR.TISE_NCORR, TISE.TISE_VDESCRIPCION, TAR.STS_NCORR, STS.STS_VNOMBRE, TAR.TASI_NMONTO, TAR.LUG_NCORR_ORIGEN, ORIGEN.LUG_VNOMBRE AS ORIGEN, TAR.LUG_NCORR_DESTINO, DESTINO.LUG_VNOMBRE AS DESTINO";*/
	if (!$sidx)
		$sidx = 1;
	if ($page == null)
		$page = 1;
	
	$query = "SELECT	TAR.TASI_NCORR, TAR.STS_NCORR, TAR.TASI_NMONTO FROM	tg_tarifaservicio TAR WHERE	TAR.CLIE_VRUT = '".$CLIE_VRUT."'";
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tg_tarifaservicio WHERE CLIE_VRUT = '".$CLIE_VRUT."'");
	 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	
	//$result = executeSQLCommand("SELECT ".$select." FROM ".$join." ORDER BY $sidx $sord LIMIT $start , $limit");
	mysql_query("SET NAMES 'utf8'");
	$result = executeSQLCommand($query);
	
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[TASI_NCORR];
		$responce -> rows[$i]['cell'] = array($row[TASI_NCORR], $row[STS_NCORR],$row[TASI_NMONTO]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>