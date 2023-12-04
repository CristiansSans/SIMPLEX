<?php
include_once '../../model/class.php';
include_once '../../model/config.php';

try {
	$oper = $_GET['oper'];
	$id = $_GET['CodEmpresa'];
	$COD_EMPRESA = $_GET['CodEmpresa'];
	$NOMBRE_EMPRESA = $_GET['NombreEmpresa'];
	$RUT_EMPRESA = $_GET['RutEmpresa'];
	$DIRECCION = $_GET['Direccion'];
	$GIRO = $_GET['Giro'];
	$ACTIVIDAD = $_GET['Actividad'];
	$CONTACTO = $_GET['Contacto'];
	$FONO = $_GET['Fono'];
	$MAIL = $_GET['Mail'];
	$RAZONSOCIAL = $_GET['RazonSocial'];
	$GUIA	= $_GET['Guia'];
	if ($oper == "edit") {
		$sqlText = "UPDATE tg_empresatransporte SET EMP_VNOMBRE = '" . $NOMBRE_EMPRESA . "', EMP_VRUT ='" . $RUT_EMPRESA . "', EMP_VDIRECCION ='" . $DIRECCION . "', EMP_VGIRO = '" . $GIRO . "', EMP_VACTIVIDAD = '" . $ACTIVIDAD . "', EMP_VCONTACTO ='" . $CONTACTO . "', EMP_VFONO ='" . $FONO . "', EMP_VMAIL = '" . $MAIL . "', EMP_VRAZONSOCIAL ='".$RAZONSOCIAL."', EMP_NGENERAGUIA = ".$GUIA." WHERE EMP_NCORR = " . $id;

		$result1 = executeSQLCommand($sqlText);
		$arr = array('success' => true, 'data' => "Datos ingresados exitosamente");
		echo json_encode($arr);
	} else {
		if ($oper == "add") {
			$result2 = executeSQLCommand("SELECT MAX(EMP_NCORR)+1 AS value FROM tg_empresatransporte");
			$row = mysql_fetch_array($result2, MYSQL_ASSOC);
			$id = $row['value'];

			$sqlText2 = "INSERT INTO tg_empresatransporte (EMP_NCORR, EMP_VNOMBRE, EMP_VRUT, EMP_VDIRECCION, EMP_VGIRO, EMP_VCONTACTO,EMP_VFONO, EMP_VMAIL, EMP_VRAZONSOCIAL, EMP_VACTIVIDAD, EMP_NGENERAGUIA) VALUES(";
			$sqlText2 = $sqlText2 . $id . ",'" . $NOMBRE_EMPRESA . "','" . $RUT_EMPRESA . "','" . $DIRECCION . "','" . $GIRO . "','" . $CONTACTO . "','" . $FONO . "','" . $MAIL . "','".$RAZONSOCIAL."','" . $ACTIVIDAD."',".$GUIA.")";
			$result2 = executeSQLCommand($sqlText2);
			$arr2 = array('success' => true, 'data' => "Datos ingresados exitosamente");
			echo json_encode($arr2);
		}
	}
} catch(exception $ex) {
	echo 'Exception :' . $e . getMessage();
}
?>