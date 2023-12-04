<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$page = $_GET['page'];
	// get the requested page
	$limit = $_GET['rows'];
	$start = $limit * $page - $limit;
	// get how many rows we want to have into the grid
	$sidx = $_GET['sidx'];
	// get index row - i.e. user click to sort
	$sord = $_GET['sord'];
	$codRol = $_GET['codRol'];
	// get the direction
	
	if (!$sidx)
		$sidx = 1;
	if ($page == null)
		$page = 1;
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tg_usuario WHERE rol_ncorr = ".$codRol); 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	$result = executeSQLCommand("SELECT USUA_NCORR, USUA_VLOGIN, USUA_VNOMBRE, USUA_VAPELLIDO1, USUA_VAPELLIDO2, USUA_VMAIL, USUA_VCLAVE FROM tg_usuario WHERE rol_ncorr = ".$codRol." ORDER BY $sidx $sord LIMIT $start , $limit");
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[USUA_NCORR];
		$responce -> rows[$i]['cell'] = array($row[USUA_NCORR], $row[USUA_VLOGIN],$row[USUA_VNOMBRE],$row[USUA_VAPELLIDO1],$row[USUA_VAPELLIDO2],$row[USUA_VMAIL],$row[USUA_VCLAVE]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>