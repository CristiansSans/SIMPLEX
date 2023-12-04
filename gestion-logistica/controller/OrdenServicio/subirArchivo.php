<?php
	include_once '../../model/class.php';
	include_once '../../model/config.php';

	//comprobamos que sea una petición ajax
	$tipo	= $_GET['tipo']; //1=Container, 2=Carga libre
	$texto;
	$textoMail;
	if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	
		//obtenemos el archivo a subir
		//$file = $_FILES['archivo']['name'];
		$file = "tempfile.csv";
	
		$textoMail = "Archivo recuperado : " . $file."\n";
		//comprobamos si existe un directorio para subir el archivo
		//si no es así, lo creamos
		if (!is_dir("files/"))
			mkdir("files/", 0777);
	
		//comprobamos si el archivo ha subido
		if ($file && move_uploaded_file($_FILES['archivo']['tmp_name'], "files/" . $file)) {
			$textoMail = $textoMail."Archivo cargado";
			sleep(3);
			//retrasamos la petición 3 segundos
	
			//1.- Leer el archivo
			$index=0;
			
			if (($fichero = fopen("files/" . $file, "r")) !== FALSE) {
				while (($datos = fgetcsv($fichero, 1000)) !== FALSE) {
					$textoMail = $textoMail."Cargando fila ".$index."\n";
					if ($index > 0) {
						$texto = $datos[0];
						$textoMail = $textoMail."Texto :".$texto."\n";
						if ($tipo==1){
							//Ingreso de contenedor
							list($codOrden, $contenedor, $sello, $peso,$codMedida, $codCondicion, $observaciones, $codAgencia, $booking, $operacion, $marcaContenedor, $contenido, $terminoStacking, $diasLibres, $contactoEntrega, $temperatura, $ventilacion, $otros,$obsTraslado) = split(';', $texto);
							
							if ($terminoStacking==""){
								
							}else{
								list($dia, $mes, $anio) = split('-', $terminoStacking);
								$terminoStacking = $anio.'-'.$mes.'-'.$dia;	
							}							
														
							if ($diasLibres==""){
								$diasLibres = 0;
							}
							
							if ($temperatura==""){
								$temperatura = 0;
							}
							
							if ($ventilacion==""){
								$ventilacion = 0;
							}	
							
							if ($codAgencia==""){
								$codAgencia = 0;
							}													
							
							$queryparameter  = 	'call prc_container_importar('.$codOrden.',"'.$contenedor.'","'.$sello.'",'.$peso.','.$codMedida.','.$codCondicion.',"'.$observaciones.'",'.$codAgencia.',"'.$booking.'","'.$operacion.'","'.$marcaContenedor.'","'.$contenido.'","'.$terminoStacking.'",'.$diasLibres.',"'.$contactoEntrega.'",'.$temperatura.','.$ventilacion.',"'.$otros.'","'.$obsTraslado.'")';
							$textoMail = $textoMail."Llamado a SP :".$queryparameter."\n\n";
						}else{
							//Ingreso de carga libre
							//list($codOrden, $codUM, $cantidad, $observaciones) = split(';', $texto);	
							//$queryparameter  = 	'call prc_cargalibre_importar('.$codOrden.','.$codUM.','.$cantidad.',"'.$observaciones.'")';
							
							list($codOrden, $codUM, $cantidad, $booking, $operacion, $observaciones) = split(';', $texto);	
							$queryparameter  = 	'call prc_cargalibre_importar('.$codOrden.','.$codUM.','.$cantidad.',"'.$observaciones.'","'.$booking.'","'.$operacion.'")';
														
							$textoMail = $textoMail."Llamado a SP :".$queryparameter."\n\n";
						}
												
						//$texto = $queryparameter;
						
						$rs = executeSQLCommand(stripslashes($queryparameter));
						// Procesar los datos.
						// En $datos[0] está el valor del primer campo,
						// en $datos[1] está el valor del segundo campo, etc...
					};
					$index++;
				}
			}
			//error_log($textoMail,1,'haichele@gmail.com');
	
			//Retorno de archivo
			echo json_encode("Archivo cargado exitosamente");
			//echo $texto;
		}
	} else {
		echo "Se ha presentado un error";
		//throw new Exception("Error Processing Request", 1);
	}
