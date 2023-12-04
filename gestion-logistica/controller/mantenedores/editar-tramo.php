<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$LUG_NCORR_DESTINO = $_POST['LUG_NCORR_DESTINO'];
		$LUG_NCORR_ORIGEN = $_POST['LUG_NCORR_ORIGEN'];
		$TRA_KMS = $_POST['TRA_KMS'];
		$TRA_TIEMPO = $_POST['TRA_TIEMPO'];
		
		if ($oper == "edit"){
			//INSERT INTO tg_hito (HITO_NCORR, TRA_NCORR, HITO_VNOMBRE, HITO_INCIAL, HITO_FINAL, HITO_KM,HITO_TIEMPOVIAJE) 
			$sqlText = "UPDATE tg_hito SET HITO_KM = ".$TRA_KMS." WHERE TRA_NCORR =".$id." AND HITO_FINAL = 1";
			$result1 = executeSQLCommand($sqlText);
			
			$sqlText2 = "UPDATE tg_tramo SET LUG_NCORR_DESTINO = '".$LUG_NCORR_DESTINO."', LUG_NCORR_ORIGEN ='".$LUG_NCORR_ORIGEN."', TRA_KMS ='".$TRA_KMS."', TRA_TIEMPO = '".$TRA_TIEMPO."' WHERE TRA_NCORR = ".$id; 
			$result2 = executeSQLCommand($sqlText2);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				
				$result2 = executeSQLCommand("SELECT IFNULL(MAX(TRA_NCORR),0)+1 AS value FROM tg_tramo");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC);
				//$id = $row['value'];
				$idTramo = $row['value'];			
				
				$sqlText2 = "INSERT INTO tg_tramo (TRA_NCORR, LUG_NCORR_ORIGEN, LUG_NCORR_DESTINO, TRA_KMS, TRA_TIEMPO) VALUES(";
				$sqlText2 = $sqlText2.$idTramo.",".$LUG_NCORR_ORIGEN.",".$LUG_NCORR_DESTINO.",".$TRA_KMS.",".$TRA_TIEMPO.")";
				
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
				
				$result2 = executeSQLCommand("SELECT IFNULL(MAX(HITO_NCORR),0)+1 AS value FROM tg_hito");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$idHito = $row['value'];				
				
				//Inserción hito inicial
				$sqlText2 = "INSERT INTO tg_hito (HITO_NCORR, TRA_NCORR, HITO_VNOMBRE, HITO_INCIAL, HITO_FINAL, HITO_KM,HITO_TIEMPOVIAJE) VALUES(";
				$sqlText2 = $sqlText2.$idHito.",".$idTramo.",'Inicio',1,0,0,0)";
				$result2 = executeSQLCommand($sqlText2);		
				
				//Inserción hito final
				$sqlText2 = "INSERT INTO tg_hito (HITO_NCORR, TRA_NCORR, HITO_VNOMBRE, HITO_INCIAL, HITO_FINAL, HITO_KM,HITO_TIEMPOVIAJE) VALUES(";
				$sqlText2 = $sqlText2.($idHito+1).",".$idTramo.",'Termino',0,1,".$TRA_KMS.",".$TRA_TIEMPO.")";
				$result2 = executeSQLCommand($sqlText2);					
				
			}else{
				$sqlText2 = "DELETE FROM tg_hito WHERE TRA_NCORR = ".$id; 
				$result3 = executeSQLCommand($sqlText2);		
				
				$sqlText3 = "DELETE FROM tg_tramo WHERE TRA_NCORR = ".$id; 
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