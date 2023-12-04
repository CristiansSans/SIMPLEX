<?php
	require '../database-config.php';

//	$table  	= $_REQUEST['table'];
//	$key  		= $_REQUEST['key'];
//	$description= $_REQUEST['description'];

	$id	= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  '';
	$sp	= isset($_REQUEST['sp'])  ? $_REQUEST['sp']  :  '';
	
	$queryparameter = "call $sp ($id)";
	
	$arr			= array();
//	$sqlSentencia  	= 	"select $key id, null idparent, $description description ".
//						"from $table";
/*
       $queryparameter = " select".
			 "      `tb_lugar`.`lug_ncorr` id,".
			 "       null idparent,".
			 "      `tb_lugar`.`tlu_ncorr`,".
			 "      `tb_lugar`.`lug_vnombre` description,".
			 "      `tb_lugar`.`lug_vdireccion`,".
			 "      1 orden".
			 "       from `tb_lugar`".
			 "       where tlu_ncorr = 5".
			 "       union".
			 "       select 0 id, null idparent, 0 tlu_ncorr,  '-------------'  description, '' lug_vdireccion, 2 orden".
			 "       union".
			 "      select `tb_lugar`.`lug_ncorr` id,".
			 "       null idparent,".
			 "      `tb_lugar`.`tlu_ncorr`,".
			 "      `tb_lugar`.`lug_vnombre` description,".
			 "      `tb_lugar`.`lug_vdireccion`,".
			 "       3 orden".
			 "       from `tb_lugar`".
			 "       where tlu_ncorr < 5".
			 "      order by orden asc, description asc";
*/			
	$result = mysql_query($queryparameter, $connection) or die('La consulta fall&oacute;: '.mysql_error());		

	while($obj = mysql_fetch_object($result)) {
		$obj->description=utf8_decode($obj->description);
		$arr[] = $obj;
	}
	echo '{ metaData: { "root": "data"}';
	echo ',"success":' . (mysql_errno($connection)==0 ? "true" : "false") . ', "data":' . json_encode($arr) . '}';
	mysql_close($connection);
?>