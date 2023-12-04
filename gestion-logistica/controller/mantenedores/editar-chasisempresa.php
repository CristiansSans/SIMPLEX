<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$EMP_NCORR = $_GET['EMP_NCORR'];
		$CHA_VPATENTE = $_POST['CHA_VPATENTE'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tg_chasis SET CHA_VPATENTE = '".$CHA_VPATENTE."' WHERE CHA_NCORR = ".$id; 
			$result1 = executeSQLCommand($sqlText);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(CHA_NCORR)+1 AS value FROM tg_chasis");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tg_chasis (CHA_NCORR, EMP_NCORR, CHA_VPATENTE) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$EMP_NCORR.",'".$CHA_VPATENTE."')";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tg_chasis WHERE CHA_NCORR = ".$id; 
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