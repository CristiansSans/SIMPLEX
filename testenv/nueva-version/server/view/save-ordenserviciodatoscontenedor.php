<?php
	require '../database-config.php';

	$id  	 	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  0;
	$sub_id  	= isset($_REQUEST['sub_id'])  ? $_REQUEST['sub_id']  :  0;
	
	$fieldsForm = isset($_REQUEST['fieldsForm'])  ? $_REQUEST['fieldsForm']  :  '';
	$fieldsForm	= str_replace("\\","",$fieldsForm);
	$valuesForm	= json_decode($fieldsForm,true);

	$queryparameter  = 	'call prc_infocontenedor_ingresar2('.
							$id.','.
							'"'.$valuesForm['cont_vmarca'].'",'.
							'"'.$valuesForm['cont_vnumcontenedor'].'",'.
							'"'.$valuesForm['cont_vcontenido'].'",'.
							'"'.$valuesForm['cont_dterminostacking'].'",'.
							$valuesForm['lug_ncorr_devolucion'].','.
							$valuesForm['cont_ndiaslibres'].','.
							'"'.$valuesForm['cont_vsello'].'",'.
							$valuesForm['ada_ncorr'].','.
							$valuesForm['cada_ncorr'].','.
							$valuesForm['cont_npeso'].','.
							$valuesForm['med_ncorr'].','.
							$valuesForm['cond_ncorr'].')';

	$result = mysql_query($queryparameter,$connection) or die('La consulta fall&oacute;: '.mysql_error());		
?>