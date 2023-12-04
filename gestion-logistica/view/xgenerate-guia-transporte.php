<?php 
	require_once("../../libs/dompdf/dompdf_config.inc.php");
	
	$html	="<html>
			<body style='font-size:16px;'>
				<table style='vertical-align:top;align:center;width:85%;'>
					<tr>
						<td><img src='../images/logo-241x181.jpg'></td>
						<td width=200>SIMPLEX LOGISTICA</td>
						<td>
							<table style='height:100px;text-align:center;font-size:16px;width:200px;border: 3px solid red;'>
								<tr>
									<td style='height:20px;'>RUT 99.999.999-9</td>
								</tr>
								<tr>
									<td style='height:20px;'>GUIA DE DESPACHO</td>
								</tr>
								<tr>
									<td style='height:30px;'>9999999999</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
	
				<table style='vertical-align:center;width:90%;'>
					<tr>
						<td width='15%'>Fecha</td>
						<td width='50%'>dd/mm/yyyy</td>
						<td width='10%'>&nbsp;</td>
						<td width='25%'>&nbsp;</td>
					</tr>
					<tr>
						<td>Señores</td>
						<td>Falabella Comercial S.A.</td>
						<td>Rut</td>
						<td>67.947.095-3</td>
					</tr>
					<tr>
						<td>Direcciòn</td>
						<td>xxxxx</td>
						<td>Comuna</td>
						<td>xxxxx</td>
					</tr>
					<tr>
						<td>Giro</td>
						<td>xxxxx</td>
						<td>Telefono</td>
						<td>xxxxx</td>
					</tr>
					
				</table>

				<table style='vertical-align:top;width:90%;border: 1px solid black;' cellpadding=2 cellspacing=0>
					<tr>
						<td style='width:400px;background-color:#efefef;'>DETALLE</td>
						<td style='width:100px;background-color:#efefef;'>&nbsp;</td>
						<td style='width:100px;background-color:#efefef;'>P.UNITARIO</td>
						<td style='width:100px;background-color:#efefef;'>TOTAL</td>
					</tr>
					<tr>
						<td colspan=2 style='height:400px;border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>&nbsp;</td>
						<td style='border-right: 1px solid black; border-top: 1px solid black;border-bottom: 1px solid black;'>&nbsp;</td>
						<td style='border-top: 1px solid black;border-bottom: 1px solid black;'>&nbsp;</td>
					</tr>
					<tr style='height:30px;'>
						<td colspan=3 style='border-right: 1px solid black;border-bottom: 2px solid black;'>Solo traslado, no constituye venta</td>
						<td style='border-bottom: 2px solid black;'>&nbsp;</td>
					</tr>
					
					<tr>
						<td style='height:30px;border-bottom: 1px solid black;'>Recibido por:</td>
						<td style='height:30px;vertical-align:top;border-left: 1px solid black;' rowspan=3>Firma</td>
					</tr>
					<tr>
						<td style='height:30px;border-bottom: 1px solid black;'>Rut:</td>
					</tr>
					<tr>
						<td style='height:30px;'>Fecha y hora:</td>
					</tr>
				</table>
			</body>
		</html>";

	$dompdf = new DOMPDF();
	$dompdf->load_html($html);
	$dompdf->render();
	$dompdf->stream("sample.pdf");
?>