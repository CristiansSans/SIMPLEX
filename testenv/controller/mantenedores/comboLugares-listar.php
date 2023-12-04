

<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$texto;
	$result = executeSQLCommand("SELECT LUG_NCORR, LUG_VNOMBRE FROM tb_lugar ORDER BY LUG_VNOMBRE ASC");
	
	$i = 0;
	$texto = "";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		if ($texto!=""){
			$texto = $texto.";";
		}
		
		$texto = $texto.$row[LUG_NCORR].":".$row[LUG_VNOMBRE];
	}


	//$arr = array('values'=>"2:STI;15:LO HERRERA;26:Pirque - Concha y ToroTNT;27:Lo Espejo - San Pedro");
	$arr = array('values'=>$texto);
	echo json_encode($arr);
?>