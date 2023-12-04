

<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	$texto;
	$query = "SELECT	STS.STS_NCORR, CONCAT(TISE.TISE_VDESCRIPCION,' - >',STS.STS_VNOMBRE) AS LUGAR
			  FROM	tb_tiposervicio TISE inner join tb_subtiposervicio STS
					ON TISE.TISE_NCORR = STS.TISE_NCORR
			  ORDER BY TISE.TISE_VDESCRIPCION ASC,  STS.STS_VNOMBRE ASC  ";
			  
	//$result = executeSQLCommand("SELECT LUG_NCORR, LUG_VNOMBRE FROM tb_lugar ORDER BY LUG_VNOMBRE ASC");
	$result = executeSQLCommand($query);
	
	$i = 0;
	$texto = "";
	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		if ($texto!=""){
			$texto = $texto.";";
		}
		
		$texto = $texto.$row[STS_NCORR].":".$row[LUGAR];
	}


	//$arr = array('values'=>"2:STI;15:LO HERRERA;26:Pirque - Concha y ToroTNT;27:Lo Espejo - San Pedro");
	$arr = array('values'=>$texto);
	echo json_encode($arr);
?>