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
	// get the direction
	
	if (!$sidx)
		$sidx = 1;
	if ($page == null)
		$page = 1;
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tb_cliente"); 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	mysql_query("SET NAMES 'utf8'");
	$result = executeSQLCommand("SELECT CLIE_VRUT, CLIE_VNOMBRE, CLIE_VRAZONSOCIAL, CLIE_VCONTACTOLEGAL, CLIE_VDIRECCION, CLIE_VCOMUNA, CLIE_VGIRO, CLIE_VFONO, CLIE_NDIASLIBRES, CLIE_VACTIVIDAD FROM tb_cliente ".$where." ORDER BY $sidx $sord LIMIT $start , $limit");
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[CLIE_VRUT];
		$responce -> rows[$i]['cell'] = array($row[CLIE_VRUT], $row[CLIE_VNOMBRE],$row[CLIE_VRAZONSOCIAL],$row[CLIE_VDIRECCION],$row[CLIE_VCONTACTOLEGAL],$row[CLIE_VCOMUNA],$row[CLIE_VGIRO],$row[CLIE_VFONO],$row[CLIE_NDIASLIBRES], $row[CLIE_VACTIVIDAD]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>