

<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$texto;
	$result = executeSQLCommand("SELECT tra_ncorr, nombre FROM vw_tramo ORDER BY nombre ASC");
	
	$i = 0;
	$texto = "";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		if ($texto!=""){
			$texto = $texto.";";
		}
		
		$texto = $texto.$row[tra_ncorr].":".$row[nombre];
	}


	//$arr = array('values'=>"2:STI;15:LO HERRERA;26:Pirque - Concha y ToroTNT;27:Lo Espejo - San Pedro");
	$arr = array('values'=>$texto);
	echo json_encode($arr);
?>