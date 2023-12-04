<?php
	require '../database-config.php';
/*
  # Perform the query
  $queryparameter = sprintf("select ose_ncorr, ose_vnombrenave from tg_ordenservicio where ose_vnombrenave like '%%%s%%' ORDER BY ose_ncorr DESC LIMIT 10", mysql_real_escape_string($_GET["q"]));
  $arr = array();
  $rs = mysql_query($queryparameter);
  
  # Collect the results
  while($obj = mysql_fetch_object($rs)) {
      $arr[] = $obj;
  }
  
  # JSON-encode the response
  $json_response = json_encode($arr);
  
  # Optionally: Wrap the response in a callback function for JSONP cross-domain support
//  if($_GET["callback"]) {
//      $json_response = $_GET["callback"] . "(" . $json_response . ")";
//  }
  
  # Return the response
  echo $json_response;
 */
  $queryparameter = sprintf("select ose_ncorr, ose_vnombrenave from tg_ordenservicio where ose_vnombrenave like '%%%s%%' ORDER BY ose_ncorr DESC LIMIT 10", mysql_real_escape_string($_POST["query"]));
 	$result = mysql_query($queryparameter, $connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$obj->ose_vnombrenave=utf8_decode($obj->ose_vnombrenave);
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';
	echo ',"success":' . (mysql_errno($connection)==0 ? "true" : "false") . ', "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>