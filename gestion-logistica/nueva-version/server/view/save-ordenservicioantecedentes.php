<?php
	require '../database-config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$sub_id  	= isset($_REQUEST['sub_id'])  ? $_REQUEST['sub_id']  :  0;
//	$esca_ncorr = isset($_REQUEST['esca_ncorr'])  ? $_REQUEST['esca_ncorr']  :  0;
	
	$fieldsForm 	= isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_detalleorden_ingresar2('.
							$id.','.
							$sub_id.','.
							//$esca_ncorr.','.
							$valuesForm['esca_ncorr'].','.
							$valuesForm['tica_ncorr'].',"'.
							$valuesForm['car_nbooking'].'","'.
							$valuesForm['car_voperacion'].'","'.
							$valuesForm['car_vobservaciones'].'",'.
							'@lnIdCarga,'.
							'@OutStatus)';

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
	
  $arr = array();
	while($obj = mysql_fetch_object($result)) {
		$arr[] = $obj;
	}
	
	echo '{ metaData: { "root": "data"}';
	//echo ',"total":'.$total->total;
	echo ',"success":true, "data":' . json_encode($arr) . '}';
	mysql_close($connection);

?>