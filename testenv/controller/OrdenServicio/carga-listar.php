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
	
	
	$query = "SELECT 	car.car_ncorr, 
						cont.cont_vnumcontenedor, 
						esca.esca_ncorr, 
						esca_vdescripcion,  
						cont.cont_npeso, 
						cont.cont_vcontenido, 
						cont.cont_dterminostacking, 
						cont.cont_ndiaslibres,
						cont.cont_vsello,
						cont.ada_ncorr,
						cont.cada_ncorr, 
						car.ose_ncorr, 
						car.tica_ncorr,
						car.car_vobservaciones,
						cont.med_ncorr,
						cont.cond_ncorr,
						date_format(tras.car_dfecharetiro, '%d/%m/%Y') car_dfecharetiro,
						date_format(tras.car_dfechapresentacion, '%d/%m/%Y') car_dfechapresentacion,
						car.car_nbooking,
						car.car_voperacion,
						cont.cont_vmarca,
						cont.cont_vcontenido,
						date_format(cont.cont_dterminostacking, '%d/%m/%Y') cont_dterminostacking,
						cont.lug_ncorr_devolucion,
						cont.cont_ndiaslibres,
						tras.car_vcontactoentrega,
						adic.car_ntemperatura,
						adic.car_nventilacion,
						adic.car_votros,
						adic.car_vobservaciones
				FROM 	tg_carga car 
					     INNER JOIN tb_estadocarga esca on car.esca_ncorr = esca.esca_ncorr
					     INNER JOIN tg_info_container cont on cont.car_ncorr = car.car_ncorr
					     LEFT JOIN  tg_info_traslado tras on tras.car_ncorr = car.car_ncorr
					     LEFT JOIN  tg_info_adicional adic on adic.car_ncorr = car.car_ncorr	
				WHERE car.tica_ncorr = 1 and car.ose_ncorr = ".$codOrden;

	$result = executeSQLCommand($query);		
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[car_ncorr];
		$responce -> rows[$i]['cell'] = array($row[car_ncorr],$row[esca_vdescripcion], 
		                                      $row[cont_vnumcontenedor],$row[cont_npeso]." Kg.",
		                                      $row[cont_vcontenido],$row[car_vobservaciones],
		                                      $row[cont_vsello],$row[ada_ncorr],$row[cada_ncorr],
		                                      $row[med_ncorr],$row[cond_ncorr], $row[car_dfecharetiro],
		                                      $row[car_dfechapresentacion],$row[car_nbooking],
		                                      $row[car_voperacion],$row[cont_vmarca],$row[cont_vcontenido],
		                                      $row[cont_dterminostacking],$row[lug_ncorr_devolucion],
		                                      $row[cont_ndiaslibres],$row[car_vcontactoentrega],
											  $row[car_ntemperatura],$row[car_nventilacion],
											  $row[car_votros],$row[esca_ncorr]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>