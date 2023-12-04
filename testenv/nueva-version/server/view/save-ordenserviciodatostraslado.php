<?php
	require '../database-config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_infotraslado_ingresar2('.
							$id.','.
							'"'.$valuesForm['car_dfecharetiro'].'",'.
							'"'.$valuesForm['car_dfechapresentacion'].'",'.
							'"'.$valuesForm['car_vcontactoentrega'].'")';

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
?>