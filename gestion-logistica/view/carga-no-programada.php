<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<div id="carga-no-programada">
	<script type="text/javascript"> 
		var id=Ext.id();
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		
		Ext.onReady(function(){
			var showCargaNoProgramada=function(grid, rowIndex, record){
				var records=[];
				new Ext.Window({
					id		: Ext.id(),
					title		: "Programacion inicial",
					tools:[
					{
						id	: 'help',
						qtip	: 'Get Help',
						handler	: function(event, toolEl, panel){
						}
					}],
					autoDestroy	: false,
					shadow		: false,
					width		: 465,
					height		: 195,
					modal		: true,
					layout		: 'fit',
					items		: [
						new capturactiva.ux.Generic.Form({
							id		: Ext.id(),
							autoHeight	: true,
							trackResetOnLoad: false,
							defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
							labelWidth	: 130,
							bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
							autoScroll	: true,
							items		: [
								{
									xtype		: 'capturactiva.ux.Generic.DateTime',
									id		: 'fecha-programacion',
									name		: 'fecha-programacion',
									fieldLabel	: 'Fecha', 
									allowBlank 	: false, 
									disabled	: false,
									timeFormat	: 'H:i'
								},
							
								new capturactiva.ux.Generic.Selector({id:'destino',name:'destino',hiddenName:'destino',fieldLabel:'Destino', storeUrl:'../controller/get-selector-generic.php?sp=prc_destinosposibles_listar&id=0',allowBlank : false, disabled:false}),
								new capturactiva.ux.Generic.Selector({id:'transportista',name:'transportista',hiddenName:'transportista',fieldLabel:'Transportista', storeUrl:'../controller/get-selector-generic.php?sp=prc_transportista_listar',allowBlank : false, disabled:false})
							],
							buttons		: [
								{
									id	: 'programar-carga', 
									text	: 'Programar', 
									disabled: false, 
									handler	: function(){
										var thisWindow	=this.ownerCt.ownerCt.ownerCt;
										var thisForm	=this.ownerCt.ownerCt.getForm();
										if (!thisForm.isValid()){
											messageProcess.msg('Carga no programada', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');												
										}
										else{
											if (rowIndex!=null){
												records.push(grid.getStore().getAt(rowIndex).data);
											}
											else{
												records=record;
											}
											
											Ext.Ajax.request({
												url	: '../controller/save-carga-no-programada.php',
												method	: 'POST',
												params	: {id:Ext.util.JSON.encode(records), fieldsForm:Ext.util.JSON.encode(thisForm.getFieldValues())},
												success	: function (form, request){
													messageProcess.msg('Programacion', 'Informacion grabada exitosamente');
													
													grid.getStore().reload();
													
													if (Ext.isDefined(Ext.getCmp('grid-carga-programada')))
														Ext.getCmp('grid-carga-programada').getStore().reload();
													
													thisWindow.close();
														
												},
												failure : function (form, action) { }
											});				

										}
									}
								},
								{text	: 'Cerrar', disabled:false, handler:function(){
										this.ownerCt.ownerCt.ownerCt.close();
									}
								}
							]
						})
					]
				}).show(Ext.getBody());
		
			};
			
			var storeNoProgramada = new Ext.data.Store({
				url:'../controller/get-carga-no-programada.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'idcarga', mapping:'idcarga', type:'number', useNull:true},
						{name: 'fechaeta',mapping:'fechaeta', type:'date'},
						{name: 'puntocarguio', mapping:'puntocarguio',type:'string'},
						{name: 'ubicacion', mapping:'ubicacion',type:'string'},
						{name: 'destino', mapping:'destino',type:'string'},
						{name: 'nombrenave', mapping:'nombrenave',type:'string'},
						{name: 'cliente', mapping:'cliente',type:'string'},
						{name: 'numcontenedor', mapping:'numcontenedor',type:'number', useNull:true},
						{name: 'medida', mapping:'medida',type:'string'},
						{name: 'pesocarga', mapping:'pesocarga',type:'number', useNull:true},
						{name: 'condicionespecial', mapping:'condicionespecial',type:'string'},
						{name: 'operacion', mapping:'operacion',type:'string'}
					]
				})
			});
			
			var sm = new Ext.grid.CheckboxSelectionModel({
				listeners: {
					selectionchange: function(sm) {
						Ext.getCmp('paginador-programar').setDisabled(sm.getCount()==0);
					}
				}		
			});
			
			var grillaCargaNoProgramada	=new Ext.grid.GridPanel({
				id		: id + 'mantenedor.grid',
				el		: 'carga-no-programada', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				autoHeight	: true,
				store		: storeNoProgramada,
				tbar		: new Ext.PagingToolbar({
							store		: storeNoProgramada,
							displayInfo	: true,
							pageSize	: 15,
							buttons		: [
								"-",
								{
									id	: "paginador-programar",
									text	: "Programar", 
									disabled: true,
									handler	: function(){
										var fieldsForm=[]
										Ext.each(Ext.getCmp(id + 'mantenedor.grid').selModel.selections.items, function(item){
											fieldsForm.push(item.data);
										});
										
										showCargaNoProgramada(Ext.getCmp(id + 'mantenedor.grid'), null, fieldsForm);
									}
								}
							]
				}),
				region:'center',
				columns :[
					sm,
					{header:"ID carga",dataIndex:"idcarga", width:70, align:"right", sortable:true},
					{header:"ETA",dataIndex:"fechaeta", width:70, sortable:true, renderer: Ext.util.Format.dateRenderer('d-m-Y')},
					{header:"P. Carguio",dataIndex:"puntocarguio", sortable:true},
					{header:"Ubicacion",dataIndex:"ubicacion", sortable:true},
					{header:"Destino",dataIndex:"destino", sortable:true},
					{header:"Nave", dataIndex:"nombrenave",sortable:true},
					{header:"Cliente", dataIndex:"cliente",sortable:true},
					{header:"Nº contenedor", dataIndex:"numcontenedor",sortable:true},
					{header:"Medida", dataIndex:"medida",sortable:true},
					{header:"Peso", dataIndex:"pesocarga",sortable:true,useNull:true},
					{header:"C. Especial", dataIndex:"condicionespecial",sortable:true},
					{header:"Operacion", dataIndex:"operacion",sortable:true}
				],
				sm: sm,
				viewConfig: {
					forceFit:true
				},
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {
						showCargaNoProgramada(grid, rowIndex, null);
					}
				}
			});

			storeNoProgramada.load({params:{start:0,limit: 15}});
			
			grillaCargaNoProgramada.render(); 
		});
	</script>
</div>