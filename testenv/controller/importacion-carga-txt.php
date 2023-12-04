<?php
	include_once '../model/class.php';
	include_once '../model/config.php';

	$fileImport  	 	= isset($_REQUEST['file'])  ? $_REQUEST['file']  :  '';
	
	$queryparameter= "select MIM_VNOMBRECAMPO, MIM_VTABLABD from tg_mapeoimportacion";
	$rs = executeSQLCommand(stripslashes($queryparameter));

	$table	= array();
	$fields	= array();
	
	while($obj = mysql_fetch_object($rs)) {
	    $tableArray[]	= $obj->MIM_VTABLABD;
	    $fieldsArray[]	= $obj->MIM_VNOMBRECAMPO;
	}

	$filas=file($fileImport);
	$i=0;
	$numero_fila=0;
	
	while($filas[$i]!=NULL){
		$row 		= $filas[$i+1];
		$table		= $tableArray[0];
		$fields		= $fieldsArray[0].','.$fieldsArray[1].','.$fieldsArray[2].','.$fieldsArray[3].','.$fieldsArray[4].','.$fieldsArray[5];
		$values 	= explode(",",$row);
		
		$rowValues	= '"'.$values[0].'","'.$values[1].'","'.$values[2].'","'.$values[3].'","'.$values[4].'","'.$values[5].'"';

		$i++;
		$numero_fila++;

		$queryparameter = 	"insert into $table ($fields) ".
					"values ($rowValues)";
		
		//echo $queryparameter;		
		$rs = executeSQLCommand(stripslashes($queryparameter));
	}
?>