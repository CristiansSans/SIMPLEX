<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	//$fp = fopen("reporte.csv", "w");
	$CLIE_NRUT = $_GET['CLIE_NRUT'];
	$LUG_NCORR_ORIGEN = $_GET['LUG_NCORR_ORIGEN'];
	$LUG_NCORR_DESTINO = $_GET['LUG_NCORR_DESTINO'];
	$EMP_NCORR = $_GET['EMP_NCORR'];
	$sep = ","; 
	$salida_cvs;
	$contador;
	$contador = 1;
	$WHERE="";
	
	if ($CLIE_NRUT!=0){
		$WHERE = " CLIE_VRUT = ".$CLIE_NRUT;
	}
	
	if ($LUG_NCORR_ORIGEN!=0){
		if ($WHERE!=""){
			$WHERE = $WHERE." AND ";
		}
		$WHERE = $WHERE." codOrigen = ".$LUG_NCORR_ORIGEN;
	}
	
	if ($LUG_NCORR_DESTINO!=0){
		if ($WHERE!=""){
			$WHERE = $WHERE." AND ";
		}
		$WHERE = $WHERE." codDestino = ".$LUG_NCORR_DESTINO;
	}
	
	if ($EMP_NCORR!=0){
		if ($WHERE!=""){
			$WHERE = $WHERE." AND ";
		}
		$WHERE = $WHERE." EMP_NCORR = ".$EMP_NCORR;
	}	
		
	if ($WHERE==""){
		$result = executeSQLCommand("SELECT * FROM  vw_exportacion");
	}else{
		$result = executeSQLCommand("SELECT * FROM  vw_exportacion WHERE ".$WHERE);
	}

	
	$salida_cvs = $salida_cvs."<HTML LANG'es'><head><title>Exportacion</title></head><body>";
	
	$salida_cvs = $salida_cvs."<table border='1' cellpadding=1 cellspacing=1>";
	$salida_cvs = $salida_cvs."<th>N&deg</th><th>Nombre</th><th>Nave</th><th>Orden servicio</th><th>Fecha servicio</th>";
	$salida_cvs = $salida_cvs."<th>Ingreso</th><th>Num Factura</th><th>Fecha factura</th><th><N&deg guia</th><th>Fecha guia</th>";
	$salida_cvs = $salida_cvs."<th>Tramo</th><th>Nombre</th><th>Patente</th><th>Costo</th>";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$linea = "<tr>";
		$linea = $linea."<td>".$contador."</td>";
		$linea = $linea."<td>".$row[CLIE_VNOMBRE]."</td>";
		$linea = $linea."<td>".$row[OSE_VNOMBRENAVE]."</td>";
		$linea = $linea."<td>".$row[OSE_NCORR]."</td>";
		$linea = $linea."<td>".$row[OSE_DFECHASERVICIO]."</td>";
		$linea = $linea."<td>".$row[ingreso]."</td>";
		$linea = $linea."<td>".$row[fact_ncorr]."</td>";
		$linea = $linea."<td>".$row[fact_dfecha]."</td>";
		$linea = $linea."<td>".$row[guia_ncorr]."</td>";
		$linea = $linea."<td>".$row[guia_dfecha]."</td>";
		$linea = $linea."<td>".$row[Tramo]."</td>";
		$linea = $linea."<td>".$row[emp_vnombre]."</td>";
		$linea = $linea."<td>".$row[cam_vpatente]."</td>";
		$linea = $linea."<td>".$row[Costo]."</td>";
		$linea = $linea."</tr>";
		
		$salida_cvs = $salida_cvs.$linea;
		$contador = $contador +1;
	}
	$salida_cvs = $salida_cvs."</table>";
	$salida_cvs = $salida_cvs."</body></html>";
	/*
	$titulo = "N°,Contenedor,Cliente,Nave,Doc.Venta,Fecha DV, Ingreso,N° fac.Venta,Fecha Factura, Guia, Fecha Guia, Tramo, Transportista,Camion,Costo\n";
	$salida_cvs = $salida_cvs.$titulo;
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {	
		$linea =  $contador.$sep."-".$sep.$row[CLIE_VNOMBRE].$sep.$row[OSE_VNOMBRENAVE].$sep.$row[OSE_NCORR].$sep.$row[OSE_DFECHASERVICIO].
	 * $sep.$row[ingreso].$sep.$row[fact_ncorr].$sep.$row[fact_dfecha].$sep.$row[guia_ncorr].$sep.$row[guia_dfecha].$sep.
	 * $row[Tramo].$sep.$row[emp_vnombre].$sep.$row[cam_vpatente].$sep.$row[Costo]."\n";
		$salida_cvs = $salida_cvs.$linea;
		$contador = $contador +1;			
	}

	header("Content-type: application/vnd.ms-excel");
	header("Content-disposition: csv" . "exportacion.csv");
	header( "Content-disposition: filename=exportacion.csv");
	 * 
	 */
	 
	header("Content-Type: application/vnd.ms-excel");header("Expires: 0");
	header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
	header("content-disposition: attachment;filename=Reporte.xls");	 
	print $salida_cvs;
	exit;	
?>