<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$codRol = $_GET['codRol'];
	
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
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tb_permiso WHERE ROL_NCORR = ". $codRol);
	 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	mysql_query("SET NAMES 'utf8'");
	$query = "SELECT tb_funcionalidad.func_ncorr, func_vdescripcion, (";
	$query = $query ." SELECT COUNT( * ) FROM tb_permiso WHERE tb_permiso.func_ncorr = tb_funcionalidad.func_ncorr AND tb_permiso.ROL_NCORR =".$codRol.") AS Activo";
	$query = $query ." FROM tb_funcionalidad order by func_vdescripcion asc";
	$result = executeSQLCommand($query);
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[func_ncorr];
		$responce -> rows[$i]['cell'] = array($row[func_ncorr], $row[func_vdescripcion],$row[Activo]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>