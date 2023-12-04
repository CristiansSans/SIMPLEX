<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$codRol = $_GET['codRol'];
		$USUA_VLOGIN = $_POST['USUA_VLOGIN'];
		$USUA_VNOMBRE = $_POST['USUA_VNOMBRE'];
		$USUA_VAPELLIDO1 = $_POST['USUA_VAPELLIDO1'];
		$USUA_VAPELLIDO2 = $_POST['USUA_VAPELLIDO2'];
		$USUA_VMAIL = $_POST['USUA_VMAIL'];
		$USUA_VCLAVE = $_POST['USUA_VCLAVE'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tg_usuario SET USUA_VLOGIN = '".$USUA_VLOGIN."', USUA_VNOMBRE = '".$USUA_VNOMBRE."', USUA_VAPELLIDO1 = '".$USUA_VAPELLIDO1."', USUA_VAPELLIDO2 = '".$USUA_VAPELLIDO2."', USUA_VMAIL = '".$USUA_VMAIL."', USUA_VCLAVE = '".$USUA_VCLAVE."'  WHERE USUA_NCORR = ".$id; 
			$result1 = executeSQLCommand($sqlText);				
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(USUA_NCORR)+1 AS value FROM tg_usuario");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tg_usuario (USUA_NCORR, ROL_NCORR, USUA_VLOGIN,USUA_VNOMBRE,USUA_VAPELLIDO1,USUA_VAPELLIDO2,USUA_VMAIL,USUA_VCLAVE) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$codRol.",'".$USUA_VLOGIN."','".$USUA_VNOMBRE."','".$USUA_VAPELLIDO1."','".$USUA_VAPELLIDO2."','".$USUA_VMAIL."','".$USUA_VCLAVE."')";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tg_usuario WHERE USUA_NCORR = ".$id; 
				$result3 = executeSQLCommand($sqlText3);			
				//$rs 		= executeSQLCommand($queryparameter);	
				$arr = array ('success'=>true,'data'=>"Datos eliminados exitosamente");
				echo json_encode($arr);  
			}
		}
				
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
    


?>