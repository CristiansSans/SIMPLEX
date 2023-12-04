<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$ROL_NCORR = $_POST['ROL_NCORR'];
		$ROL_VDESCRIPCION = $_POST['ROL_VDESCRIPCION'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tb_rolusuario SET ROL_VDESCRIPCION = '".$ROL_VDESCRIPCION."' WHERE ROL_NCORR = ".$id; 
			$result1 = executeSQLCommand($sqlText);				
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(ROL_NCORR)+1 AS value FROM tb_rolusuario");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tb_rolusuario (ROL_NCORR, ROL_VDESCRIPCION) VALUES(";
				$sqlText2 = $sqlText2.$id.",'".$ROL_VDESCRIPCION."')";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tb_rolusuario WHERE ROL_NCORR = ".$id; 
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