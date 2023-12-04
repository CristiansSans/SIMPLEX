<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$EMP_NCORR = $_GET['EMP_NCORR'];
		$CHOF_VRUT = $_POST['CHOF_VRUT'];
		$CHOF_VNOMBRE = $_POST['CHOF_VNOMBRE'];
		//$CAM_NCORR = $_POST['CAM_NCORR'];
		$CHOF_VFONO = $_POST['CHOF_VFONO'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tg_chofer SET CHOF_VRUT = '".$CHOF_VRUT."', CHOF_VNOMBRE = '".$CHOF_VNOMBRE."', CHOF_VFONO = '".$CHOF_VFONO."'  WHERE CHOF_NCORR = ".$id; 
			$result1 = executeSQLCommand($sqlText);				
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(CHOF_NCORR)+1 AS value FROM tg_chofer");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tg_chofer (CHOF_NCORR, EMP_NCORR, CHOF_VRUT,CHOF_VNOMBRE,CHOF_VFONO) VALUES(";
				$sqlText2 = $sqlText2.$id.",".$EMP_NCORR.",'".$CHOF_VRUT."','".$CHOF_VNOMBRE."','".$CHOF_VFONO."')";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tg_chofer WHERE CHOF_NCORR = ".$id; 
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