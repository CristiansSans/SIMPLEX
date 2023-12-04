<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$page = $_GET['page'];
	// get the requested page
	$limit = $_GET['rows'];
	$filters = $_GET['filters'];
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
	
	if ($filters!=null){
		$obj = json_decode($filters);
		$rules = $obj->{'rules'};
		$auxValue = $rules[0];
		$auxField = $auxValue->{'field'};
		$auxData = $auxValue->{'data'};
		if($auxField!=null){
			if($auxField=="ORIGEN"){
				$auxField = "lugo.LUG_VNOMBRE";
			};
			if($auxField=="DESTINO"){
				$auxField = "lugd.LUG_VNOMBRE";
			};			
			$where = " WHERE ".$auxField." LIKE '%".$auxData."%'";
		}
	}		
	
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tg_tramo"); 
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}

	$result = executeSQLCommand("SELECT tra.TRA_NCORR, LUG_NCORR_ORIGEN, lugo.LUG_VNOMBRE ORIGEN, LUG_NCORR_DESTINO, lugd.LUG_VNOMBRE DESTINO ,TRA_KMS, TRA_TIEMPO FROM tg_tramo tra INNER JOIN tb_lugar lugo on lugo.lug_ncorr = tra. LUG_NCORR_ORIGEN INNER JOIN tb_lugar lugd on lugd.lug_ncorr = tra. LUG_NCORR_DESTINO ".$where." ORDER BY $sidx $sord LIMIT $start , $limit");
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[TRA_NCORR];
		$responce -> rows[$i]['cell'] = array($row[TRA_NCORR], $row[LUG_NCORR_ORIGEN], $row[ORIGEN],$row[LUG_NCORR_DESTINO],$row[DESTINO],$row[TRA_KMS],$row[TRA_TIEMPO]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	
	if ($filters!=null){
		$responce -> field = $auxField;
		$responce -> value = $auxData;
	}	
	
	echo json_encode($responce);
	
?>