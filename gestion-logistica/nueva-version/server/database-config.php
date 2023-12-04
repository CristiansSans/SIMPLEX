<?php
// Configuracion de la conexion a la bd
$db_host= 'localhost';           
$db_username= 'promotek_sa';
$db_password= 'fox71402';
$db_name = 'promotek_sqm_sgl';

// Conexion a la bd
$connection = mysql_connect($db_host, $db_username, $db_password) or die("Error de conexión al servidor SQL".$connection ."<br>".mysql_error()."<br>");

mysql_select_db($db_name,$connection) or die("Error de conexion a la base de datos");
mysql_query("SET NAMES 'utf8'");

function convertArrayKeysToUtf8(array $array){ 
	$convertedArray = array(); 
    foreach($array as $key => $value){ 
		if(!mb_check_encoding($value, 'UTF-8')) $value = utf8_encode($value); 
		if(is_array($value)) $value = $this->convertArrayKeysToUtf8($value); 
		$convertedArray[$key] = $value; 
    } 
    return $convertedArray; 
}

function convertDateToFormatYYMMDD($date){
	$dateArray = preg_split('/\//',$date);

	return $dateArray[2].'-'.$dateArray[1].'-'.$dateArray[0];
}
?>

