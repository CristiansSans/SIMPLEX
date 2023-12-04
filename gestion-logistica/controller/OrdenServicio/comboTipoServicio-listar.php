<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$tipo = $_GET['tipo'];
	$codCliente 	= $_GET['codCliente'];
	$codTipoNegocio = $_GET['codTipoNegocio'];
	$query = "";
	$resp = "|";
	
	$query = "SELECT sts.sts_ncorr as value, upper(sts.sts_vnombre) as text FROM tb_subtiposervicio sts ";
	$query = $query ." inner join tb_tiposervicio tise on sts.tise_ncorr = tise.tise_ncorr where tise.tine_ncorr = ".$codTipoNegocio." and clie_vrut = ".$codCliente." ORDER BY tise_vdescripcion asc";
		
	$result = executeSQLCommand($query);
	
	//$i = 0;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $resp.$row[value].":".$row[text]."|";
	}	
	echo json_encode($resp);
?>