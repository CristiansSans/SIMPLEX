

<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	//Combo lugares
	$textoLugares;
	$textoClientes;
	$textoEmpresas;
		
	$result = executeSQLCommand("SELECT LUG_NCORR, UPPER(LUG_VNOMBRE) AS LUG_VNOMBRE FROM tb_lugar ORDER BY LUG_VNOMBRE ASC");
	$textoLugares = "";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {		
		$textoLugares = $textoLugares.$row[LUG_NCORR].":".$row[LUG_VNOMBRE]."|";
	}

	
	$result = executeSQLCommand("SELECT CLIE_VRUT, UPPER(CLIE_VNOMBRE) AS CLIE_VNOMBRE FROM tb_cliente ORDER BY CLIE_VNOMBRE ASC");
	$textoClientes = "";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$textoClientes = $textoClientes.$row[CLIE_VRUT].":".$row[CLIE_VNOMBRE]."|";
	}
	
	$result = executeSQLCommand("SELECT EMP_NCORR, UPPER(EMP_VNOMBRE) AS EMP_VNOMBRE FROM tg_empresatransporte ORDER BY EMP_VNOMBRE ASC");
	$textoEmpresas = "";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$textoEmpresas = $textoEmpresas.$row[EMP_NCORR].":".$row[EMP_VNOMBRE]."|";
	}	
	
	$arr = array('lugares'=>$textoLugares,'clientes'=>$textoClientes,'empresas'=>$textoEmpresas);
	echo json_encode($arr);
	
?>