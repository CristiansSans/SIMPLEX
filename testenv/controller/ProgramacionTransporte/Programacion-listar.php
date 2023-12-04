<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$auxTexto;	
	$codOrden = $_GET['codOrden'];
	$page = $_GET['page'];
	
	$limit = $_GET['rows'];
	$start = $limit * $page - $limit;	
	$sidx = $_GET['sidx'];	
	$sord = $_GET['sord'];
	
	if (!$sidx)
		$sidx = 1;
	if ($page == null)
		$page = 1;	
		
	$query = "	
		select  serv.car_ncorr,
				serv.serv_ncorr,
				date_format(serv.serv_dinicio, '%d/%m/%Y %H:%i')	serv_dinicio,
				DATE_FORMAT(serv.serv_dtermino,'%d/%m/%Y %H:%i')    serv_dtermino,
				UPPER(clie.clie_vnombre)      clie_vnombre,
				tise.tise_ncorr,
                tise.tine_ncorr,
				UPPER(sts.sts_vnombre) tise_vdescripcion,
				lug1.lug_ncorr              idlugarorigen,
				UPPER(lug1.lug_vnombre)     descripcionlugarorigen,
				lug2.lug_ncorr              idlugardestino,
				UPPER(lug2.lug_vnombre)     descripcionlugardestino,
				UPPER(emp.emp_vnombre)      emp_vnombre,
				emp.emp_ncorr,
				cam.cam_vpatente,
				cam.cam_ncorr,
				cha.cha_ncorr,
				cha_vpatente,
				car.ose_ncorr,
				cho.chof_ncorr,
				UPPER(cho.chof_vnombre)     chof_vnombre,
				serv.serv_vcelular,
				guia.guia_ncorr, 
				CONCAT(LPAD(guia.guia_numero,6,'0'),' (', if(guia.guia_ntipo=1,'SII','Virtual'),')') guia_numero,
				guia.guia_ntipo,
				ose.sts_ncorr,
				date_format(guia.guia_dfecha, '%d/%m/%Y %H:%i') guia_dfecha,
				guia.emp_ncorr as empGuia,
				guia.guia_numero,
				date_format(car.car_fechaeta, '%d/%m/%Y') car_fechaeta
		from    tg_carga car
				inner join tg_servicio serv on serv.car_ncorr = car.car_ncorr
				inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
				inner join tb_subtiposervicio sts on ose.sts_ncorr = sts.sts_ncorr
				inner join tb_cliente clie on clie.clie_vrut = ose.clie_vrut
				inner join vw_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
				inner join tb_lugar lug1 on lug1.lug_ncorr = car.lug_ncorr_actual
				left join tb_lugar lug2 on lug2.lug_ncorr = serv.lug_ncorr_destino
				left join tg_empresatransporte emp on emp.emp_ncorr = serv.emp_ncorr
				left join tg_camion cam on cam.cam_ncorr = serv.cam_ncorr
				left join tg_chasis cha on cha.cha_ncorr = serv.cha_ncorr
				left join tg_chofer cho on cho.chof_ncorr = serv.chof_ncorr
				left join tg_guiatransporte guia on guia.guia_ncorr = serv.guia_ncorr	
		where	serv.serv_nterminado = 0 and car.esca_ncorr = 2	
	    ORDER BY $sidx $sord LIMIT $start , $limit";
						
			
	$result = executeSQLCommand($query);		
	
	$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		if ($row[guia_ncorr] > 0){
			$auxTexto = $row[guia_numero] . '<img src="img/ico_edit.png" onclick="editarGuia('.$row[serv_ncorr].',\''.$row[guia_dfecha].'\','.$row[guia_ncorr].','.$row[empGuia].','.$row[guia_numero].')"/>';;
		}else{
			$auxTexto = '<img src="img/ico_add.png" onclick="agregarGuia('.$row[serv_ncorr].')"/>';
		}
		$responce -> rows[$i]['id'] = $row[car_ncorr];
		$responce -> rows[$i]['cell'] =   array($row[car_ncorr],
												$row[clie_vnombre], 
												$row[tise_vdescripcion],
												$row[serv_dinicio],
												$row[descripcionlugarorigen],
												$row[serv_dtermino],
												$row[descripcionlugardestino],												
												$row[emp_vnombre],												
												$row[cam_vpatente],												
												$auxTexto,
												$row[idlugarorigen],
												$row[idlugardestino],
												$row[emp_ncorr],
												$row[cam_ncorr],
												$row[cha_ncorr],
												$row[chof_ncorr],
												$row[serv_vcelular],
												$row[sts_ncorr],
												$row[tine_ncorr],
												$row[car_fechaeta]
												);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>