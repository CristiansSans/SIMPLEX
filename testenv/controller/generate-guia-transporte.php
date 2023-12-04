<?php 
	include_once '../model/class.php';
	include_once '../model/config.php';
	
	require_once("../../libs/dompdf/dompdf_config.inc.php");	

	$id  		= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;

	$queryparameter = "call prc_encabezadoguiadespacho_obtener ($id)";
	$rs 		= executeSQLCommand(stripslashes($queryparameter));

	$glosa		= '';
	while($obj = mysql_fetch_object($rs)) {
		$fecha			= $obj->fecha;
		$cliente		= $obj->clievnombre;
		$rut			= $obj->clievrut;
		$direccion		= $obj->direccion;
		$comuna			= $obj->comuna;
		$giro			= $obj->giro;
		$telefono		= $obj->telefono;
		$preciounitario	= $obj->preciounitario;
		$preciototal	= $obj->preciototal;
		$guia_numero	= $obj->guianumero;
		$tipoguia		= $obj->tipoguia;	//1=SII

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
									<td style='height:30px;'>$guia_numero</td>
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
									<td style='height:20px;'>GUIA DE DESPACHO</td>
								</tr>
								<tr>
									<td style='height:30px;'>$guia_numero</td>
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
		
		$glosa		= $glosa . ($glosa=='' ? '' : '<br>') . $obj->glosa;
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
					<tr style='height:30px;'>
						<td colspan=4>&nbsp;</td>
					</tr>

					<tr>
						<td style='width:400px;background-color:#efefef;'>DETALLE</td>
						<td style='width:100px;background-color:#efefef;'>&nbsp;</td>
						<td style='width:100px;background-color:#efefef;'>P.UNITARIO</td>
						<td style='width:100px;background-color:#efefef;'>TOTAL</td>
					</tr>
					<tr>
						<td colspan=2 style='vertical-align:top; height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$glosa</td>
						<td style='vertical-align:top; text-align:right; border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>$preciounitario</td>
						<td style='vertical-align:top; text-align:right; border-top: 1px solid black;border-bottom: 1px solid black;'>$preciototal</td>
					</tr>
					<tr style='height:30px;'>
						<td colspan=2 style='border-right: 1px solid black;border-bottom: 2px solid black;'>Solo traslado, no constituye venta</td>
						<td colspan=2 style='border-bottom: 2px solid black;'>&nbsp;</td>
					</tr>
					
					<tr>
						<td colspan=2 style='height:30px;border-bottom: 1px solid black;'>Recibido por:</td>
						<td colspan=2 style='height:30px;vertical-align:top;border-left: 1px solid black;' rowspan=3>Firma</td>
					</tr>
					<tr>
						<td colspan=2 style='height:30px;border-bottom: 1px solid black;'>Rut:</td>
					</tr>
					<tr>
						<td colspan=2 style='height:30px;'>Fecha y hora:</td>
					</tr>
				</table>
			</body>
		</html>";
		
//	echo $html;
		

	$dompdf = new DOMPDF();
	$dompdf->load_html($html);
	$dompdf->render();
	$dompdf->stream("guia_$id.pdf");
?>