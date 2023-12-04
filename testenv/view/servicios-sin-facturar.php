<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

<div id="servicios-sin-facturar">
	<script type="text/javascript"> 
		var id		 	 =Ext.id();
		var idWindow	 =Ext.id();
		var idFormEdicion=Ext.id();
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		
		Ext.onReady(function(){
			var renderFecha = function(v,record){
		           var dt = new Date(v);
		           return dt.format('dd-mm-yyyy h:i'); 
		        };

			var storeServicioSinFacturar = new Ext.data.Store({
				url:'../controller/get-servicios-sin-facturar.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'ordenservicio', mapping:'ordenservicio', type:'number', useNull:true},
						{name: 'cliente',mapping:'cliente', type:'string', useNull:true},
						{name: 'idcarga', mapping:'idcarga',type:'number', useNull:true},
						{name: 'tipocarga', mapping:'tipocarga',type:'string', useNull:true},
						{name: 'contenedor', mapping:'contenedor',type:'string', useNull:true},
						{name: 'tiposervicio', mapping:'tiposervicio',type:'string', useNull:true},
						{name: 'viaje', mapping:'viaje',type:'string', useNull:true},
						{name: 'estado', mapping:'estado',type:'string', useNull:true},
						{name: 'termino', mapping:'termino',type:'date', useNull:true}
					]
				})
			});
			
			var sm = new Ext.grid.CheckboxSelectionModel({
				listeners: {
					selectionchange: function(sm) {
						Ext.getCmp('facturacion-generacion').setDisabled(sm.getCount()==0);
					}
				}		
			});
			
			var grillaServicioFacturar	=new Ext.grid.GridPanel({
				id			: 'grid-servicios-sin-facturar',
				el			: 'servicios-sin-facturar', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				autoHeight	: true,
				store		: storeServicioSinFacturar,
				tbar		: new Ext.PagingToolbar({
							store		: storeServicioSinFacturar,
							displayInfo	: true,
							pageSize	: 15,
							buttons		: [
								'-',
								new Ext.form.Label({text:'Orden '}),
								new Ext.form.NumberField({ id:'ordenservicio', name:'ordenservicio', fieldLabel: 'Orden', allowBlank : false, disabled:false, width:80}),								
								'-',
								new Ext.form.Label({text:'Cliente '}),
								new capturactiva.ux.Generic.Selector({id:'cliente',name:'cliente',hiddenName:'cliente',fieldLabel:'Cliente', storeUrl:'../controller/get-selector-generic.php?sp=prc_cliente_listar',allowBlank : false, disabled:false, width:130}),
								'-',
								new Ext.form.Label({text:'Estado '}),
								new capturactiva.ux.Generic.Selector({id:'estado',name:'estado',hiddenName:'estado',fieldLabel:'Estado', storeUrl:'../controller/get-selector-generic.php?sp=prc_estadocarga_listar',allowBlank : false, disabled:false,width:130}),
								'-',
								{text	: 'Refrescar', disabled:false, handler:function(){
										storeServicioSinFacturar.load({params:{codorden:'0'+Ext.getCmp('ordenservicio').getValue(),codcliente:'0'+Ext.getCmp('cliente').getValue(),codestado:'0'+Ext.getCmp('estado').getValue(),start:0,limit: 15}});
									}
								},
								'-',
								{
									id	: 'facturacion-generacion',
									text	: 'Generar Factura', 
									disabled: true, 
									handler	: function(){
										var 	fieldsForm=[];
											
										Ext.each(Ext.getCmp('grid-servicios-sin-facturar').selModel.selections.items, function(item){
											fieldsForm.push(item.data);
										});

										var storeFacturasGenerar = new Ext.data.Store({
											url:'../controller/get-datos-factura.php',
											reader: new Ext.data.JsonReader({
												root:'data',
												totalProperty: 'total',
												id: 'id',
												remoteSort: false,
												fields: [
													{name: 'idcarga', mapping:'idcarga',type:'number', useNull:true},
													{name: 'servicio', mapping:'servicio',type:'string', useNull:true},
													{name: 'contenedor', mapping:'contenedor',type:'string', useNull:true},
													{name: 'monto', mapping:'monto',type:'number', useNull:true}
												]
											})
										});
										storeFacturasGenerar.load({params:{fieldsForm:Ext.util.JSON.encode(fieldsForm),start:0,limit: 15}});										

										new Ext.Window({
											id		: idWindow,
											title		: "Generar Factura",
											autoDestroy	: false,
											shadow		: false,
											width		: 465,
											height		: 490,
											modal		: true,
											items		: [
												new capturactiva.ux.Generic.Form({
													id			: 'generar-factura-seccion-1',
													autoHeight	: true,
													trackResetOnLoad: false,
													defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
													labelWidth	: 130,
													bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
													items		: [
														new Ext.form.NumberField({ id:'numerofactura', name:'numerofactura', fieldLabel: 'Nª Factura', allowBlank : false, disabled:false}),
														new Ext.grid.GridPanel({
															id		: 'generar-factura-seccion-2',
															title		: 'Detalle servicios',
															stripeRows	: true,
															border		: true,
															height		: 220,
															frame		: false,
															store		: storeFacturasGenerar,
															layout		: 'fit',
															style		: 'margin-bottom:10px;',
															columns :[
																{header:"ID carga",dataIndex:"idcarga", width:70, sortable:true, align:"right"},
																{header:"Servicio", dataIndex:"servicio",sortable:true},
																{header:"Nº contenedor",dataIndex:"contenedor", sortable:true},
																{header:"Monto",dataIndex:"monto", sortable:true, align:"right"}
															],
															viewConfig: {
																forceFit:true
															}
														}),
														new Ext.form.TextArea({ id:'observaciones', name:'observaciones', fieldLabel: 'Observaciones', allowBlank : true, disabled:false}),
														new Ext.form.NumberField({ id:'subtotal', name:'subtotal', fieldLabel: 'Subtotal', readOnly:true}),
														new Ext.form.NumberField({ id:'descuento', name:'descuento', fieldLabel: 'Descuento', allowBlank : true, disabled:false, value:0}),
														new Ext.form.NumberField({ id:'total', name:'total', fieldLabel: 'Total', readOnly:true})
													]
												})
											],
											buttons		: [
												{
													text	: 'Guardar', 
													id	: 'guardar-servicios-sin-facturar', 
													disabled: false, 
													handler	:function(){
														if (Ext.getCmp('generar-factura-seccion-1').getForm().isValid()){
															var 	fieldsForm=[];
																
															Ext.each(Ext.getCmp('grid-servicios-sin-facturar').selModel.selections.items, function(item){
																fieldsForm.push(item.data);
															});
																		
															Ext.Ajax.request({
																url:'../controller/save-factura.php',
																method: 'POST',
																params:{fieldsForm:Ext.util.JSON.encode(fieldsForm), numerofactura:'0'+Ext.getCmp('numerofactura').getValue(), observaciones:''+Ext.getCmp('observaciones').getValue(),descuento:'0'+Ext.getCmp('descuento').getValue()},
																success: function (form, request) {
																	messageProcess.msg('Generación factura', 'Proceso ejecutado satisfactoriamente');
																	storeServicioSinFacturar.reload();
																	
																	Ext.getCmp(idWindow).close();
																}
															});
														}
														else{
															messageProcess.msg('Generar factura', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');					
														}
													}
												},
												{text	: 'Cerrar', disabled:false, handler:function(){
														Ext.getCmp(idWindow).close();
													}
												}
											]
										}).show(Ext.getBody());
									}
								}
							]
				}),
				region:'center',
				columns :[
					sm,
					{header:"Orden servicio",dataIndex:"ordenservicio", width:70, align:"right", sortable:true},
					{header:"Cliente",dataIndex:"cliente", width:70, sortable:true},
					{header:"ID carga",dataIndex:"idcarga", width:70, sortable:true},
					{header:"Tipo carga",dataIndex:"tipocarga", sortable:true},
					{header:"Nº contenedor",dataIndex:"contenedor", sortable:true},
					{header:"Servicio", dataIndex:"tiposervicio",sortable:true},
					{header:"Viaje", dataIndex:"viaje",sortable:true},
					{header:"Estado", dataIndex:"estado",sortable:true},
					{header:"Fecha termino", dataIndex:"termino",sortable:true,renderer: Ext.util.Format.dateRenderer('d-m-Y h:i')}
				],
				sm	  : sm,
				viewConfig: {
					forceFit:true
				},
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {

					}
				}
			});

			storeServicioSinFacturar.load({params:{codorden:'0'+Ext.getCmp('ordenservicio').getValue(),codcliente:'0'+Ext.getCmp('cliente').getValue(),codestado:'0'+Ext.getCmp('estado').getValue(),start:0,limit: 15}});
			
			grillaServicioFacturar.render(); 
		});
	</script>
</div>