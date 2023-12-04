<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_GET['oper'];
		$codRol = $_GET['codRol'];
		$func = $_GET['func'];
		
		
		$result = executeSQLCommand("SELECT count(*) AS value FROM tb_permiso WHERE ROL_NCORR = ".$codRol." AND FUNC_NCORR = ".$func);			 
		$row = mysql_fetch_array($result,MYSQL_ASSOC); 
		$registros = $row['value'];
		
		$result = executeSQLCommand("SELECT MAX(PER_NCORR) + 1 AS value FROM tb_permiso");
		$row = mysql_fetch_array($result,MYSQL_ASSOC); 
		$proxRegistro = $row['value'];
				
		if ($oper=="del"){
			//eliminación de permisos
			if ($registros>0){
				$sqlText = "DELETE FROM tb_permiso WHERE ROL_NCORR = ".$codRol." AND FUNC_NCORR = ".$func;
				$result2 = executeSQLCommand($sqlText);			
			}
			$arr2 = array ('success'=>true,'data'=>"Permiso eliminado exitosamente");
			echo json_encode($arr2);	
		}else{
			//Asignación de permisos
			if ($registros>0){
				//$sqlText2 = "UPDATE tb_permiso SET PER_NPRIVILEGIO = 2 WHERE ROL_NCORR = ".$codRol." AND FUNC_NCORR = ".$func;
				//$result3 = executeSQLCommand($sqlText2);							
			}else{
				//$sqlText3 = "INSERT INTO tb_permiso (PER_NCORR, ROL_NCORR, FUNC_NCORR, PER_NPRIVILEGIO) VALUES (".$proxRegistro.",".$codRol.",".$func.",2)";
				$sqlText3 = "INSERT INTO tb_permiso (PER_NCORR, ROL_NCORR, FUNC_NCORR) VALUES (".$proxRegistro.",".$codRol.",".$func.")";
				$result4 = executeSQLCommand($sqlText3);											
			}
			$arr3 = array ('success'=>true,'data'=>"Permiso agregado exitosamente");
			echo json_encode($arr3);	
		}
	}catch(exception $ex){
		echo 'Exception :'. $e.getMessage();
	}
?>