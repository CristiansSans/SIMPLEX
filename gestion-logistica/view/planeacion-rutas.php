<style>
	button.g-button, input.g-button[type="submit"] {
	  line-height: 29px;
	  vertical-align: bottom;
	}

	.g-button-submit:focus, .g-button-share:focus, .g-button-red:focus {
	  box-shadow: 0 0 0 1px #FFFFFF inset;
	}	

	.g-button-submit {
	  background-color: #4D90FE;
	  background-image: -moz-linear-gradient(center top , #4D90FE, #4787ED);
	  border: 1px solid #3079ED;
	  color: #FFFFFF;
	  text-shadow: 0 1px rgba(0, 0, 0, 0.1);
	}	

	.g-button {
	  -moz-transition: all 0.218s ease 0s;
	  -moz-user-select: none;
	  border-radius: 2px 2px 2px 2px;
	  cursor: pointer;
	  display: inline-block;
	  font-weight: bold;
	  min-width: 46px;
	  padding: 0 8px;
	  text-align: center;
	}	
</style>

<script>
	var ROOT_CONTROLLER='../controller',
		formID=Ext.id();

	var myOptions = {
	  zoom: 16,
	  center: new google.maps.LatLng(-33.44623159330487,-70.64020156860352),
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	};

	var markerIcon=[];
	var destinationIcon = "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=D|FF0000|000000";
	var originIcon = "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=O|FFFF00|000000";

	var calculateDistances=function(){
		var recordForm=Ext.getCmp(formID).getForm().getFieldValues(),
			recordItem=Ext.getCmp(formID).getForm().items,
			addresses='';
		
		Ext.each(recordItem.items, function(item){
			addresses +=item.getValue();
		});

		if(Ext.isEmpty(addresses)){
			Ext.Msg.show({  
				title	: 'Planeacion de rutas',
				msg		: 'No existen direcciones definidas para generar el calculo de ruta...',
				buttons	: Ext.Msg.OK,
				icon: Ext.Msg.WARNING
			});  		

			return
		}

		var geocoder = new google.maps.Geocoder(),
			map = new google.maps.Map(document.getElementById('map_canvas'),myOptions);
			infoWindow = new google.maps.InfoWindow,
			boxText = document.createElement("div"),
			latitude = [],
			longitude = [],
			destination=[];

		Ext.Ajax.request({
			url: ROOT_CONTROLLER + '/get-coordenadas.php',
			method: 'POST',
			params:{destinations:Ext.util.JSON.encode(recordForm)},
			success: function (data) {
				var jsonData = Ext.decode(data.responseText);

				Ext.each(jsonData.data, function(item){
					latitude.push(item.lat);
					longitude.push(item.lng);
					destination.push(item.destination);
				});

				var ib=null

				markerIcon=[];
				createMarkers(geocoder, map, destination[0], latitude[0], longitude[0], ib, originIcon);

				for(var a = 1; a < latitude.length; ++a){
					var iconFile="http://maps.google.com/mapfiles/marker" + String.fromCharCode(a + 64) + ".png"

					createMarkers(geocoder, map, destination[a], latitude[a], longitude[a], ib, iconFile);
				}
				
				map.setCenter(new google.maps.LatLng(latitude[0],longitude[0]));
				
				//console.log(markerIcon)
			}
		});
	}

	var drawRoute=function (selectedMode, origin, destination) {
/*
		new Ext.Window({
			id			: Ext.id(),
			title		: 'Demo Rutas ...',
			autoDestroy	: false,
			shadow		: false,
			//padding		: 5,
			width		: 400,
			height		: 400,
			modal		: true,
			layout		: 'fit',
			html		: '<div id="map_detalle" style="height:100%; border-style:solid; border-color:#FFFF77; margin:1px;"></div>',
			items		: [
			]
		}).show();
*/			
		document.getElementById('route').innerHTML='';
		
		var directionsService = new google.maps.DirectionsService();
		var directionsDisplay = new google.maps.DirectionsRenderer();
		var optionsDetalle = {
			zoom:7,
			mapTypeId: google.maps.MapTypeId.ROADMAP
			//center: chicago
		  }
		
		directionsDisplay.setPanel(document.getElementById('route'));

		var detalleMap = new google.maps.Map(document.getElementById("map_detalle"), optionsDetalle);
		directionsDisplay.setMap(detalleMap);
		
		var request = {
			origin: origin,
			destination: destination,
			travelMode: google.maps.DirectionsTravelMode[selectedMode]
		};
		directionsService.route(request, function(response, status) {
			if (status == google.maps.DirectionsStatus.OK) {
				directionsDisplay.setDirections(response);
			}
		});
	}		
	
	function createMarkers(geocoder, map, name, latitude, longitude, ib, image) {
		//Setting the onclick marker function
		var onMarkerClick = function() {
			var marker = this;
			var latLng = marker.getPosition();
			
			drawRoute('DRIVING', Ext.getCmp('destination-A').getValue(), name)
			
			//ib.setContent(name);
			//ib.open(map, marker);
		  };
		  
		  google.maps.event.addListener(map, 'click', function() {
				//alert(1)
			  //ib.close();
			});
		  
		  //In array lat long is saved as an string, so need to convert it into int.
		  var lat = parseFloat(latitude);
		  var lng = parseFloat(longitude);

		var marker = new google.maps.Marker({
			map: map,
			icon: image,
			position: new google.maps.LatLng(lat, lng),
			title: name
		});

		//Adding the marker.
		google.maps.event.addListener(marker, 'click', onMarkerClick);
		
		markerIcon.push(marker);
	}

	function getMarkerIcon(index){
		//console.log("index:",index, "markerIcon.length:",markerIcon.length);

		if (markerIcon.length!=0)
			if (index<markerIcon.length){
				var latLng = markerIcon[index].getPosition();
				//console.log("latitude:",markerIcon[index].getPosition().$a);
				map.setCenter(new google.maps.LatLng(markerIcon[index].getPosition().$a, markerIcon[index].getPosition().ab));				
				//console.log(latLng);
			}
	}
	
	var assignLetterToDestiny=function(destiny,letter){
		var top=[-141,-72,-315,-505,-24,0,-354,-553,-623,-601]

		labelInput=Ext.get(destiny).dom.parentNode.parentNode.firstElementChild
		labelInput.innerHTML=	'<div style="width: 24px; height: 24px; top:-3px; overflow: hidden; position: relative;">'+
								'	<img id="'+letter+'" style="cursor:pointer;position: absolute; left: 0px; top: '+top[(letter.charCodeAt(0)-65)]+'px; -moz-user-select: none; border: 0px none; padding: 0px; margin: 0px;" src="../images/widget-signals.png">'+
								'</div>';

		Ext.get(letter).on('click', function(){getMarkerIcon(letter.charCodeAt(0)-65);});
								
		Ext.DomHelper.append(Ext.get('x-form-el-destination-'+letter),
			{tag:'div',class:'dir-c', children: [{tag:'div',class:'dir-wp-x'}]}
		);
	}

	var initialize=function (){
		map = new google.maps.Map(document.getElementById('map_canvas'),myOptions);
		if(navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(
				function(position){
					map.setCenter(new google.maps.LatLng(position.coords.latitude, position.coords.longitude));
				}, 
				function() {
				}
			);
		} 
		else {
			//map.setCenter(new google.maps.LatLng(-33.44723159330487,-70.64050156860352));
		}
		//map.setCenter(new google.maps.LatLng(-33.44723159330487,-70.64050156860352));
	}

	Ext.onReady(function(){
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		Ext.fly('title-header').update('Planeacion', false);
		
		new Ext.Panel({
            id			: Ext.id(),
			renderTo	: 'main-container',
			width		: '100%',
			height		: hBrowser-50,
            layout		: 'border',
			bodyStyle	: 'padding:10px;',
            border		: false,
            items		: [
				new Ext.Panel({
					title			: 'Parametros',
					layout			: 'accordion',
					split			: true, 
					collapseMode	: 'mini', 
					region			: 'west',
					width			: '30%',
					items			: [
						new Ext.FormPanel({
							title			: 'Origen/Destino',
							id				: formID,
							trackResetOnLoad: true,
							defaults		: {anchor:'95.5%'},
							autoScroll		: true,
							labelWidth		: 20,
							bodyStyle		: 'background-color: #FFFFFF; padding:10px;',
							html			: '<input type="button" value="Generar Ruta" id="evaluar-ruta" name="evaluar-ruta" class="g-button g-button-submit" onclick="calculateDistances();">',//+
											  //'<div id="route" style="height:100%; margin:1px;"></div>',
							items			: [
								new Ext.form.TextField({ id:'destination-A', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-B', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-C', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-D', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-E', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-F', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-G', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-H', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-I', allowBlank : true}),
								new Ext.form.TextField({ id:'destination-J', allowBlank : true})
							]
						}),
						new Ext.Panel({
							title			: 'Rutas Sugeridas',
							id				: Ext.id(),
							border			: false,
							frame			: false,
							autoScroll		: true,
							//height			: '100%',
							layout			: 'fit',
							html			: '<div id="map_detalle" style="height:100%; border-style:solid; border-color:#FFFF77; margin:1px;"></div>'+
											  '<div id="route" style="height:100%; padding:10px;"></div>'
						})
					]
				}),
				new Ext.Panel({
					id				: Ext.id(),
					border			: false,
					frame			: false,
					height			: '100%',
					layout			: 'fit',
					region			: 'center',
					layout			: 'fit',
					bodyStyle		: 'background-color: #E8E8E8;',
					html			: '<div id="map_canvas" style="height:100%; border-style:solid; border-color:#FFFF77; margin:1px;"></div>'
				})
			]
		});
		
		assignLetterToDestiny('destination-A','A');
		assignLetterToDestiny('destination-B','B');
		assignLetterToDestiny('destination-C','C');
		assignLetterToDestiny('destination-D','D');
		assignLetterToDestiny('destination-E','E');
		assignLetterToDestiny('destination-F','F');
		assignLetterToDestiny('destination-G','G');
		assignLetterToDestiny('destination-H','H');
		assignLetterToDestiny('destination-I','I');
		assignLetterToDestiny('destination-J','J');
		
		initialize();
	});
</script>