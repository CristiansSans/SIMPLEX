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

$result = executeSQLCommand("SELECT LUG_NCORR, LUG_VNOMBRE, LUG_VDIRECCION, LUG_VSIGLA, LUG_VCIUDAD, LUG_NCATEGORIA, LUG_NCORR_PADRE FROM tb_lugar ".$where." ORDER BY $sidx $sord LIMIT $start , $limit");

$i = 0;
while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
	$responce -> rows[$i]['id'] = $row[LUG_NCORR];
	$responce -> rows[$i]['cell'] = array($row[LUG_NCORR], $row[LUG_VSIGLA],$row[LUG_VNOMBRE],$row[LUG_VDIRECCION],$row[LUG_VCIUDAD],$row[LUG_NCATEGORIA]);
	$i++;
}
$responce -> page = $page;
$responce -> total = $total_pages;
$responce -> records = $count;
echo json_encode($responce);
/*
 if ($page > $total_pages)
 $page = $total_pages;
 $start = $limit * $page - $limit;

 $SQL = "SELECT a.id, a.invdate, b.name, a.amount,a.tax,a.total,a.note FROM invheader a, clients b WHERE a.client_id=b.client_id ORDER BY $sidx $sord LIMIT $start , $limit";
 $result = mysql_query($SQL) or die("Couldn t execute query." . mysql_error());

 $responce -> page = $page;
 $responce -> total = $total_pages;
 $responce -> records = $count;
 $i = 0;
 while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
 $responce -> rows[$i]['id'] = $row[id];
 $responce -> rows[$i]['cell'] = array($row[id], $row[invdate], $row[name], $row[amount], $row[tax], $row[total], $row[note]);
 $i++;
 }
 echo json_encode($responce);*/

/*$arr = array ('success'=>true,'data'=>"pico");
 echo json_encode($arr); // {"a":1,"b":2,"c":3,"d":4,"e":5}*/
?>