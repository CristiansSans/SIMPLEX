<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$WHERE="";
	$sep = ",";
	$contador = 1;
	if ($WHERE==""){
		$result = executeSQLCommand("SELECT * FROM  vw_inventario");
	}else{
		$result = executeSQLCommand("SELECT * FROM  vw_inventario WHERE ".$WHERE);
	}

	$salida_cvs = $salida_cvs."<HTML LANG'es'><head><title>Exportacion de inventario</title></head><body>";
	
	$salida_cvs = $salida_cvs."<table border='1' cellpadding=1 cellspacing=1>";
	$salida_cvs = $salida_cvs."<th>N&deg carga</th><th>Estado carga</th><th>Tipo carga</th><th>N&deg contenedor</th><th>Origen</th>";
	$salida_cvs = $salida_cvs."<th>Destino</th><th>Rut</th><th>Nombre</th><th>Cod.Empresa</th><th>Empresa</th>";
	$salida_cvs = $salida_cvs."<th>Ubicacion actual</th><th>Cod.Ubicacion</th>";

	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$linea = "<tr>";
		$linea = $linea."<td>".$row[car_ncorr]."</td>";
		$linea = $linea."<td>".$row[esca_vdescripcion]."</td>";
		$linea = $linea."<td>".$row[tica_vdescripcion]."</td>";
		$linea = $linea."<td>".$row[cont_vnumcontenedor]."</td>";
		$linea = $linea."<td>".$row[NombreOrige]."</td>";
		$linea = $linea."<td>".$row[NombreDestino]."</td>";
		$linea = $linea."<td>".$row[clie_vrut]."</td>";
		$linea = $linea."<td>".$row[clie_vnombre]."</td>";
		$linea = $linea."<td>".$row[emp_ncorr]."</td>";
		$linea = $linea."<td>".$row[emp_vnombre]."</td>";
		$linea = $linea."<td>".$row[ubicacion]."</td>";
		$linea = $linea."<td>".$row[codUbicacion]."</td>";
		$linea = $linea."</tr>";
		$salida_cvs = $salida_cvs.$linea;
	}
	$salida_cvs = $salida_cvs."</table>";
	$salida_cvs = $salida_cvs."</body></html>";
		
	header("Content-Type: application/vnd.ms-excel");header("Expires: 0");
	header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
	header("content-disposition: attachment;filename=ReporteInventario.xls");	 		

	print $salida_cvs;
	exit;	
?>