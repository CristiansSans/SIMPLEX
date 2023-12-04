<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$codTramo = $_GET['codTramo'];
	
	$page = $_GET['page'];
	// get the requested page
	$limit = $_GET['rows'];
	$start = $limit * $page - $limit;
	// get how many rows we want to have into the grid
	$sidx = $_GET['sidx'];
	// get index row - i.e. user click to sort
	$sord = $_GET['sord'];
	// get the direction
	
	if (!$sidx)
		$sidx = 1;
	if ($page == null)
		$page = 1;
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tg_hito WHERE TRA_NCORR = ".$codTramo);
	 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	$result = executeSQLCommand("SELECT HITO_NCORR, HITO_VNOMBRE, HITO_KM, HITO_TIEMPOVIAJE, HITO_INCIAL AS HITO_INICIAL, HITO_FINAL FROM tg_hito WHERE TRA_NCORR = ".$codTramo." ORDER BY $sidx $sord LIMIT $start , $limit");
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[HITO_NCORR];
		$responce -> rows[$i]['cell'] = array($row[HITO_NCORR], $row[HITO_VNOMBRE], $row[HITO_KM], $row[HITO_TIEMPOVIAJE], $row[HITO_INICIAL], $row[HITO_FINAL]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>