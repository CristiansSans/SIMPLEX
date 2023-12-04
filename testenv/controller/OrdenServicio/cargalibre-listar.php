<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$codOrden = $_GET['codOrden'];
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
	
	
	$query = "	SELECT 	car.car_ncorr, 
						esca.esca_ncorr, 
						esca_vdescripcion,  
						car.ose_ncorr, 
						car.tica_ncorr,
						car.car_vobservaciones,
                        cali.car_cantidad,
                        um.im_vdescripcion,
                        um.um_ncorr,
                        date_format(tras.car_dfecharetiro, '%d/%m/%Y') car_dfecharetiro,
						date_format(tras.car_dfechapresentacion, '%d/%m/%Y') car_dfechapresentacion,
                        tras.car_vcontactoentrega,
                        car.car_nbooking,
                        car.car_voperacion
				FROM 	tg_carga car 
					     INNER JOIN tb_estadocarga esca on car.esca_ncorr = esca.esca_ncorr
                         INNER JOIN tg_info_cargalibre cali on cali.car_ncorr = car.car_ncorr
                         INNER JOIN tb_unidadmedida um on um.um_ncorr = cali.um_ncorr
                         LEFT JOIN tg_info_traslado tras on car.car_ncorr = tras.car_ncorr
				WHERE 	car.tica_ncorr = 2 and car.ose_ncorr = ".$codOrden;

	$result = executeSQLCommand($query);		
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[car_ncorr];
		$responce -> rows[$i]['cell'] = array($row[car_ncorr],$row[esca_vdescripcion], $row[car_cantidad],
										$row[im_vdescripcion],$row[car_vobservaciones],$row[um_ncorr],
										$row[car_dfecharetiro],$row[car_dfechapresentacion],
										$row[car_vcontactoentrega],$row[car_nbooking],$row[car_voperacion],
										$row[esca_ncorr]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>