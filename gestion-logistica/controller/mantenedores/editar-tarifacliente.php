<?php
include_once '../../model/class.php';
include_once '../../model/config.php';

try {
	$oper = $_POST['oper'];
	$id = $_POST['id'];
	$CLIE_VRUT = $_GET['CLIE_VRUT'];
	$TASI_NCORR = $_POST['TASI_NCORR'];
	$TISE_NCORR = $_POST['TISE_NCORR'];
	$STS_NCORR = $_POST['STS_NCORR'];
	$LUG_NCORR_ORIGEN = $_POST['LUG_NCORR_ORIGEN'];
	$LUG_NCORR_DESTINO = $_POST['LUG_NCORR_DESTINO'];
	$TASI_NMONTO = $_POST['TASI_NMONTO'];
	$TRA_NCORR = $_POST['TRA_NCORR'];

	if ($oper == "edit") {
		$sqlText = "UPDATE tg_tarifaservicio SET STS_NCORR = " . $STS_NCORR . ", TASI_NMONTO = " . $TASI_NMONTO . " WHERE TASI_NCORR = " . $id;
		mysql_query("SET NAMES 'utf8'");
		$result1 = executeSQLCommand($sqlText);
		$arr = array('success' => true, 'data' => "Datos ingresados exitosamente");
		echo json_encode($arr);
	} else {
		if ($oper == "add") {
			$result2 = executeSQLCommand("SELECT MAX(TASI_NCORR)+1 AS value FROM tg_tarifaservicio");
			$row = mysql_fetch_array($result2, MYSQL_ASSOC);
			$id = $row['value'];

			$sqlText2 = "INSERT INTO tg_tarifaservicio (TASI_NCORR, CLIE_VRUT, STS_NCORR,TASI_NMONTO) VALUES(";
			$sqlText2 = $sqlText2 . $id . ",'" . $CLIE_VRUT . "'," . $STS_NCORR . "," . $TASI_NMONTO . ")";

			$result2 = executeSQLCommand($sqlText2);
			$arr2 = array('success' => true, 'data' => "Datos ingresados exitosamente");
			echo json_encode($arr2);
		} else {
			$sqlText3 = "DELETE FROM tg_tarifaservicio WHERE TASI_NCORR = " . $id;
			$result3 = executeSQLCommand($sqlText3);
			$arr = array('success' => true, 'data' => "Datos eliminados exitosamente");
			echo json_encode($arr);
		}
	}

} catch(exception $ex) {
	echo 'Exception :' . $e . getMessage();
}
?>