<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	
	$codServicio = isset($_GET['codServicio']) ? $_GET['codServicio'] : 0;
	
	$queryparameter = "call prc_hitosingresados_listar ($codServicio)";
	
	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$i = 0;
	while ($row = mysql_fetch_array($rs, MYSQL_ASSOC)) {
		/*$hora = explode(':', $row[horaprogramada]);
		$auxHora;
		if ($hora[0] >= 24) {
			if (strlen($hora[0] - 24) == 1) {
				$auxHora = "0" . ($hora[0] - 24) . ":" . $hora[1] . ":" . $hora[2];
			} else {
				$auxHora = ($hora[0] - 24) . ":" . $hora[1] . ":" . $hora[2];
			}
		} else {
			$auxHora = $row[horaprogramada];
		}*/
		$responce -> rows[$i]['id'] = $row[numhito];
		//$responce -> rows[$i]['cell'] = array($row[numhito], ($i + 1), $row[nombrehito], $row[km], $auxHora,$row[horareal]);
		$responce -> rows[$i]['cell'] = array($row[numhito], ($i + 1), $row[nombrehito], $row[km], $row[horaprogramada],$row[horareal]);
		$i++;
	}
	$responce -> page = $page;
	$responce -> total = $total_pages;
	$responce -> records = $count;
	echo json_encode($responce);
?>
