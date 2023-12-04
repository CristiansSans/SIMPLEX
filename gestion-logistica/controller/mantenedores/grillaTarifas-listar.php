<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$codEmpresa = $_GET['codEmpresa'];
	//$rutEmpresa = $_GET['rutEmpresa'];
	
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
	
	$result1 = executeSQLCommand("SELECT COUNT(1) FROM tg_tarifa WHERE EMP_NCORR = ".$codEmpresa);
	 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}

	$sqlText = 	"SELECT TAR_NCORR, TRA_NCORR, TAR_NMONTO FROM tg_tarifa WHERE EMP_NCORR = ".$codEmpresa." ORDER BY $sidx $sord LIMIT $start , $limit";
	//echo $sqlText;
	
	$result = executeSQLCommand($sqlText);

	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[TAR_NCORR];
		$responce -> rows[$i]['cell'] = array($row[TAR_NCORR],$row[TRA_NCORR] ,$row[TAR_NMONTO]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>