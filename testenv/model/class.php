<?php
	function executeSQLCommand($transacSql){
//	echo $GLOBALS['db_ip'], $GLOBALS['db_user'],  $GLOBALS['db_pass'], $GLOBALS['db_name'];
//		$Session 	=mysql_connect($GLOBALS['localhost'], $GLOBALS['simplex1_sgl_use'], $GLOBALS['sgl2015'],false) or die("Imposible conectar al Servidor");
//		$Connection	=mysql_select_db($GLOBALS['simplex1_sqm_sgl'], $Session);

//,false,199608
		$Session 	=mysql_connect($GLOBALS['db_ip'], $GLOBALS['db_user'], $GLOBALS['db_pass']);// or die("Imposible conectar al Servidor");
		$Connection	=mysql_select_db($GLOBALS['db_name'], $Session);
		$rs					=mysql_query("SET collation_connection = latin1_spanish_ci;");	  
		$rs					=mysql_query($transacSql) or die( mysql_error() );
		return $rs;
	}

	function deescape ($s, $charset='UTF-8'){
	   //  don't interpret html codes and don't convert quotes
	   $s  =  htmlentities ($s, ENT_NOQUOTES, $charset);
	
	   //  delete the inserted backslashes except those for protecting single quotes
	   $s  =  preg_replace ("/\\\\([^'])/e", '"&#" . ord("$1") . ";"', $s);
	
	   //  delete the backslashes inserted for protecting single quotes
	   $s  =  str_replace ("\\'", "&#" . ord ("'") . ";", $s);
	
	   return  $s;
	}
	
	function ansiFormatDate($spanishFormatDate){
		list($day, $month, $year) = explode("/", $spanishFormatDate);
		return $year .'-'. $month .'-'. $day;
	}
?>