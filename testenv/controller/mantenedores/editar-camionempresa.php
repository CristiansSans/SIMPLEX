<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$EMP_NCORR = $_GET['EMP_NCORR'];
		$CAM_VPATENTE = $_POST['CAM_VPATENTE'];
		$CAM_VMARCA = $_POST['CAM_VMARCA'];
		$CAM_VMODELO = $_POST['CAM_VMODELO'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tg_camion SET EMP_NCORR = ".$EMP_NCORR.", CAM_VPATENTE ='".$CAM_VPATENTE."', CAM_VMARCA ='".$CAM_VMARCA."', CAM_VMODELO = '".$CAM_VMODELO."' WHERE CAM_NCORR = ".$id; 
			$result1 = executeSQLCommand($sqlText);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(CAM_NCORR)+1 AS value FROM tg_camion");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tg_camion (CAM_NCORR, EMP_NCORR, CAM_VPATENTE, CAM_VMARCA, CAM_VMODELO) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$EMP_NCORR.",'".$CAM_VPATENTE."','".$CAM_VMARCA."','".$CAM_VMODELO."')";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tg_camion WHERE CAM_NCORR = ".$id; 
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