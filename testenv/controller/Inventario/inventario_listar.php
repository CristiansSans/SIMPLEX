<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$codServicio  	 		= isset($_GET['codServicio'])  ? $_GET['codServicio']  :  0;

	$queryparameter = "call prc_inventario_listar()";

	$rs = executeSQLCommand(stripslashes($queryparameter));
	

	$i = 0;
	while ($row = mysql_fetch_array($rs, MYSQL_ASSOC)) {
		$textoDemurrage = "-";
		$textoGuia;
		//<img src="img/ico_add.png"/>
		if ($row[guia_ncorr]>0){
			$textoGuia = $row[guia_numero]." <img src='img/ico_edit.png' onclick='editarGuia(".$row[codServicio].", \"".$row[guia_dfecha]."\", ".$row[guia_ncorr].", ".$row[empguia].", ".$row[guia_numero].") '/>";
		}else{
			$textoGuia = "<img src='img/ico_add.png' onclick='agregarGuia(".$row[codServicio].")'/>";
		}
		
		if ($row[esca_ncorr]==5){	
			$texto = $row[clie_vnombre]." <img src='img/icoReturn.png' alt='Devolver contenedor' onclick='registrarDevolucion(".$row[car_ncorr].")'/>";			
			if ($row[demurrage]>0){
				$textoDemurrage = "<label class='textoAtraso'>".$row[demurrage]."</label> <img src='img/ico_Warning.png'/>";
			}else{
				$textoDemurrage = "<label class='textoAlDia'>".($row[demurrage]*-1)."</label>";
			}	
		}else{
			$texto = $row[clie_vnombre];
		}
		
		$responce -> rows[$i]['id'] 	= $row[car_ncorr];
		$responce -> rows[$i]['cell'] 	=   array(
												$row[car_ncorr],
												$row[ubicacion],
												$row[esca_ncorr]==3?"<img src='img/icoCamion.png' height='16' alt='retornar container'/> " .$row[esca_vdescripcion]:$row[esca_vdescripcion],  
												$texto,
												$row[cont_vnumcontenedor],
												$row[cont_npeso],
												$row[cont_vcontenido],
												$row[car_vobservaciones],
												$row[esca_ncorr]==4||$row[esca_ncorr]==5?$row[termino]:"-",
												$row[diasbodega],
												$row[diascustodia],
												$textoDemurrage,
												$textoGuia
												);
		$i++;
	}
	$responce -> page = 1;
	$responce -> total = 1;
	$responce -> records = $i;
	echo json_encode($responce);		
?>
