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

$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tb_lugar"); 
$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
$count = $row['count'];
if ($count > 0) {
	$total_pages = ceil($count / $limit);
} else {
	$total_pages = 0;
}

$result = executeSQLCommand("SELECT LUG_NCORR, LUG_VNOMBRE, LUG_VDIRECCION, LUG_VSIGLA, LUG_VCIUDAD, LUG_NCATEGORIA, LUG_NCORR_PADRE, LUG_NRETIRO, LUG_NCARGUIO, LUG_NDESTINO FROM tb_lugar ".$where." ORDER BY $sidx $sord LIMIT $start , $limit");

$i = 0;
while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
	$responce -> rows[$i]['id'] = $row[LUG_NCORR];
	$responce -> rows[$i]['cell'] = array($row[LUG_NCORR], $row[LUG_VSIGLA],$row[LUG_VNOMBRE],$row[LUG_VDIRECCION],$row[LUG_VCIUDAD],$row[LUG_NCORR_PADRE],$row[LUG_NCATEGORIA],$row[LUG_NRETIRO],$row[LUG_NCARGUIO],$row[LUG_NDESTINO]);
	$i++;
}
$responce -> page = $page;
$responce -> total = $total_pages;
$responce -> records = $count;
echo json_encode($responce);

?>