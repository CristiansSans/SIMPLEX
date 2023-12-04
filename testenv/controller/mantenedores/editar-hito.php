<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$HITO_FINAL = $_POST['HITO_FINAL'];
		$HITO_INICIAL = $_POST['HITO_INICIAL'];
		$HITO_KM = $_POST['HITO_KM'];
		$HITO_TIEMPOVIAJE = $_POST['HITO_TIEMPOVIAJE'];
		$HITO_VNOMBRE = $_POST['HITO_VNOMBRE'];
		$TRA_NCORR = $_GET['TRA_NCORR'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tg_hito SET HITO_VNOMBRE = '".$HITO_VNOMBRE."', HITO_FINAL =".$HITO_FINAL.", HITO_INCIAL =".$HITO_INICIAL.", HITO_KM = ".$HITO_KM.", HITO_TIEMPOVIAJE =".$HITO_TIEMPOVIAJE." WHERE HITO_NCORR = ".$id; 
			$result1 = executeSQLCommand($sqlText);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(HITO_NCORR)+1 AS value FROM tg_hito");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tg_hito (HITO_NCORR, TRA_NCORR, HITO_VNOMBRE, HITO_INCIAL, HITO_FINAL, HITO_KM,HITO_TIEMPOVIAJE) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$TRA_NCORR.",'".$HITO_VNOMBRE."',".$HITO_INICIAL.",".$HITO_FINAL.",".$HITO_KM.",".$HITO_TIEMPOVIAJE.")";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tg_hito WHERE HITO_NCORR = ".$id; 
				$result3 = executeSQLCommand($sqlText3);			
				//$rs 		= executeSQLCommand($queryparameter);	
				$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr);  
			}
		}
				
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
    


?>