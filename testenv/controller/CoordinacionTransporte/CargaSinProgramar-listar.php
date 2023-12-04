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
	
	
	$query = "
				select	car.car_ncorr idcarga,
						date_format(ose.ose_dfechaservicio, '%d/%m/%Y') fechaeta,
						lug.lug_ncorr codpuntocarguio,
						lug.lug_vnombre puntocarguio,
						IF(car.lug_ncorr_actual = 0,'En traslado',ubicacion.lug_vnombre) ubicacion,
						IF(ose.lug_ncorrdestino > 0,destino.lug_vnombre, destinoplan.lug_vnombre) destino,
						UPPER(ose.ose_vnombrenave) nombrenave,
						UPPER(clie.clie_vnombre) cliente,
						inco.cont_vnumcontenedor numcontenedor,
						med.med_vdescripcion medida,
						IF (car.tica_ncorr=1,inco.cont_npeso,IF(cali.um_ncorr=2,cali.car_cantidad,0)) pesocarga,
						cond.cond_vdescripcion condicionespecial,
						car.car_nbooking operacion,
						ose.sts_ncorr,
						car.lug_ncorr_actual lug_ncorr
				from 	tg_carga car		
					    inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
					    inner join tb_cliente clie on clie.clie_vrut = ose.clie_vrut
					    inner join tb_lugar lug on ose.lug_ncorrorigen = lug.lug_ncorr
					    left join tg_servicio serv on serv.car_ncorr = car.car_ncorr
					    left join tb_lugar ubicacion on ubicacion.lug_ncorr = car.lug_ncorr_actual
					    left join tb_lugar destino on destino.lug_ncorr = ose.lug_ncorrdestino
					    left join tg_info_container inco on inco.car_ncorr = car.car_ncorr
					    left join tg_info_traslado tras on tras.car_ncorr = car.car_ncorr
					    left join tb_lugar destinoplan on destinoplan.lug_ncorr = tras.lug_ncorr_destino
					    left join tb_medidacontenedor med on med.med_ncorr = inco.med_ncorr
					    left join tb_condicionespecial cond on cond.cond_ncorr = inco.cond_ncorr
					    left join  tg_info_cargalibre cali on cali.car_ncorr = car.car_ncorr
					    where car.esca_ncorr in (1,4) ORDER BY $sidx $sord LIMIT $start , $limit";
						
			
	$result = executeSQLCommand($query);		
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$responce -> rows[$i]['id'] = $row[idcarga];
		$responce -> rows[$i]['cell'] =   array($row[idcarga],
												$row[fechaeta], 
												//$row[codpuntocarguio],
												$row[puntocarguio],
												$row[ubicacion],
												$row[destino],
												$row[nombrenave],
												$row[cliente],
												$row[numcontenedor],
												$row[medida],
												$row[pesocarga],
												$row[condicionespecial],
												$row[operacion],
												$row[sts_ncorr],
												$row[lug_ncorr]
												);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>