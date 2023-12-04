<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	//$fp = fopen("reporte.csv", "w");
	$query;
	$query2;
	$query3;
	$sep = ";"; 
	$salida_cvs;
	$contador;
	$contador = 1;
	$WHERE="";
	$textoMail;
	
	$CLIE_NRUT = $_GET['cliente'];	
	$INICIO    = $_GET['inicio'];
	$TERMINO   = $_GET['termino'];

	//$WHERE = " IngresoOrden between '".$INICIO."' and '".$TERMINO."' ";
	if ($CLIE_NRUT!=0){
		//$WHERE += " and clie_vrut = ".$CLIE_NRUT;
		$WHERE = " clie_vrut = ".$CLIE_NRUT;
	}
	
	$query = "SELECT ose_ncorr, 'Ingreso' TipoMovimiento, clie_vnombre, Origen, Destino, Vendedor, EstadoCarga, car_ncorr, Tipo, Tarifa, codServicio, Empresa, Tramo, Costo, IngresoOrden
			  FROM vw_ingresosfinancieros_listar 
			  WHERE ".$WHERE;
			   
	$query2 = " SELECT ose_ncorr, 'Gasto' TipoMovimiento, clie_vnombre, Origen, Destino, Vendedor, EstadoCarga, car_ncorr, Tipo, Tarifa, IFNULL( codServicio, 0 ) codServicio, Empresa, Tramo, Costo, IngresoOrden
			  FROM vw_gastosOperacionales_listar 
			  WHERE ".$WHERE;			   

	$query3 = $query ." UNION ". $query2 ." ORDER BY ose_ncorr ASC , car_ncorr ASC , codServicio asc, TipoMovimiento DESC ";
	$textoMail = $textoMail."Query a ejecutar :\n".$query3."\n\n";

	$result = executeSQLCommand($query3);
	
	$titulo = "Orden Servicio;Tipo Movimiento;Cliente;Origen;Destino;Vendedor;Estado carga;Id.Carga;Tipo;Tarifa;Cod.Servicio;Empresa;Tramo;Costo; Ingreso Orden\n";
	$salida_cvs = $salida_cvs.$titulo;
	$textoMail = $textoMail."Titulo :\n".$titulo."\n\n";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {	
		$linea =  $row[ose_ncorr].$sep.$row[TipoMovimiento].$sep.$row[clie_vnombre].$sep.$row[Origen].$sep.$row[Destino].$sep.$row[Vendedor].$sep.$row[EstadoCarga].$sep.$row[car_ncorr].$sep.$row[Tipo].$sep.$row[Tarifa].$sep.$row[codServicio].$sep.$row[Empresa].$sep.$row[Tramo].$sep.$row[Costo].$sep.$row[IngresoOrden]."\n";
		$textoMail = $textoMail."Linea :\n".$linea."\n";
		$salida_cvs = $salida_cvs.$linea;
		$contador = $contador +1;			
	}

	//error_log($textoMail,1,'haichele@gmail.com');

	header("Content-type: application/vnd.ms-excel");
	header("Content-disposition: csv" . "exportacion.csv");
	header( "Content-disposition: filename=exportacion.csv");
	print $salida_cvs;
	exit;	
?>