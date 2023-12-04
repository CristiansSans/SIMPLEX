<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';
	$chofer = $_GET['chofer'];
	$query = "";
	$resp  = "";
	
	$query = "select chof_vfono from tg_chofer where chof_ncorr = " .$chofer;
	$result = executeSQLCommand($query);

	while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$resp = $row[chof_vfono];
	}
	
	echo json_encode($resp);	
?>
