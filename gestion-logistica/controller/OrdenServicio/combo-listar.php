<?php
include_once '../../model/class.php';
include_once '../../model/config.php';
$tipo = $_GET['tipo'];
$param = $_GET['param'];
$query = "";
$resp = "|";
if ($tipo > 0) {
	switch ($tipo) {
		case 1 :
			$query = "SELECT clie_vrut as value, clie_vnombre as text FROM tb_cliente ORDER BY clie_vnombre ASC";
			break;
		case 2 :
			//$query = "SELECT clie_vrut as value, clie_vnombre as text FROM tb_cliente where clie_nrutpadre = " . $param . " ORDER BY clie_vnombre ASC";
			$query = "SELECT clie_vrut as value, clie_vnombre as text FROM tb_cliente where clie_vrut = " . $param . " ORDER BY clie_vnombre ASC";
			break;
		case 3 :
			$query = "SELECT tise_ncorr as value, tise_vdescripcion as text FROM vw_tiposervicio ORDER BY tise_vdescripcion asc";
			break;
		case 4 :
			$query = "SELECT sts_ncorr as value, sts_vnombre as text FROM tb_subtiposervicio where tise_ncorr = " . $param . " order by sts_vnombre asc";
			break;
		case 5 :
			$query = "select ada_ncorr as value, ada_vnombre as text from tb_agenciaaduana order by ada_vnombre asc";
			break;
		case 6 :
			$query = "select cada_ncorr as value, cada_vnombre as text from tg_contacto_agencia where ada_ncorr = " . $param . " order by cada_vnombre asc";
			break;
		case 7 :
			$query = "select med_ncorr as value, med_vdescripcion as text from tb_medidacontenedor order by med_vdescripcion asc";
			break;
		case 8 :
			$query = "select cond_ncorr as value, upper(cond_vdescripcion) as text from tb_condicionespecial order by cond_vdescripcion asc";
			break;
		case 9 :
			$query = "select lug_ncorr as value, lug_vnombre as text from tb_lugar order by lug_vnombre asc";
			break;
		case 10 :
			$query = "select um_ncorr as value, upper(im_vdescripcion) as text from tb_unidadmedida order by im_vdescripcion asc";
			break;
		case 11 :
			$query = "select lug_ncorr as value, lug_vnombre as text from tb_lugar where lug_nretiro = 1 order by lug_vnombre asc";
			break;
		case 12 :
			$query = "select lug_ncorr as value, lug_vnombre as text from tb_lugar where lug_ncarguio = 1 order by lug_vnombre asc";
			break;
		case 13 :
			$query = "select lug_ncorr as value, lug_vnombre as text from tb_lugar where lug_ndestino = 1 order by lug_vnombre asc";
			break;
		case 14 :
			$query = "select emp_ncorr as value, upper(left(emp_vnombre,20)) as text from tg_empresatransporte order by emp_vnombre asc";
			break;
		case 15 :
			$query = "select cam_ncorr as value, cam_vpatente as text from tg_camion where emp_ncorr = " . $param . " order by cam_vpatente asc";
			break;
		case 16 :
			$query = "select cha_ncorr as value, cha_vpatente as text from tg_chasis where emp_ncorr = " . $param . " order by cha_vpatente asc";
			break;
		case 17 :
			$query = "select chof_ncorr as value, upper(chof_vnombre) as text from tg_chofer where emp_ncorr = " . $param . " order by chof_vnombre asc";
			break;
		case 18 :
			$query = "select distinct tine.tine_ncorr as value, upper(tine.tine_vnombre) as text from tb_tiponegocio tine inner join tb_tiposervicio tise on tine.tine_ncorr = tise.tine_ncorr order by tine.tine_vnombre asc";
			break;
		case 19 :
			$query = "SELECT tise_ncorr as value, upper(tise_vdescripcion) as text FROM tb_tiposervicio where tine_ncorr = " . $param . " ORDER BY tise_vdescripcion asc";
			break;
		case 20 :
			$query = "SELECT tra_ncorr as value, upper(nombre) as text FROM vw_tramo";
			break;
		case 21 :
			$query = "SELECT tine_ncorr as value, tine_vnombre as text FROM tb_tiponegocio order by tine_vnombre asc";
			/*$query = "SELECT distinct tise.tise_ncorr as value, upper(tise.tise_vdescripcion) as text FROM vw_tiposervicio tise inner join tb_subtiposervicio sts on tise.tise_ncorr = sts.tise_ncorr
							where sts.clie_vrut = " . $param . " ORDER BY tise.tise_vdescripcion asc";*/
			break;
		case 22 :
			$query = "select lug_ncorr as value, lug_vnombre as text from tb_lugar where lug_ncorr = " . $param . " order by lug_vnombre asc";
			break;
		case 23 :
			$query = "	select distinct emp.emp_ncorr as value, upper(left(emp_vnombre,20)) as text 
							from tg_empresatransporte emp inner join tg_tarifa tra on emp.emp_ncorr = tra.emp_ncorr
							where tra.tra_ncorr = " . $param . " order by emp.emp_vnombre asc";
			break;
		case 24 :
			$query = "select lug_ncorr as value, lug_vnombre as text from tb_lugar where lug_ncorr_padre = " . $param . " order by lug_vnombre asc";
			break;
		case 25:
			$query = "select emp_ncorr as value, upper(left(emp_vnombre,20)) as text from tg_empresatransporte where emp_ngeneraguia = 1 order by emp_vnombre asc";
			break;
	}

	//mysql_query("SET NAMES 'utf8'");
	$result = executeSQLCommand($query);

	//$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp . $row[value] . ":" . $row[text] . "|";
	}
	echo json_encode($resp);
} else {
	$query = "SELECT 1 as tipo, clie_vrut as value, clie_vnombre as text, 0 as parent FROM tb_cliente ORDER BY clie_vnombre ASC";
	$result = executeSQLCommand($query);
	$resp = "|";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp . $row[tipo] . ":" . $row[value] . ":" . $row[text] . ":" . $row[parent] . "|";
	}
	$responce -> clientes = $resp;

	$query = "SELECT 2 as tipo, clie_vrut as value, clie_vnombre as text, clie_nrutpadre as parent FROM tb_cliente ORDER BY clie_vnombre ASC";
	$result = executeSQLCommand($query);
	$resp = "|";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp . $row[tipo] . ":" . $row[value] . ":" . $row[text] . ":" . $row[parent] . "|";
	}
	$responce -> subclientes = $resp;

	$query = "SELECT 2 as tipo,  tise_ncorr as value, tise_vdescripcion as text, 0 as parent FROM tb_tiposervicio ORDER BY tise_vdescripcion asc";
	$result = executeSQLCommand($query);
	$resp = "|";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp . $row[tipo] . ":" . $row[value] . ":" . $row[text] . ":" . $row[parent] . "|";
	}
	$responce -> tiposervicio = $resp;
	echo json_encode($responce);
}
?>