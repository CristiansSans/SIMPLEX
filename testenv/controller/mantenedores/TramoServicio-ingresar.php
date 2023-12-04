<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper 			= $_POST['oper'];
		$codServicio 	= $_GET['codServicio'];
		$tss_ncorr 		= $_POST['tss_ncorr'];
		$tra_ncorr 		= $_POST['tra_ncorr'];
		$id				= $_POST['id'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tg_tramo_subtiposervicio SET tra_ncorr = ".$tra_ncorr." WHERE tss_ncorr =".$id;
			$result1 = executeSQLCommand($sqlText);
			
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);
			 			
			/*
			$sqlText = "UPDATE tg_hito SET HITO_KM = ".$TRA_KMS." WHERE TRA_NCORR =".$id." AND HITO_FINAL = 1";
			$result1 = executeSQLCommand($sqlText);
			
			$sqlText2 = "UPDATE tg_tramo SET LUG_NCORR_DESTINO = '".$LUG_NCORR_DESTINO."', LUG_NCORR_ORIGEN ='".$LUG_NCORR_ORIGEN."', TRA_KMS ='".$TRA_KMS."', TRA_TIEMPO = '".$TRA_TIEMPO."' WHERE TRA_NCORR = ".$id; 
			$result2 = executeSQLCommand($sqlText2);			
			//$rs 		= executeSQLCommand($queryparameter);	
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);*/  
		}else{
			if ($oper == "add"){
				
				$result2 = executeSQLCommand("SELECT IFNULL(MAX(tss_ncorr),0)+1 AS value FROM tg_tramo_subtiposervicio");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC);
				//$id = $row['value'];
				$idTramo = $row['value'];			
				
				$sqlText2 = "INSERT INTO tg_tramo_subtiposervicio (tss_ncorr, sts_ncorr, tra_ncorr) VALUES(";
				$sqlText2 = $sqlText2.$idTramo.",".$codServicio.",".$tra_ncorr.")";
								
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2);
			}else{
				$sqlText2 = "DELETE FROM tg_tramo_subtiposervicio WHERE tss_ncorr = ".$id; 
				$result3 = executeSQLCommand($sqlText2);		
				
				//$rs 		= executeSQLCommand($queryparameter);	
				$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr);  
			}
		}
				
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
    


?>