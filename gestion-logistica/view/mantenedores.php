<?php
	session_start();
	$usua_ncorr	= $_SESSION['usua_ncorr'];
	
	$id		= isset($_REQUEST['id'])  ? $_REQUEST['id']  :  '';
	$rowindex	= isset($_REQUEST['rowindex'])  ? $_REQUEST['rowindex']  :  '';
?>
<style>
	.x-panel-btns{
		background-color: #F1F1F4;
		/*height:1px;*/
	}

	input[type=file]{
		background:#000000;
	}
	
	.upload-icon {
		background: url(../images/doc-ximport-16x16.png) no-repeat 0 0 !important;
	}
	
</style>
<script>
	var eyeFish_BUTTONS='<div class="eye-fish">'+
						'	<article class="breadcrumbs">'+
						'		<a>Principal</a>'+
						'		<div class="breadcrumb_divider"></div>'+
						'		<a href="javascript:loadModulo(\'task-list.php\')">Task List</a>'+
						'		<div class="breadcrumb_divider"></div>'+
						'		<a class="current">Mantenedores</a>'+
						'	</article>'+
						'</div>';
						
	var idGridTramos		=Ext.id(),
		idGridHitos			=Ext.id(),
		idGridLugares		=Ext.id(),
		idGridClientes		=Ext.id(),
		idFormClientes		=Ext.id(),
		idGridServicios		=Ext.id(),
		idGridCotizacion	=Ext.id(),
		idFormTransportista	=Ext.id(),
		idGridTransportista	=Ext.id(),
		idTabServiciosTransportista	=Ext.id();

		//lg led 32ls3400

	Ext.onReady(function(){
		Ext.QuickTips.init();
		var hBrowser 	= (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		var usua_ncorr	= <?php echo $usua_ncorr;?>;

		Ext.fly('title-header').update('Mantenedores'+eyeFish_BUTTONS, false);

		var storeTramos = new Ext.data.Store({
			url:'../controller/get-tramos.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				remoteSort: false,
				fields: [
					{name: 'tra_ncorr', mapping:'tra_ncorr', type:'number', useNull:true},
					{name: 'idorigen', mapping:'IdOrigen',type:'number', useNull:true},					
					{name: 'iddestino', mapping:'IdDestino',type:'number',useNull:true},					
					{name: 'tra_kms', mapping:'tra_kms',type:'number',useNull:true},					
					{name: 'tra_tiempo',mapping:'tra_tiempo', type:'number',useNull:true}
				]
			}),
			listeners: {
				load:function (store,records,options) {
					record=store.getAt(0);
				}
			}
		});
		storeTramos.load();

		var westGridTramos=	new Ext.grid.GridPanel({
			id			: idGridTramos,
			title		: 'Tramos',
			stripeRows	: true,
			border		: false,
			flex		: 1,
			frame		: false,
			store		: storeTramos,
			width		: '50%',
			layout		: 'fit',
			region		: 'west',
			tbar		: new Ext.PagingToolbar({
				store 		: storeTramos,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Origen",dataIndex:"idorigen", sortable:true},
				{header:"Destino",dataIndex:"iddestino", sortable:true},
				{header:"Kms",dataIndex:"tra_kms", sortable:true},
				{header:"Tiempo",dataIndex:"tra_tiempo", sortable:true},
				{
					header:"Accion", 
					sortable:true,
					width:60,
					renderer: function (value, metadata, record, rowIndex, colIndex, store) {
						if (!Ext.isEmpty(value))
							return String.format('<table><tr><td style="height:24px;vertical-align:center;"><a href="../controller/generate-factura.php?id={0}"><img src="../images/icon-edit.png" /></a></td><td style="height:24px;vertical-align:center;"><img src="../images/trash.png" /></td></tr></table>',value,value)						
							//return String.format('<table><tr><td style="height:25px;vertical-align:center;"><a href="javascript:trackingWindow({0});"><img src="../images/icon-edit.png" /></a></td><td style="height:24px;vertical-align:center;"><span>{1}</span></td></tr></table>',rowIndex, value)
					}
				}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeTramos.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});

		var westGridHitos=	new Ext.grid.GridPanel({
			id			: idGridHitos,
			title		: 'Hitos',
			stripeRows	: true,
			border		: false,
			frame		: false,
			store		: storeTramos,
			layout		: 'fit',
			region		: 'center',
			tbar		: new Ext.PagingToolbar({
				store 		: storeTramos,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Nombre Hito",dataIndex:"idorigen", sortable:true},
				{header:"Km",dataIndex:"iddestino", sortable:true},
				{header:"Tiempo (Mins)",dataIndex:"tra_tiempo", sortable:true},
				{
					header:"Accion", 
					sortable:true,
					width:60,
					renderer: function (value, metadata, record, rowIndex, colIndex, store) {
						return String.format('<table><tr><td style="height:24px;vertical-align:center;"><a href="../controller/generate-factura.php?id={0}"><img src="../images/icon-edit.png" /></a></td><td style="height:24px;vertical-align:center;"><img src="../images/trash.png" /></td></tr></table>',value,value)						
					}
				}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeTramos.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});
		
		var westPanelTramos =	new Ext.Panel({
			title		: 'Mantenedor Tramos',
			layout		: 'border',
			border		: false,
			height		: '100%',
			width		: '100%',
			items		: [westGridTramos, westGridHitos]
		});

		var storeLugares = new Ext.data.Store({
			url:'../controller/get-selector-generic.php?sp=prc_lugar_listar',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				remoteSort: false,
				fields: [
					{name: 'id', mapping:'id', type:'number', useNull:true},
					{name: 'description', mapping:'description',type:'string', useNull:true},					
					{name: 'lug_vnombre', mapping:'lug_vnombre',type:'string',useNull:true},					
					{name: 'lug_vdireccion', mapping:'lug_vdireccion',type:'string',useNull:true}
				]
			}),
			listeners: {
				load:function (store,records,options) {
					record=store.getAt(0);
				}
			}
		});
		storeLugares.load({params:{id:0}});
		
		var westGridLugares=	new Ext.grid.GridPanel({
			id			: idGridLugares,
			title		: 'Lugares',
			stripeRows	: true,
			border		: false,
			flex		: 1,
			frame		: false,
			store		: storeLugares,
			width		: '100%',
			layout		: 'fit',
			region		: 'center',
			tbar		: new Ext.PagingToolbar({
				store 		: storeLugares,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Lugar",dataIndex:"id", sortable:true},
				{header:"Tipo",dataIndex:"description", sortable:true},
				{header:"Nombre",dataIndex:"lug_vnombre", sortable:true},
				{header:"Direccion",dataIndex:"lug_vdireccion", sortable:true},
				{
					header:"Accion", 
					sortable:true,
					width:60,
					renderer: function (value, metadata, record, rowIndex, colIndex, store) {
						return String.format('<table><tr><td style="height:24px;vertical-align:center;"><a href="../controller/generate-factura.php?id={0}"><img src="../images/icon-edit.png" /></a></td><td style="height:24px;vertical-align:center;"><img src="../images/trash.png" /></td></tr></table>',value,value)						
					}
				}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeLugares.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});

		var westPanelLugares =	new Ext.Panel({
			title		: 'Mantenedor Lugares',
			layout		: 'border',
			border		: false,
			height		: '100%',
			width		: '100%',
			items		: [westGridLugares]
		});

		var gridClientes=	new Ext.grid.GridPanel({
			id			: idGridClientes,
			title		: 'Clientes',
			stripeRows	: true,
			border		: false,
			//flex		: 1,
			frame		: false,
			store		: storeTramos,
			layout		: 'fit',
			region		: 'center',
			tbar		: new Ext.PagingToolbar({
				store 		: storeTramos,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Cliente",dataIndex:"idorigen", sortable:true},
				{header:"Rut",dataIndex:"iddestino", sortable:true}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeTramos.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});

		var formClientes=	new capturactiva.ux.Generic.Form({
			id			: idFormClientes,
			trackResetOnLoad: false,
			defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
			labelWidth	: 130,
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
			autoScroll	: true,
			region		: 'south',
			tools:[
			{
				id:'help',
				qtip: 'Get Help',
				handler: function(event, toolEl, panel){
				}
			}],
			items		: [
				new Ext.form.NumberField({ id:'rut', name:'rut', fieldLabel: 'Rut', allowBlank : false, disabled:false}),
				new Ext.form.TextField({ id:'razon-social', name:'razon-social', fieldLabel: 'Razon Social', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'direccion', name:'direccion', fieldLabel: 'Direccion', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'contacto-legal', name:'contacto-legal', fieldLabel: 'Contacto Legal', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'giro', name:'giro', fieldLabel: 'Giro', allowBlank : false, disabled:true}),				
			]
		});
		
		var gridServicios=	new Ext.grid.GridPanel({
			id			: idGridServicios,
			title		: 'Servicios',
			stripeRows	: true,
			border		: false,
			frame		: false,
			store		: storeTramos,
			layout		: 'fit',
			region		: 'west',
			width		: '65%',
			tbar		: new Ext.PagingToolbar({
				store 		: storeTramos,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Servicio",dataIndex:"idorigen", sortable:true},
				{header:"Detalle",dataIndex:"iddestino", sortable:true},
				{header:"Origen",dataIndex:"idorigen", sortable:true},
				{header:"Destino",dataIndex:"idorigen", sortable:true},
				{header:"Monto",dataIndex:"idorigen", sortable:true},
				{header:"Nº Cotizacion",dataIndex:"idorigen", sortable:true}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeTramos.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});

		var gridCotizacion=	new Ext.grid.GridPanel({
			id			: idGridCotizacion,
			title		: 'Cotizacion',
			stripeRows	: true,
			border		: false,
			frame		: false,
			store		: storeTramos,
			layout		: 'fit',
			region		: 'center',
			//width		: '50%',
			tbar		: new Ext.PagingToolbar({
				store 		: storeTramos,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Nº Cotizacion",dataIndex:"idorigen", sortable:true},
				{header:"Fecha",dataIndex:"iddestino", sortable:true},
				{header:"Monto",dataIndex:"idorigen", sortable:true}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeTramos.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});
		
		var panelWestClientes =	new Ext.Panel({
			border		: false,
			layout		: 'border',
			region		: 'west',
			height		: '100%',
			width		: '30%',
			margins		: '0 2 0 2',
			items		: [gridClientes, formClientes]
		});

		var panelCenterClientes =	new Ext.Panel({
			border		: false,
			layout		: 'border',
			region		: 'center',
			height		: '100%',
			width		: '100%',
			margins		: '0 2 0 2',
			split		: true, 
			collapseMode: 'mini',
			items		: [gridServicios, gridCotizacion]
		});
		
		var panelClientes =	new Ext.Panel({
			title		: 'Mantenedor Clientes',
			layout		: 'border',
			region		: 'center',
			border		: false,
			height		: '100%',
			width		: '100%',
			margins		: '0 3 0 3',
			items		: [panelWestClientes, panelCenterClientes]
		});

		var gridTransportista=	new Ext.grid.GridPanel({
			id			: idGridTransportista,
			//title		: 'Clientes',
			stripeRows	: true,
			border		: false,
			//flex		: 1,
			frame		: false,
			store		: storeTramos,
			layout		: 'fit',
			region		: 'center',
			tbar		: new Ext.PagingToolbar({
				store 		: storeTramos,
				displayInfo	: true,
				pageSize	: 15,
			}),
			columns 	:[
				{header:"Empresa",dataIndex:"idorigen", sortable:true},
				{header:"Rut",dataIndex:"iddestino", sortable:true}
			],
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeTramos.getAt(rowIndex);
				},
				rowdblclick	: function(grid, rowIndex, e) {
				
				}
			}
		});
		
		var formTransportista=	new capturactiva.ux.Generic.Form({
			id			: idFormTransportista,
			trackResetOnLoad: false,
			defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
			labelWidth	: 130,
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
			autoScroll	: true,
			region		: 'south',
			tools:[
			{
				id:'help',
				qtip: 'Get Help',
				handler: function(event, toolEl, panel){
				}
			}],
			items		: [
				new Ext.form.NumberField({ id:'rut-transportista', name:'rut', fieldLabel: 'Rut', allowBlank : false, disabled:false}),
				new Ext.form.TextField({ id:'contacto-transportista', name:'contacto', fieldLabel: 'Contacto', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'direccion-transportista', name:'direccion', fieldLabel: 'Direccion', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'fono-transportista', name:'direccion', fieldLabel: 'Fono', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'razon-social-transportista', name:'razon-social', fieldLabel: 'Razon Social', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'giro-transportista', name:'giro', fieldLabel: 'Giro', allowBlank : false, disabled:true}),
				new Ext.form.TextField({ id:'mail-transportista', name:'mail', fieldLabel: 'Mail', allowBlank : false, disabled:true}),				
			]
		});

		var tabServiciosTransportista=new Ext.TabPanel({
			id			: idTabServiciosTransportista,
			//tabPosition	: 'bottom',
			activeTab	: 0,
			region		: 'center',
			defaults	: {autoScroll:true},
			items		: [
				{
					title		: 'Tarifas',
					closable	: false,
					layout		: 'fit',
					border		: false,
					height		: 300,
					autoScroll	: true,
					autoLoad	: {url : 'transportista-tarifas.php', scripts: true}
				},
				{
					title		: 'Camiones y chasis',
					closable	: false,
					layout		: 'fit',
					border		: false,
					height		: 300,
					autoScroll	: true,
					autoLoad	: {url : 'transportista-camiones-chasis.php', scripts: true}
				},
				{
					title		: 'Costo',
					closable	: false,
					layout		: 'fit',
					border		: false,
					autoScroll	: true
				}
			]
		});

		var panelCenterTransportista =	new Ext.Panel({
			border		: false,
			layout		: 'border',
			region		: 'center',
			height		: '100%',
			width		: '100%',
			margins		: '0 2 0 2',
			split		: true, 
			collapseMode: 'mini',
			items		: [tabServiciosTransportista]
		});
		
		var panelWestTransportista =	new Ext.Panel({
			border		: false,
			layout		: 'border',
			region		: 'west',
			height		: '100%',
			width		: '30%',
			margins		: '0 2 0 2',
			items		: [gridTransportista, formTransportista]
		});

		var panelTransportista =	new Ext.Panel({
			title		: 'Mantenedor Transportistas',
			layout		: 'border',
			region		: 'center',
			border		: false,
			height		: '100%',
			width		: '100%',
			margins		: '0 3 0 3',
			items		: [panelWestTransportista, panelCenterTransportista]
		});
		
		var centerPanelMain=	new Ext.Panel({
			layout			: 'accordion',
			region			: 'center',
			items			: [ westPanelTramos, westPanelLugares, panelClientes, panelTransportista],
			bbar		: [
				'->',
				'-',
				{
					text	: 'Grabar', 
					id		:'grabar-carga', 
					disabled:true, 
					handler	:function(){
					}
				},
				'-',
				{
					text	: 'Cancelar', 
					id		:'cancelar-carga', 
					disabled:true, 
					handler:function(){
					}
				},
				'-'
			]
		});

		new Ext.Panel({
			id			: Ext.id(),
			renderTo	: 'main-container',
			width		: '100%',
			height		: hBrowser-50, 
			layout		: 'border',
			border		: false,
			items		: [centerPanelMain]
		});
	});
</script>