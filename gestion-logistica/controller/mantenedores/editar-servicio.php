<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		
		$id 				= $_POST['id'];
		$STS_VNOMBRE		= $_POST['sts_vnombre'];
		$TISE_NCORR 		= $_GET['codtipoServicio'];
		$LUG_NCORR_ORIGEN 	= $_POST['lug_ncorr_origen'];
		$LUG_NCORR_DESTINO 	= $_POST['lug_ncorr_destino'];
		$CLIE_VRUT 			= $_GET['rutCliente'];
		$STS_NMONTO 		= $_POST['sts_nmonto'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tb_subtiposervicio SET sts_vnombre = '".$STS_VNOMBRE."', lug_ncorr_origen = ".$LUG_NCORR_ORIGEN.", lug_ncorr_destino = ".$LUG_NCORR_DESTINO.", sts_nmonto = ".$STS_NMONTO." WHERE sts_ncorr = ".$id;
			//echo $sqlText; 
			$result1 = executeSQLCommand($sqlText);				
			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr);  
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT IFNULL(MAX(sts_ncorr),0)+1 AS value FROM tb_subtiposervicio");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tb_subtiposervicio (sts_ncorr, sts_vnombre, tise_ncorr,lug_ncorr_origen,lug_ncorr_destino,clie_vrut,sts_nmonto) VALUES(";
				$sqlText2 = $sqlText2.$id.",'".$STS_VNOMBRE."',".$TISE_NCORR.",".$LUG_NCORR_ORIGEN.",".$LUG_NCORR_DESTINO.",".$CLIE_VRUT.",".$STS_NMONTO.")";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tb_subtiposervicio WHERE sts_ncorr = ".$id; 
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