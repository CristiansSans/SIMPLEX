<style>
	.x-form-radio{
    		vertical-align: bottom;
    		margin-bottom: 4px;
	}
	.x-form-cb-label {
		vertical-align: top;
		top: 5px;
	}
	
	.excel{
		background-image: url(../images/icon-excel.png) !important;
	}
</style>

<div id="carga-programada">
	<script type="text/javascript"> 
		var id		 =Ext.id();
		var idWindow	 =Ext.id();
		var idFormEdicion=Ext.id();
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		
		Ext.onReady(function(){
			var renderFecha = function(v,record){
		           var dt = new Date(v);
		           return dt.format('dd-mm-yyyy h:i'); 
		        };

			var storeProgramada = new Ext.data.Store({
				url:'../controller/get-carga-programada.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'car_ncorr', mapping:'car_ncorr', type:'number', useNull:true},
						{name: 'serv_dinicio',mapping:'serv_dinicio', type:'date'},//convert:renderFecha},//dateFormat: 'dddd, MMMM Do YYYY, hh:mm:ss'},
						{name: 'serv_dtermino', mapping:'serv_dtermino',type:'date'},
						{name: 'clie_vnombre', mapping:'clie_vnombre',type:'string'},
						{name: 'tise_ncorr', mapping:'tise_ncorr', type:'number', useNull:true},						
						{name: 'tise_vdescripcion', mapping:'tise_vdescripcion',type:'string'},
						{name: 'idlugarorigen', mapping:'idlugarorigen',type:'number', useNull:true},
						{name: 'descripcionlugarorigen', mapping:'descripcionlugarorigen',type:'string'},
						{name: 'idlugardestino', mapping:'idlugardestino',type:'number', useNull:true},
						{name: 'descripcionlugardestino', mapping:'descripcionlugardestino',type:'string'},
						{name: 'emp_ncorr', mapping:'emp_ncorr',type:'number', useNull:true},
						{name: 'emp_vnombre', mapping:'emp_vnombre',type:'string'},
						{name: 'cam_ncorr', mapping:'cam_ncorr',type:'number', useNull:true},
						{name: 'cam_vpatente', mapping:'cam_vpatente',type:'string'},
						{name: 'cha_ncorr', mapping:'cha_ncorr',type:'number', useNull:true},
						{name: 'cha_vpatente', mapping:'cha_vpatente',type:'string'},
						{name: 'chof_ncorr', mapping:'chof_ncorr',type:'number', useNull:true},
						{name: 'chof_vnombre', mapping:'chof_vnombre',type:'string'},
						{name: 'serv_vcelular', mapping:'serv_vcelular',type:'string'},
						{name: 'guia_ncorr', mapping:'guia_ncorr',type:'number', useNull:true},						            
						{name: 'guia_numero', mapping:'guia_numero',type:'string', useNull:true},		
						{name: 'guia_ntipo', mapping:'guia_ntipo',type:'number', useNull:true}
					]
				})
			});
			
			var sm = new Ext.grid.CheckboxSelectionModel({
				listeners: {
					selectionchange: function(sm) {
						Ext.getCmp('guia-sii').setDisabled(sm.getCount()==0);
					//	Ext.getCmp('numero-guia-sii').setDisabled(sm.getCount()==0);
						Ext.getCmp('guia-virtual').setDisabled(sm.getCount()==0);
						Ext.getCmp('generar-guia-transporte').setDisabled(sm.getCount()==0);
					}
				}		
			});
			
			var filters = new Ext.ux.grid.GridFilters({filters:[
				{type: 'date',  dataIndex: 'fecha'},
				{type: 'string',  dataIndex: 'cliente'},
				{type: 'string',  dataIndex: 'servicio'},
				{type: 'string',  dataIndex: 'estado'}
			]});

			var grillaCargaProgramada	=new Ext.grid.GridPanel({
				id		: 'grid-carga-programada',
				el		: 'carga-programada', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				autoHeight	: true,
				store		: storeProgramada,
				tbar		: new Ext.PagingToolbar({
							store		: storeProgramada,
							displayInfo	: true,
							pageSize	: 15,
							buttons		: [
								'-',
								new Ext.form.DateField({ id:'fecha-consulta', name:'fecha-consulta', fieldLabel: 'Fecha', allowBlank : false, disabled:false, value: new Date(), width:130}),
								{text	: 'Refrescar', disabled:false, handler:function(){
										storeProgramada.load({params:{fecha:Ext.getCmp('fecha-consulta').getValue(),start:0,limit: 15}});
									}
								},
								'-',
								{
									text   : 'Exportar Excel',
									iconCls: 'excel',
								},
								'-',
								new Ext.form.Radio(
									{
										id: 'guia-sii', 
										name: 'tipo-guia-transporte', 
										boxLabel:'Guia SII',
										checked: false, 
										disabled:true,
							                	onClick: function (e) {
											Ext.getCmp('numero-guia-sii').setDisabled(false);
										}										
									}
								),
								'-',
								new Ext.form.NumberField({ id:'numero-guia-sii', name:'numero-guia-sii', allowBlank : false, disabled:true}),
								'-',
								new Ext.form.Radio(
									{
										id: 'guia-virtual', 
										name: 'tipo-guia-transporte', 
										boxLabel:'Guia Virtual',
										checked: true, 
										disabled:true,
							                	onClick: function (e) {
											Ext.getCmp('numero-guia-sii').setDisabled(true);
										}										
										
									}
								),
								'-',
								{
									id	: 'generar-guia-transporte',
									text	: 'Generar guía de transporte',
									disabled: true,
									handler : function(){
										var 	fieldsForm=[],
											isGuiaSII =Ext.getCmp('guia-sii').getValue();
											
										Ext.each(Ext.getCmp('grid-carga-programada').selModel.selections.items, function(item){
											fieldsForm.push(item.data);
										});
										
										Ext.Ajax.request({
											url:'../controller/save-guia-transporte.php',
											method: 'POST',
											params:{numeroguia: (isGuiaSII ? Ext.getCmp('numero-guia-sii').getValue() : 0), fieldsForm:Ext.util.JSON.encode(fieldsForm)},
											success: function (form, request) {
												if(Ext.isEmpty(Ext.util.JSON.decode(form.responseText).data[0].mensajeerror)){
													messageProcess.msg('Generación guía', 'Proceso ejecutado satisfactoriamente');
													storeProgramada.reload();
												}
												else
													messageProcess.msg('Generación guía', Ext.util.JSON.decode(form.responseText).data[0].mensajeerror);												
/*
												Ext.Ajax.request({
													url	: '../controller/generate-guia-transporte.php',
													method	: 'POST',
													params	: {id:Ext.util.JSON.decode(form.responseText).data[0].numguiacreada},
													success	: function () {
														
													}
												});
*/												
											}
										});
									}
								},
								'-'
							]
				}),
				region:'center',
				columns :[
					sm,
					{header:"ID carga",dataIndex:"car_ncorr", width:70, align:"right", sortable:true},
					{header:"Cliente",dataIndex:"clie_vnombre", sortable:true},
					{header:"Servicio",dataIndex:"tise_vdescripcion", sortable:true},
					{header:"Inicio",dataIndex:"serv_dinicio", width:70, sortable:true,renderer: Ext.util.Format.dateRenderer('d-m-Y h:i')},
					{header:"Origen", dataIndex:"descripcionlugarorigen",sortable:true},
					{header:"Termino",dataIndex:"serv_dtermino", width:70, sortable:true,renderer: Ext.util.Format.dateRenderer('d-m-Y h:i')},
					{header:"Destino", dataIndex:"descripcionlugardestino",sortable:true},
					{header:"Transportista", dataIndex:"emp_vnombre",sortable:true},
					{header:"Patente", dataIndex:"cam_vpatente",sortable:true},
					{
						header	:"Nª Guia", dataIndex:"guia_numero",sortable:true,
						renderer: function (v, m, r) {
							if (!Ext.isEmpty(v))
								return String.format('<table><tr><td style="height:24px;vertical-align:center;"><a href="../controller/generate-guia-transporte.php?id={0}"><img src="../images/icon-pdf.png" /></a></td><td style="height:24px;vertical-align:center;"><span>{1}</span></td></tr></table>',r.data.guia_ncorr,v)
						}
					}
				],
				sm	  : sm,
				viewConfig: {
					forceFit:true
				},
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {
						record=this.getStore().getAt(rowIndex)
						record.data.tise_ncorr		= record.data.tise_ncorr==null?'':record.data.tise_ncorr;
						record.data.idlugarorigen  	= record.data.idlugarorigen==null?'':record.data.idlugarorigen;
						record.data.idlugardestino  	= record.data.idlugardestino==null?'':record.data.idlugardestino;
						record.data.emp_ncorr		= record.data.emp_ncorr==null?'':record.data.emp_ncorr;
						record.data.cam_ncorr		= record.data.cam_ncorr==null?'':record.data.cam_ncorr;
						record.data.cha_ncorr		= record.data.cha_ncorr==null?'':record.data.cha_ncorr;
						record.data.chof_ncorr		= record.data.chof_ncorr==null?'':record.data.chof_ncorr;
            console.log(record.data.emp_ncorr)
						new Ext.Window({
							id		: idWindow,
							title		: "Editar programacion ",
							tools		:[
							{
								id	:'help',
								qtip	: 'Get Help',
								handler	: function(event, toolEl, panel){
								}
							}],
							autoDestroy	: false,
							shadow		: false,
							width		: 465,
							height		: 380,
							modal		: true,
							layout		: 'fit',
							items		: [
								new capturactiva.ux.Generic.Form({
									id		: idFormEdicion,
									autoHeight	: true,
									trackResetOnLoad: false,
									defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
									labelWidth	: 130,
									bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
									autoScroll	: true,
									items		: [
										new Ext.form.NumberField({ id:'car_ncorr', name:'car_ncorr', fieldLabel: 'ID carga', allowBlank : false, disabled:true}),
										new capturactiva.ux.Generic.Selector({id:'tise_ncorr',name:'tise_ncorr',hiddenName:'tise_ncorr',fieldLabel:'Tipo servicio', storeUrl:'../controller/get-selector-generic.php?sp=prc_tiposervicio_listar',allowBlank : false, disabled:true}),
										new capturactiva.ux.Generic.Selector({id:'idlugarorigen',name:'idlugarorigen',hiddenName:'idlugarorigen',fieldLabel:'Origen', storeUrl:'../controller/get-selector-generic.php?sp=prc_lugar_listar&id=1',allowBlank : false, disabled:true}),
										
										{
											xtype		: 'capturactiva.ux.Generic.DateTime',
        										id		: 'serv_dinicio',
        										name		: 'serv_dinicio',
        										fieldLabel	: 'Fecha inicio', 
        										allowBlank 	: false, 
        										disabled	: false,
        										timeFormat	: 'H:i'
        									},
										new capturactiva.ux.Generic.Selector({id:'idlugardestino',name:'idlugardestino',hiddenName:'idlugardestino',fieldLabel:'Destino', storeUrl:'../controller/get-selector-generic.php?sp=prc_lugar_listar&id=1',allowBlank : false, disabled:false}),
										{
											xtype		: 'capturactiva.ux.Generic.DateTime',
        										id		: 'serv_dtermino',
        										name		: 'serv_dtermino',
        										fieldLabel	: 'Fecha termino', 
        										allowBlank 	: false, 
        										disabled	: false,
        										timeFormat	: 'H:i'
        									},
										new capturactiva.ux.Generic.Selector({
											id		: 'emp_ncorr',
											name		: 'emp_ncorr',
											hiddenName	: 'emp_ncorr',
											fieldLabel	: 'Transportista', 
											storeUrl	: '../controller/get-selector-generic.php?sp=prc_transportista_listar',
											allowBlank 	: false, 
											disabled	: false,
									                listeners: {
									                    select: function () {
									                        capturactiva.GLOBAL.dependencySelector(this, this.getValue(), Ext.getCmp('cam_ncorr'), "idparent", false);
									                        capturactiva.GLOBAL.dependencySelector(this, this.getValue(), Ext.getCmp('cha_ncorr'), "idparent", false);
									                    }
									                }
										}),
										new capturactiva.ux.Generic.Selector({
											id		: 'cam_ncorr',
											name		: 'cam_ncorr',
											hiddenName	: 'cam_ncorr',
											fieldLabel	: 'Patente camion', 
											storeUrl	: '../controller/get-selector-generic.php?sp=prc_camiones_listar&id='+record.data.emp_ncorr,
											allowBlank	: false, 
											disabled	: false
										}),
										new capturactiva.ux.Generic.Selector({id:'cha_ncorr',name:'cha_ncorr',hiddenName:'cha_ncorr',fieldLabel:'Patente chasis', storeUrl:'../controller/get-selector-generic.php?sp=prc_chasis_listar&id='+record.data.emp_ncorr,allowBlank : false, disabled:false}),
										new capturactiva.ux.Generic.Selector({
											id			: 'chof_ncorr',
											name		: 'chof_ncorr',
											hiddenName	: 'chof_ncorr',
											fieldLabel	: 'Conductor', 
											storeUrl	: '../controller/get-selector-generic.php?sp=prc_conductores_listar&id='+record.data.emp_ncorr,
											allowBlank 	: false, 
											disabled	: false,
									                listeners: {
												select: function () {
													Ext.Ajax.request({
														url	: '../controller/get-datos-chofer.php',
														method	: 'POST',
														params	: {id : Ext.getCmp('chof_ncorr').getValue()},
														success	: function (form, request){
															Ext.getCmp('serv_vcelular').setValue(Ext.util.JSON.decode(form.responseText).data[0].chof_vfono);
														},
														failure : function (form, action) { }
													});				
												}
									                }
										}),
										new Ext.form.TextField({ id:'serv_vcelular', name:'serv_vcelular', fieldLabel: 'Celular', allowBlank : false, disabled:false})
									],
									buttons		: [
										{text	: 'Guardar', id:'guardar-programada', disabled:false, handler:function(){
												if (!Ext.getCmp(idFormEdicion).getForm().isValid()){
													messageProcess.msg('Carga programada', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');												
												}
												else{
													var recordForm=Ext.getCmp(idFormEdicion).getForm().getFieldValues();
													recordForm["tise_ncorr"]=getValueCombobox(Ext.getCmp('tise_ncorr'));
													recordForm["idlugarorigen"]=getValueCombobox(Ext.getCmp('idlugarorigen'));
													recordForm["idlugardestino"]=getValueCombobox(Ext.getCmp('idlugardestino'));
													recordForm["emp_ncorr"]=getValueCombobox(Ext.getCmp('emp_ncorr'));
													recordForm["cam_ncorr"]=getValueCombobox(Ext.getCmp('cam_ncorr'));
													recordForm["cha_ncorr"]=getValueCombobox(Ext.getCmp('cha_ncorr'));
													recordForm["chof_ncorr"]=getValueCombobox(Ext.getCmp('chof_ncorr'));
													
													Ext.Ajax.request({
														url		: '../controller/save-carga-programada.php',
														method	: 'POST',
														params	: {id:record.data.car_ncorr, fieldsForm:Ext.util.JSON.encode(recordForm)},
														success	: function (form, request){
															messageProcess.msg('Programacion', 'Informacion grabada exitosamente');
															grid.getStore().reload();
															Ext.getCmp(idWindow).close();
														},
														failure : function (form, action) { }
													});				
												}
											}
										},
										{text	: 'Cerrar', disabled:false, handler:function(){
												Ext.getCmp(idWindow).close();
											}
										}
									]
								})
							]
						}).show(Ext.getBody());
	
						Ext.getCmp(idFormEdicion).getForm().loadRecord(record);
						
						Ext.getCmp('tise_ncorr').setValue(record.data.tise_vdescripcion);
						Ext.getCmp('idlugarorigen').setValue(record.data.descripcionlugarorigen);
						Ext.getCmp('idlugardestino').setValue(record.data.descripcionlugardestino);
						Ext.getCmp('emp_ncorr').setValue(record.data.emp_vnombre);
						Ext.getCmp('cam_ncorr').setValue(record.data.cam_vpatente);
						Ext.getCmp('cha_ncorr').setValue(record.data.cha_vpatente);
						Ext.getCmp('chof_ncorr').setValue(record.data.chof_vnombre);
					}
				},
				plugins:[
					filters
				]
			});

			//storeProgramada.load({params:{fecha:Ext.getCmp('fecha-consulta').getValue(),start:0,limit: 15}});
			storeProgramada.load();
			
			grillaCargaProgramada.render(); 
		});
	</script>
</div>