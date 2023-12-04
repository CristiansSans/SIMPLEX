<?php
	require '../database-config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$valuesForm['clie_vrutsubcliente']=$valuesForm['clie_vrutsubcliente']==''?$valuesForm['clie_vrutsubcliente']='null':$valuesForm['clie_vrutsubcliente'];
	$valuesForm['lug_ncorrorigen']=$valuesForm['lug_ncorrorigen']==''?$valuesForm['lug_ncorrorigen']='null':$valuesForm['lug_ncorrorigen'];
	$valuesForm['lug_ncorr_puntocarguio']=$valuesForm['lug_ncorr_puntocarguio']==''?$valuesForm['lug_ncorr_puntocarguio']='null':$valuesForm['lug_ncorr_puntocarguio'];
	$valuesForm['lug_ncorrdestino']=$valuesForm['lug_ncorrdestino']==''?$valuesForm['lug_ncorrdestino']='null':$valuesForm['lug_ncorrdestino'];

	$queryparameter  = 	'call prc_ordenservicio_ingresar2('.$id.','.$valuesForm['clie_vrut'].','.$valuesForm['clie_vrutsubcliente'].','.$valuesForm['usua_ncorr'].',"'.$valuesForm['ose_dfechaservicio'].'","'.$valuesForm['ose_vnombrenave'].'",'.$valuesForm['lug_ncorrorigen'].','.$valuesForm['tise_ncorr'].','.$valuesForm['sts_ncorr'].','.$valuesForm['lug_ncorr_puntocarguio'].',"'.$valuesForm['ose_vobservaciones'].'",'.$valuesForm['lug_ncorrdestino'].')';	
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