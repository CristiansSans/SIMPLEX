<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$valuesForm['clie_vrutsubcliente']=$valuesForm['clie_vrutsubcliente']==''?$valuesForm['clie_vrutsubcliente']='null':$valuesForm['clie_vrutsubcliente'];
	$valuesForm['lug_ncorr_origen']=$valuesForm['lug_ncorr_origen']==''?$valuesForm['lug_ncorr_origen']='null':$valuesForm['lug_ncorr_origen'];
	$valuesForm['lug_ncorr_puntocarguio']=$valuesForm['lug_ncorr_puntocarguio']==''?$valuesForm['lug_ncorr_puntocarguio']='null':$valuesForm['lug_ncorr_puntocarguio'];
	$valuesForm['lug_ncorr_destino']=$valuesForm['lug_ncorr_destino']==''?$valuesForm['lug_ncorr_destino']='null':$valuesForm['lug_ncorr_destino'];

	$queryparameter  = 	'call prc_ordenservicio_ingresar2('.$id.','.$valuesForm['clie_vrut'].','.$valuesForm['clie_vrutsubcliente'].','.$valuesForm['usua_ncorr'].',"'.$valuesForm['ose_dfechaservicio'].'","'.$valuesForm['ose_vnombrenave'].'",'.$valuesForm['lug_ncorr_origen'].','.$valuesForm['tise_ncorr'].','.$valuesForm['sts_ncorr'].','.$valuesForm['lug_ncorr_puntocarguio'].',"'.$valuesForm['ose_vobservaciones'].'",'.$valuesForm['lug_ncorr_destino'].')';	
	$rs = executeSQLCommand(stripslashes($queryparameter));
	
	$arr = array();
	while($obj = mysql_fetch_object($rs)) {
	    $arr[] = $obj;
	}
	
	echo '{"total":'.count($arr).'},{"success":true,"data":'.json_encode($arr).'}';
?>