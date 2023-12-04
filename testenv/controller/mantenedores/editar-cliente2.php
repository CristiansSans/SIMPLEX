<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$txtRut = $_GET['txtRut'];
		$txtNombre = $_GET['txtNombre'];
		$txtContactoLegal = $_GET['txtContactoLegal'];
		$txtDireccion = $_GET['txtDireccion'];
		$txtCiudad = $_GET['txtCiudad'];
		$txtComuna = $_GET['txtComuna'];
		$txtFono = $_GET['txtFono'];
		
		if ($oper == "del"){
			$sqlText3 = "DELETE FROM tb_cliente WHERE CLIE_VRUT = ".$id;
			$result3 = executeSQLCommand($sqlText3);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos eliminados exitosamente");
			echo json_encode($arr);  			
		}			
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
?>