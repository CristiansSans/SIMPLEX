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
	
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tg_empresatransporte"); 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	mysql_query("SET NAMES 'utf8'");
	$result = executeSQLCommand("SELECT EMP_NCORR, EMP_VRUT, EMP_VNOMBRE,  EMP_VDIRECCION, EMP_VGIRO, EMP_VCONTACTO, EMP_VFONO, EMP_VMAIL, EMP_VRAZONSOCIAL, EMP_VACTIVIDAD, EMP_NGENERAGUIA FROM tg_empresatransporte ".$where." ORDER BY $sidx $sord LIMIT $start , $limit");
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[EMP_NCORR];
		$responce -> rows[$i]['cell'] = array($row[EMP_NCORR], $row[EMP_VRUT],$row[EMP_VNOMBRE],$row[EMP_VRAZONSOCIAL],$row[EMP_VDIRECCION],$row[EMP_VGIRO],$row[EMP_VCONTACTO],$row[EMP_VFONO],$row[EMP_VMAIL],$row[EMP_VACTIVIDAD],$row[EMP_NGENERAGUIA]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>