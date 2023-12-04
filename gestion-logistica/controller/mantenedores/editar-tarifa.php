<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper 		= $_POST['oper'];
		$id 		= $_POST['id'];
		$TAR_NCORR	= $_POST['TAR_NCORR'];
		$EMP_NCORR 	= $_GET['codEmpresa'];
		$TAR_NMONTO = $_POST['TAR_NMONTO'];
		$TRA_NCORR 	= $_POST['TRA_NCORR'];
				
		if ($oper == "edit"){
			//$sqlText = "UPDATE tg_tarifa SET EMP_NCORR = '".$EMP_NCORR."', TISE_NCORR = ".$TISE_NCORR.", STS_NCORR = ".$STS_NCORR.", LUG_NCORR_ORIGEN = ".$LUG_NCORR_ORIGEN.", LUG_NCORR_DESTINO = ".$LUG_NCORR_DESTINO.",TAR_NMONTO = ".$TAR_NMONTO." WHERE TAR_NCORR = ".$id; 
			$sqlText = "UPDATE tg_tarifa SET EMP_NCORR = '".$EMP_NCORR."', TRA_NCORR = ".TRA_NCORR.",TAR_NMONTO = ".$TAR_NMONTO." WHERE TAR_NCORR = ".$id;
			$result1 = executeSQLCommand($sqlText);				
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT IFNULL(MAX(TAR_NCORR),0)+1 AS value FROM tg_tarifa");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				//$sqlText2 = "INSERT INTO tg_tarifa (TAR_NCORR, EMP_NCORR, TISE_NCORR,STS_NCORR,LUG_NCORR_ORIGEN,LUG_NCORR_DESTINO,TAR_NMONTO) VALUES(";
				//$sqlText2 = $sqlText2.$id.",".$EMP_NCORR.",".$TISE_NCORR.",".$STS_NCORR.",".$LUG_NCORR_ORIGEN.",".$LUG_NCORR_DESTINO.",".$TAR_NMONTO.")";
				
				$sqlText2 = "INSERT INTO tg_tarifa (TAR_NCORR, TRA_NCORR, EMP_NCORR, TAR_NMONTO) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$TRA_NCORR.",".$EMP_NCORR.",".$TAR_NMONTO.")";
				
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tg_tarifa WHERE TAR_NCORR = ".$id;
				//echo $sqlText3;
				 
				$result3 = executeSQLCommand($sqlText3);							
				$arr = array ('success'=>true,'data'=>"Datos eliminados exitosamente");
				echo json_encode($arr);  
			}
		}
				
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
    


?>