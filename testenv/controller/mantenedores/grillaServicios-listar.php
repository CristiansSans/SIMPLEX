<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$rutCliente 		= $_GET['rutCliente'];
	$codtipoServicio 	= $_GET['codtipoServicio'];
	
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

	$query1 = 	"SELECT COUNT(*) AS count FROM tb_subtiposervicio WHERE clie_vrut = ".$rutCliente." AND tise_ncorr = ".$codtipoServicio;
		
	$result1 = executeSQLCommand($query1);
	 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	$query2 = "select sts_ncorr, sts_vnombre, tise_ncorr, lug_ncorr_origen, lug_ncorr_destino, clie_vrut, sts_nmonto 
	from 	tb_subtiposervicio 
	where 	clie_vrut = ".$rutCliente." AND tise_ncorr = ".$codtipoServicio." ORDER BY $sidx $sord LIMIT $start , $limit";	
	$result = executeSQLCommand($query2);
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[sts_ncorr];
		$responce -> rows[$i]['cell'] = array($row[sts_ncorr], $row[sts_vnombre],$row[tise_ncorr],$row[lug_ncorr_origen],$row[lug_ncorr_destino],$row[clie_vrut],$row[sts_nmonto]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);

?>