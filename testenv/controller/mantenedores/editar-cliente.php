<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_GET['oper'];
		$id = $_GET['id'];
		$txtRut = $_GET['txtRut'];
		$txtNombre = $_GET['txtNombre'];
		$txtContactoLegal = $_GET['txtContactoLegal'];
		$txtDireccion = $_GET['txtDireccion'];
		$txtCiudad = $_GET['txtCiudad'];
		$txtComuna = $_GET['txtComuna'];
		$txtFono = $_GET['txtFono'];
		$txtGiro = $_GET['txtGiro'];
		$txtDiasLibres = $_GET['txtDiasLibres'];
		$txtRazonSocial = $_GET['txtRazonSocial'];
		$txtActividad = $_GET['txtActividad'];
		
		if ($oper == "edit"){
			if ($txtDiasLibres==""){
				$txtDiasLibres = "NULL";
			}
				
			$result2 = executeSQLCommand("SELECT count(*) AS value FROM tb_cliente WHERE CLIE_VRUT = ".$txtRut);			 
			$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
			$registros = $row['value'];
			
			if ($registros>0){			
				$sqlText = "UPDATE tb_cliente SET CLIE_VNOMBRE = '".$txtNombre."', CLIE_VCONTACTOLEGAL = '".$txtContactoLegal."'";
				$sqlText = $sqlText.", CLIE_VDIRECCION='".$txtDireccion."', CLIE_VCOMUNA = '".$txtComuna."', CLIE_VGIRO = '".$txtGiro."', CLIE_VACTIVIDAD = '".$txtActividad."', CLIE_VFONO = '".$txtFono."', CLIE_NDIASLIBRES = ".$txtDiasLibres.", CLIE_VRAZONSOCIAL = '".$txtRazonSocial."'" ;
				$sqlText = $sqlText." WHERE CLIE_VRUT = ".$txtRut; 
				$result1 = executeSQLCommand($sqlText);				
				$arr = array ('success'=>true,'data'=>"Datos actualizados exitosamente");
				echo json_encode($arr);
			}else{
				$sqlText2 = "INSERT INTO tb_cliente (CLIE_VRUT, CLIE_VNOMBRE, CLIE_VCONTACTOLEGAL,CLIE_VDIRECCION,CLIE_VCOMUNA,CLIE_VFONO, CLIE_VGIRO, CLIE_NDIASLIBRES, CLIE_VRAZONSOCIAL, CLIE_VACTIVIDAD) VALUES(";
				$sqlText2 = $sqlText2.$id."".$txtRut.",'".$txtNombre."','".$txtContactoLegal."','".$txtDireccion."','".$txtComuna."','".$txtFono."','".$txtGiro."',".$txtDiasLibres.",'".$txtRazonSocial."','".$txtActividad."')";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2);		
			}  
		}else{			
			$sqlText3 = "DELETE FROM tb_cliente WHERE CLIE_VRUT = '".$txtRut."'";
			$result3 = executeSQLCommand($sqlText3);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos eliminados exitosamente");
			echo json_encode($arr);  
		}
				
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
?>