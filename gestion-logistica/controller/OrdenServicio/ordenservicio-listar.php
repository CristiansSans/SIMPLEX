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

	$select = "ose.ose_ncorr,          
            date_format(ose_dfechaservicio, '%d/%m/%Y') ose_dfechaservicio,
            UPPER(cte.clie_vnombre) clie_vnombre,
            UPPER(sts.sts_vnombre) tise_vdescripcion,
            count(*) as items,
            '' as esca_vdescripcion,
            ose.clie_vrut,
            ose.clie_vrutsubcliente,
            ose.tise_ncorr as tise_ncorr,
            UPPER(ose.sts_ncorr) sts_ncorr,
            ose.usua_ncorr,
            concat(usua.usua_vnombre,' ', usua.usua_vapellido1) vendedor,
            ose.ose_vnombrenave,
            ose.ose_vobservaciones,
            ose.lug_ncorrorigen,
            ose.lug_ncorrdestino,
            ose.lug_ncorr_puntocarguio  as lug_ncorrcarguio";

	$join = "tg_ordenservicio ose
        left join tg_carga car on ose.ose_ncorr = car.ose_ncorr
        left join tb_cliente cte on ose.clie_vrut = cte.clie_vrut
        left join vw_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
        left join tg_usuario usua on ose.usua_ncorr = usua.usua_ncorr
        left join tb_subtiposervicio sts on sts.sts_ncorr = ose.sts_ncorr";

	$group = "ose.ose_ncorr,
            ose_dfechaservicio,
            cte.clie_vnombre,
            tise.tise_vdescripcion,
            ose.clie_vrut,
            ose.clie_vrutsubcliente,
            ose.tise_ncorr,
            ose.sts_ncorr,
            ose.usua_ncorr,
            usua.usua_vnombre,
            usua.usua_vapellido1,
            ose.ose_vnombrenave,
            ose.ose_vobservaciones,
            ose.lug_ncorrorigen,
            ose.lug_ncorrdestino,
            ose.lug_ncorr_puntocarguio";

    //$queryGrupo = "SELECT COUNT(*) AS count FROM ".$join;
    
    $queryGrupo = "SELECT COUNT(*) AS count FROM tg_ordenservicio";
	//echo $queryGrupo;
	
	
	//$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM ".$join); 
	$result1 = executeSQLCommand("SELECT COUNT(*) AS count FROM tg_ordenservicio");
	$row = mysql_fetch_array($result1,MYSQL_ASSOC); 
	$count = $row['count'];
	if ($count > 0) {
		$total_pages = ceil($count / $limit);
	} else {
		$total_pages = 0;
	}
	
	$query = "SELECT ".$select." FROM ".$join." GROUP BY ".$group." ".$where." ORDER BY $sidx $sord LIMIT $start , $limit";
	
	$result = executeSQLCommand($query);
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[ose_ncorr];
		$responce -> rows[$i]['cell'] = array($row[ose_ncorr], $row[ose_dfechaservicio],$row[clie_vnombre],
											  $row[tise_vdescripcion],$row[items],$row[esca_vdescripcion],
											  $row[clie_vrut],$row[clie_vrutsubcliente],$row[tise_ncorr],
											  $row[sts_ncorr],$row[vendedor],$row[ose_vnombrenave],
											  $row[ose_vobservaciones],$row[lug_ncorrorigen],
											  $row[lug_ncorrdestino],$row[lug_ncorrcarguio],$row[usua_ncorr]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>