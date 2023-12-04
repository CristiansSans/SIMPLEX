<?php
include_once '../../model/class.php';
include_once '../../model/config.php';

$codorden = isset($_GET['codorden']) ? $_GET['codorden'] : 0;
$codcliente = isset($_GET['codcliente']) ? $_GET['codcliente'] : 0;
$codtransportista = isset($_GET['codtransportista']) ? $_GET['codtransportista'] : 0;
$inicioperiodo = isset($_GET['inicioperiodo']) ? $_GET['inicioperiodo'] : '';
$terminoperiodo = isset($_GET['terminoperiodo']) ? $_GET['terminoperiodo'] : '';
$barraAvance;
$queryparameter = "call prc_seguimientotransporte_listar ($codorden, $codcliente, $codtransportista, '$inicioperiodo', '$terminoperiodo')";

$rs = executeSQLCommand(stripslashes($queryparameter));

$i = 0;
while ($row = mysql_fetch_array($rs, MYSQL_ASSOC)) {
	if ($row[atrasoinicio] == null) {
		//$texto = $row[uavance];
		$barraAvance;
		$texto = "-";
	} else {
		$texto = $row[uavance];
		if ($row[avance]==0){		
			if ($row[atrasoinicio] > 0){ //$row[atrasoinicio]
				$barraAvance = '<img src="img/tracking_20_80_NOK.png" height="16" alt="Servicio atrasado"/><a class="styleAtrasoInicio">('.$row[atrasoinicio].' min)</a>' ;	
			}else{
				$barraAvance = '<img src="img/tracking_20_80_OK.png" height="16" alt="Servicio atrasado"/><a class="styleAtrasoInicio">' ;
			}
		}else{
			//$row[atrasoinicio] == null ? '<img src="img/ico_Warning.png" height="16" alt="Servicio atrasado"/>' : $barraAvance
			$maxKM 		= $row[kmmax]==null?1:$row[kmmax];
			$avanceKM 	= $row[movimiento]==null?0:$row[movimiento];
			$avance 	= $avanceKM / $maxKM;			
			//$avance = $row[avance]/$row[totaltiempo];
			if ($row[atrasoavance]>0){
				if ($avance<=0.1){
					$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_10_90_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
				}else{
					if ($avance <=0.2){
						$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_20_80_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;						
					}else{
						if ($avance <= 0.3){
							$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_30_70_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;	
						}else{
							if ($avance <=0.4){
								$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_40_60_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
							}else{
								if ($avance <=0.5){
									$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_50_50_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
								}else{
									if ($avance <=0.6){
										$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_60_40_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
									}else{
										if ($avance <= 0.7){
											$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_70_30_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
										}else{
											if ($avance <= 0.8){
												$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_80_20_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
											}else{
												if ($maxKM == $avanceKM){
													$barraAvance = '<div class="styleAtrasoInicio"><img src="img/avance/tracking_100_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
												}else{
													$barraAvance = '<div clss="styleAtrasoInicio"><img src="img/avance/tracking_90_10_NOK.png" height="16" alt="Servicio atrasado"/>('.$row[atrasoavance].' min)</div>' ;
												}
											}
										}
									}
								}
							}
						}
					}
				}	
			}else{
				if ($avance<=0.1){
					$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_10_90_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
				}else{
					if ($avance <=0.2){
						$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_20_80_OK.png" height="16" alt="Servicio atrasado"/></div>' ;						
					}else{
						if ($avance <= 0.3){
							$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_30_70_OK.png" height="16" alt="Servicio atrasado"/></div>' ;	
						}else{
							if ($avance <=0.4){
								$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_40_60_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
							}else{
								if ($avance <=0.5){
									$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_50_50_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
								}else{
									if ($avance <=0.6){
										$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_60_40_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
									}else{
										if ($avance <= 0.7){
											$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_70_30_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
										}else{
											if ($avance <= 0.8){
												$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_80_20_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
											}else{
												if ($maxKM == $avanceKM){
													$barraAvance = '<div class="styleAdelanto"><img src="img/avance/tracking_100_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
												}else{
													$barraAvance = '<div clss="styleAdelanto"><img src="img/avance/tracking_90_10_OK.png" height="16" alt="Servicio atrasado"/></div>' ;
												}
											}
										}
									}
								}
							}
						}
					}
				}				
			}


		}
		
	}

	$responce -> rows[$i]['id'] = $row[serv_ncorr];
	$responce -> rows[$i]['cell'] = array($row[serv_ncorr],
	$texto, 
	$row[atrasoinicio] == null ? '<img src="img/ico_Warning.png" height="16" alt="Servicio atrasado"/>' : $barraAvance,
	$row[nombreempresa], 
	$row[tiposervicio], 
	$row[camion], 
	$row[chofer], 
	$row[tica_vdescripcion], 
	$row[numcontenedor], 
	$row[fono], 
	$row[origen], 
	$row[destino], 
	$row[inicioplan], 
	$row[inicioreal], 
	$row[terminoplan], 
	$row[terminoreal], 
	$row[total],
	$row[atrasoinicio],
	$row[atrasoavance],
	$row[avance] == null ? '-':$row[avance],
	$row[totaltiempo]);
	$i++;
}
$responce -> page = $page;
$responce -> total = $total_pages;
$responce -> records = $count;
echo json_encode($responce);
?>
