<?php 
	include_once '../model/class.php';
	include_once '../model/config.php';
	
	require_once("../../libs/dompdf/dompdf_config.inc.php");	

	$id  		= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;

	$queryparameter = "call prc_detallefactura_listar ($id)";
	$rs 		= executeSQLCommand(stripslashes($queryparameter));

	$idcarga			= '';
	$guia_numero		= '';
	$detalle			= '';
	$unitario			= '';
	
	while($obj = mysql_fetch_object($rs)) {
		$factura		= $obj->fact_numfactura;
		$fecha			= $obj->fact_dfecha;
		$cliente		= $obj->clie_vnombre;
		$rut			= $obj->rut;
		$direccion		= $obj->clie_vdireccion;
		$comuna			= $obj->clie_vcomuna;
		$giro			= $obj->clie_vgiro;
		$telefono		= $obj->clie_vfono;
		$observaciones	= $obj->fact_vobservaciones;
		$descuento		= $obj->fact_ndescuento;
		$subtotal		= $obj->fact_nsubtotal;
		$iva			= $obj->fact_niva;
		$total			= $obj->fact_ntotal;
		$tipoguia		= 0;//$obj->guia_ntipo;
//		$idcarga		= $obj->idcarga;
//		$guia_numero	= $obj->guia_numero;
//		$tipoguia		= 0;//$obj->guia_ntipo;
//		$detalle		= $obj->detalle;
//		$monto			= $obj->defa_monto;

		$idcarga	   	+= ($idcarga=='' ? '' : '<br>') . $obj->idcarga;
		$guia_numero	+= ($guia_numero=='' ? '' : '<br>') . $obj->guia_numero;
		$detalle	   	+= ($detalle=='' ? '' : '<br>') . $obj->detalle;
		$unitario		+= ($unitario=='' ? '' : '<br>') . number_format($obj->defa_monto);
		
		$lblfecha		= ($tipoguia == 1 ? '&nbsp;' : 'Fecha');
		$lblcliente		= ($tipoguia == 1 ? '&nbsp;' : 'Señores');
		$lblrut			= ($tipoguia == 1 ? '&nbsp;' : 'Rut');
		$lbldireccion	= ($tipoguia == 1 ? '&nbsp;' : 'Direccion');
		$lblcomuna		= ($tipoguia == 1 ? '&nbsp;' : 'Comuna');
		$lblgiro		= ($tipoguia == 1 ? '&nbsp;' : 'Giro');
		$lbltelefono	= ($tipoguia == 1 ? '&nbsp;' : 'Telefono');
		
		
		if ($tipoguia == 1){
			$lblrecuadro="	<table style='height:100px;text-align:center;font-size:16px;width:200px;'>
								<tr>
									<td style='height:20px;'>&nbsp;</td>
								</tr>
								<tr>
									<td style='height:20px;'>&nbsp;</td>
								</tr>
								<tr>
									<td style='height:30px;'>$factura</td>
								</tr>
							</table>
						 ";

			$lblheader	="	<tr>
								<td style='width:202px;text-align:left;'>&nbsp;</td>
								<td style='width:310px;text-align:center;'>&nbsp;</td>
								<td>".$lblrecuadro."</td>
							</tr>
						 ";
		}
		else{
			$lblrecuadro="	
							<table style='height:100px;text-align:center;font-size:16px;width:200px;border: 3px solid red;'>
								<tr>
									<td style='height:20px;'>RUT 99.999.999-9</td>
								</tr>
								<tr>
									<td style='height:20px;'>FACTURA</td>
								</tr>
								<tr>
									<td style='height:30px;'>$factura</td>
								</tr>
							</table>
						 ";

			$lblheader	="	<tr>
								<td style='width:202px;text-align:left;'><img src='../images/logo-159x115.png'></td>
								<td style='width:310px;text-align:center;'>SIMPLEX LOGISTICA</td>
								<td>".$lblrecuadro."</td>
							</tr>
						 ";
		}
	}
	
	$html	="	<html>
				<body style='font-size:16px;'>
					<table style='vertical-align:top;align:center;width:85%;'>
						<tr>
			 ".
						$lblheader.
			 "
						</tr>
					</table>
				<table style='vertical-align:center;width:90%;'>
					<tr>
						<td width='15%'><b>$lblfecha</b></td>
						<td width='50%'>$fecha</td>
						<td width='15%'>&nbsp;</td>
						<td width='25%'>&nbsp;</td>
					</tr>
					<tr>
						<td><b>$lblcliente</b></td>
						<td>$cliente</td>
						<td><b>$lblrut</b></td>
						<td>$rut</td>
					</tr>
					<tr>
						<td style='vertical-align:top;'><b>$lbldireccion</b></td>
						<td>$direccion</td>
						<td><b>$lblcomuna</b></td>
						<td>$comuna</td>
					</tr>
					<tr>
						<td><b>$lblgiro</b></td>
						<td>$giro</td>
						<td><b>$lbltelefono</b></td>
						<td>$telefono</td>
					</tr>
					
				</table>

				<table style='vertical-align:top;width:90%;border: 1px solid black;' cellpadding=2 cellspacing=0>
					<tr>
						<td style='text-align:left; width:080px;background-color:#efefef;border-right: 1px solid black; '>ID Carga</td>
						<td style='text-align:left; width:060px;background-color:#efefef;border-right: 1px solid black; '>Guia</td>
						<td style='text-align:left; width:250px;background-color:#efefef;border-right: 1px solid black; '>Detalle</td>
						<td style='text-align:left; width:100px;background-color:#efefef;border-right: 1px solid black; '>Moneda</td>
						<td style='text-align:left; width:100px;background-color:#efefef;border-right: 1px solid black; '>P.Unitario</td>
						<td style='text-align:left; width:100px;background-color:#efefef;border-right: 1px solid black; '>Total</td>
					</tr>
					<tr>
						<td colspan=1 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$idcarga</td>
						<td colspan=1 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$guia_numero</td>
						<td colspan=1 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$detalle</td>
						<td colspan=1 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>PESO</td>
						<td colspan=1 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$unitario</td>
						<td colspan=1 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$unitario</td>
					</tr>
					<tr>
						<td colspan=3 style='vertical-align:top;border-left: 0px solid black;'>Observaciones</td>
						<td colspan=1>Neto</td>
						<td colspan=2 style='text-align:right;'>".number_format($subtotal)."</td>
					</tr>
					<tr>
						<td colspan=3 style='vertical-align:top;border-left: 0px solid black;'>$observaciones</td>
						<td colspan=1>Descuento</td>
						<td colspan=2 style='text-align:right;'>".number_format($descuento)."</td>
					</tr>
					<tr>
						<td colspan=3>&nbsp;</td>
						<td colspan=1>Total</td>
						<td colspan=2 style='text-align:right;'>".number_format($total)."</td>
					</tr>
					<tr>
						<td colspan=3>&nbsp;</td>
						<td colspan=1>IVA</td>
						<td colspan=2 style='text-align:right;'>".number_format($iva)."</td>
					</tr>
					<tr>
						<td colspan=3>&nbsp;</td>
						<td colspan=1><b>Total Factura</b></td>
						<td colspan=2 style='text-align:right;'>".number_format($total)."</td>
					</tr>
				</table>
			</body>
		</html>";
		
	//echo $html;

	$dompdf = new DOMPDF();
	$dompdf->load_html($html);
	$dompdf->render();
	$dompdf->stream("factura_$id.pdf");
?>