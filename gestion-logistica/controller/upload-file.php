<?php
	error_reporting(E_ALL); 
	ini_set("display_errors", 1);  

	$archivo_name	=$_FILES['Filedata']['name'];
	$archivo_tmp	=$_FILES['Filedata']['tmp_name'];
	$extension 	= explode(".",$archivo_name);

	$fileSuccess 	= move_uploaded_file($archivo_tmp, "../upload-files-carga/$archivo_name");

	// This message will be passed to 'oncomplete' function
	if($fileSuccess){
		echo '{"total":1},{"success":true, "file":"'.$archivo_name.'"}';
	}
	else{
		echo '{"total":1},{"failure":true}';
	}
?>