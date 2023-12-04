<?php
	require '../database-config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

  $registro = $valuesForm['car_ntemperatura'].
              $valuesForm['car_nventilacion'].
              $valuesForm['car_vadic_otros'].
              $valuesForm['car_vadic_obs'];
  
	if($registro!=""){
    $queryparameter  = 	'call prc_infoadicional_ingresar('.
  							$id.','.
  							"0".$valuesForm['car_ntemperatura'].','.
  							"0".$valuesForm['car_nventilacion'].','.
  							'"'.$valuesForm['car_vadic_otros'].'",'.
  							'"'.$valuesForm['car_vadic_obs'].'")';
    //echo $queryparameter;
  	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
  
  	mysql_close($connection);
	}
?>