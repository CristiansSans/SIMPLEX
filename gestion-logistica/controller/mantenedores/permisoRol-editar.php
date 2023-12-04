<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$COD_ROL = $_GET['codRol'];
		$FUNC_NCORR = $_POST['FUNC_NCORR'];
		$Activo = $_POST['Activo'];
		
		if ($oper == "edit"){
			/*$resultCantidad = executeSQLCommand("SELECT COUNT(*) AS value FROM tb_permiso WHERE rol_ncorr = ".$COD_ROL." AND func_ncorr = ". $FUNC_NCORR);			 
			$row = mysql_fetch_array($resultCantidad,MYSQL_ASSOC); 
			$count = $row['value'];			
				
			if ($count==0){
				$result2 = executeSQLCommand("SELECT MAX(PER_NCORR)+1 AS value FROM tb_permiso");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];

				$sqlText2 = "INSERT INTO tb_permiso (PER_NCORR, ROL_NCORR, FUNC_NCORR) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$COD_ROL.",".$FUNC_NCORR.")";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");				
				
			}else{
				$sqlTextDelete = "DELETE FROM tb_permiso WHERE rol_ncorr = ".$COD_ROL." AND func_ncorr = ". $FUNC_NCORR;
				$result2 = executeSQLCommand($sqlTextDelete);		
				$arr2 = array ('success'=>true,'data'=>"Datos eliminados exitosamente");				
			}*/	
		}
				
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
?>