<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$WHERE="";
	$sep = ";";
	$contador = 1;
	$query;
	
	$CLIE_NRUT = $_GET['cliente'];	
	$INICIO    = $_GET['inicio'];
	$TERMINO   = $_GET['termino'];
	
	if ($CLIE_NRUT>0){
		$where = " where 	car.esca_ncorr>0 and clie.clie_vrut =" . $CLIE_NRUT." AND ose.ose_dfechaservicio BETWEEN '". $INICIO."' AND '".$TERMINO."' ";
	}else{
		$where = " where 	car.esca_ncorr>0 and ose.ose_dfechaservicio BETWEEN '". $INICIO."' AND '".$TERMINO."' ";	
	}
	
	$query = "select	car.car_ncorr, 
						IF(lug.lug_ncorr>0,lug.lug_vnombre,'En traslado') as ubicacion, 
						esca.esca_vdescripcion, cont.cont_vnumcontenedor, cont.cont_npeso, cont.cont_vcontenido, car.car_vobservaciones, 
						esca.esca_ncorr, lug.lug_ncorr, clie.clie_vnombre, DATE_FORMAT(max(serv.serv_dtermino),'%d/%m/%Y %k:%i') termino,
						datediff(curdate(),max(serv.serv_dtermino)) diasbodega,
						datediff(curdate(),min(serv.serv_dinicio)) diascustodia,
				        IF(car.tica_ncorr=1 and tise.tine_ncorr = 5,datediff(curdate(),DATE_ADD(car.car_fechaeta,INTERVAL clie.clie_ndiaslibres DAY)),0) demurrage,
				        ose.ose_dfechaservicio
				from	tg_carga car
						inner join tb_estadocarga esca on esca.esca_ncorr = car.esca_ncorr
						inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
				        inner join vw_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
						inner join tb_cliente clie on ose.clie_vrut = clie.clie_vrut
						inner join tg_servicio serv on serv.car_ncorr = car.car_ncorr
						left join  tg_info_container cont on cont.car_ncorr = car.car_ncorr
						left join  tb_lugar lug on lug.lug_ncorr = car.lug_ncorr_actual";
	$query2 = " group by car.car_ncorr, lug.lug_ncorr, esca.esca_vdescripcion, cont.cont_vnumcontenedor, cont.cont_npeso, cont.cont_vcontenido, car.car_vobservaciones, esca.esca_ncorr, lug.lug_ncorr, clie.clie_vnombre, ose.ose_dfechaservicio
				order by esca.esca_vdescripcion asc";
	
	$result = executeSQLCommand($query.$where.$query2);
	//echo $query.$where.$query2;
	
	if ($WHERE==""){
		
		$result = executeSQLCommand($query.$where.$query2);
	}else{
		$result = executeSQLCommand($query);
	}
	
	$titulo = "IdCarga;Ubicacion;Estado carga; Contenedor; Peso; Contenido; Observaciones; Cliente; Termino; Dias custodia; Dias stop; Demurrage;Fecha orden\n";
	$salida_cvs = $salida_cvs.$titulo;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {		
		$linea =  $row[car_ncorr].$sep.$row[ubicacion].$sep.$row[esca_vdescripcion].$sep.$row[cont_vnumcontenedor].$sep.$row[cont_npeso].$sep.$row[cont_vcontenido].$sep.$row[car_vobservaciones].$sep.$row[clie_vnombre].$sep.$row[termino].$sep.$row[diasbodega].$sep.$row[diascustodia].$sep.$row[demurrage].$sep.$row[ose_dfechaservicio]."\n";
		$salida_cvs = $salida_cvs.$linea;
		$contador = $contador +1;			
	}
	
	header("Content-type: application/vnd.ms-excel");
	header("Content-disposition: csv" . "exportacion_inventario.csv");
	header( "Content-disposition: filename=exportacion_inventario.csv");
	print $salida_cvs;
	exit;
?>