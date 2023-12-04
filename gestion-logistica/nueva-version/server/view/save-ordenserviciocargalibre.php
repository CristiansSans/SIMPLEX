<?php
	require '../database-config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	
	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_cargalibre_ingresar('.
							$id.','.
							$valuesForm['carlibre_um'].','.
							$valuesForm['carlibre_cantidad'].')';

              //echo $queryparameter;
	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		

	mysql_close($connection);

?>