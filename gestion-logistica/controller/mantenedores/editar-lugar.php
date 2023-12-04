<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	try{
		$oper = $_POST['oper'];
		$id = $_POST['id'];
		$LUG_VCIUDAD = $_POST['LUG_VCIUDAD'];
		$LUG_VDIRECCION = $_POST['LUG_VDIRECCION'];
		$LUG_VNOMBRE = $_POST['LUG_VNOMBRE'];
		$LUG_VSIGLA = $_POST['LUG_VSIGLA'];
		$LUG_NCATEGORIA = $_POST['LUG_NCATEGORIA'];
		$LUG_NRETIRO = $_POST['LUG_NRETIRO'];
		$LUG_NCARGUIO = $_POST['LUG_NCARGUIO'];
		$LUG_NDESTINO = $_POST['LUG_NDESTINO'];
		$LUG_NCORR_PADRE = $_POST['LUG_NCORR_PADRE'];
		
		if ($oper == "edit"){
			$sqlText = "UPDATE tb_lugar SET LUG_VCIUDAD = '".$LUG_VCIUDAD."', LUG_VDIRECCION ='".$LUG_VDIRECCION."', LUG_VNOMBRE ='".$LUG_VNOMBRE."', LUG_NCORR_PADRE = ".$LUG_NCORR_PADRE.", LUG_VSIGLA = '".$LUG_VSIGLA."', LUG_NCATEGORIA = ".$LUG_NCATEGORIA.", LUG_NRETIRO = ".$LUG_NRETIRO.", LUG_NCARGUIO = ".$LUG_NCARGUIO.", LUG_NDESTINO = ".$LUG_NDESTINO." WHERE LUG_NCORR = ".$id; 
			/*$sqlText = "UPDATE tb_lugar SET LUG_VCIUDAD = '".$LUG_VCIUDAD."', LUG_VDIRECCION ='".$LUG_VDIRECCION."', LUG_VNOMBRE ='".$LUG_VNOMBRE."', LUG_VSIGLA = '".$LUG_VSIGLA."', LUG_NCATEGORIA = ".$LUG_NCATEGORIA.", LUG_NRETIRO = ".$LUG_NRETIRO.", LUG_NCARGUIO = ".$LUG_NCARGUIO.", LUG_NDESTINO = ".$LUG_NDESTINO." WHERE LUG_NCORR = ".$id; */
			$result1 = executeSQLCommand($sqlText);			

			$arr = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
			echo json_encode($arr); 
//			echo $sqlText;
		}else{
			if ($oper == "add"){
				$result2 = executeSQLCommand("SELECT MAX(LUG_NCORR)+1 AS value FROM tb_lugar");			 
				$row = mysql_fetch_array($result2,MYSQL_ASSOC); 
				$id = $row['value'];
				
				$sqlText2 = "INSERT INTO tb_lugar (LUG_NCORR, LUG_VCIUDAD, LUG_VDIRECCION, LUG_VNOMBRE, LUG_VSIGLA, LUG_NCATEGORIA, LUG_NRETIRO, LUG_NCARGUIO, LUG_NDESTINO) VALUES(";
				$sqlText2 = $sqlText2.$id.",'".$LUG_VCIUDAD."','".$LUG_VDIRECCION."','".$LUG_VNOMBRE."','".$LUG_VSIGLA."',".$LUG_NCATEGORIA.",".$LUG_NRETIRO.",".$LUG_NCARGUIO.",".$LUG_NDESTINO.")";
				$result2 = executeSQLCommand($sqlText2);		
				$arr2 = array ('success'=>true,'data'=>"Datos ingresados exitosamente");
				echo json_encode($arr2); 
			}else{
				$sqlText3 = "DELETE FROM tb_lugar WHERE LUG_NCORR = ".$id; 
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