<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$codServicio 	= $_GET['codServicio'];
	
	//$tra_ncorr 		= $_POST['tra_ncorr'];
	
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

	$query1 = 	"SELECT COUNT(*) AS count FROM tg_tramo_subtiposervicio WHERE sts_ncorr = ".$codServicio;
		
	$result1 = executeSQLCommand($query1);
	 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	$query2 = "	select 	tss_ncorr,tra.tra_ncorr, tra.nombre
				from	tg_tramo_subtiposervicio sts 
						inner join vw_tramo tra on sts.tra_ncorr = tra.tra_ncorr
				where	sts_ncorr = ".$codServicio;	
	
	
	$result = executeSQLCommand($query2);
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[tss_ncorr];
		$responce -> rows[$i]['cell'] = array($row[tss_ncorr], $row[tra_ncorr],$row[nombre]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>