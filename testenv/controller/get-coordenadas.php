<?php
	$destinations  	= isset($_REQUEST['destinations'])  ? $_REQUEST['destinations']  :  '';
	$destinations	= str_replace("\\","",$destinations);
	$address	= json_decode($destinations,true);
	$data=array();

	foreach($address as $key => $value){
		if ($value!=""){
			$addr	= urlencode($value);//urlencode($key['destino']);
			$url	= 'http://maps.google.com/maps/geo?q='.$addr.'&output=csv&sensor=false';
			$ch 	= curl_init($url);

			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			
			$get 	= curl_exec ($ch);
			
			curl_close ($ch);			

			$records= explode(",",$get);
			$lat 	= $records['2'];
			$lng	= $records['3'];
			
			$data[] = array('lat'=>$lat, 'lng'=>$lng, 'destination'=>$value);
		}
	}
	echo '{"total":'.count($data).',"success":true,"data":'.json_encode($data).'}';
?>