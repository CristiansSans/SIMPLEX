<?php
include_once '../../model/class.php';
include_once '../../model/config.php';

try {
	$oper = $_POST['oper'];
	$id = $_POST['id'];

	$sqlText3 = "DELETE FROM tg_empresatransporte WHERE EMP_NCORR = " . $id;
	$result3 = executeSQLCommand($sqlText3);
	$arr = array('success' => true, 'data' => "Datos eliminados exitosamente");
	echo json_encode($arr);	
} catch(exception $ex) {
	echo 'Exception :' . $e . getMessage();
}
?>