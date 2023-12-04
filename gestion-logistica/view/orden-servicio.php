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
						'		<a class="current">Orden Servicio</a>'+
						'	</article>'+
						'</div>';
						
	var northForm, westForm, westGrid, antecedentes, requerimientosTraslado, datosContenedor, cargaLibre;
	var idFormOrden=Ext.id();
	var idFormCarga=Ext.id();
	var idFormContenedor=Ext.id();
	var idFormTraslado=Ext.id();
	var idFormConsolidacion=Ext.id();	
	var idFormCargaLibre=Ext.id();
	var idFormRequerimiento=Ext.id();
	var idGridCarga=Ext.id();

	var changeStateFormFieldsAntecedentes=function(enabled){
		Ext.getCmp('esca_ncorr').setDisabled(!enabled);
		
		if (Ext.getCmp('esca_ncorr').getValue()==1){
			Ext.getCmp('esca_ncorr').setDisabled(true);
			}
		
//		Ext.getCmp('car_ncorr').setDisabled(!enabled);
		Ext.getCmp('tica_ncorr').setDisabled(!enabled);
		Ext.getCmp('car_nbooking').setDisabled(!enabled);
		Ext.getCmp('car_voperacion').setDisabled(!enabled);
		Ext.getCmp('car_vobservaciones').setDisabled(!enabled);
	}

	var changeStateFormButtonsAntecedentes=function(enabled){
		Ext.getCmp('agregar-carga').setDisabled(!enabled);
		Ext.getCmp('modificar-carga').setDisabled(!enabled);
		Ext.getCmp('eliminar-carga').setDisabled(!enabled);
		Ext.getCmp('grabar-carga').setDisabled(enabled);
		Ext.getCmp('cancelar-carga').setDisabled(enabled);
	}
	
	var changeStateFormFields=function(enabled){
		Ext.getCmp('clie_vrut').setDisabled(!enabled);
		Ext.getCmp('ose_dfechaservicio').setDisabled(!enabled);
		Ext.getCmp('tise_ncorr').setDisabled(!enabled);
		Ext.getCmp('ose_vobservaciones').setDisabled(!enabled);
		
		Ext.getCmp('clie_vrutsubcliente').setDisabled(!enabled);
		Ext.getCmp('ose_vnombrenave').setDisabled(!enabled);

		Ext.getCmp('sts_ncorr').setDisabled(!enabled);
		Ext.getCmp('lug_ncorr_origen').setDisabled(!enabled);
		Ext.getCmp('lug_ncorr_puntocarguio').setDisabled(!enabled);
		Ext.getCmp('lug_ncorr_destino').setDisabled(!enabled);
	}

	var changeStateFormButtons=function(enabled){
		Ext.getCmp('agregar-orden').setDisabled(!enabled);
		Ext.getCmp('modificar-orden').setDisabled(!enabled);
		Ext.getCmp('eliminar-orden').setDisabled(!enabled);
		Ext.getCmp('grabar-orden').setDisabled(enabled);
		Ext.getCmp('cancelar-orden').setDisabled(enabled);
	}

	Ext.onReady(function(){
		Ext.QuickTips.init();
		var hBrowser 	= (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		var usua_ncorr	= <?php echo $usua_ncorr;?>;

		Ext.fly('title-header').update('Orden Servicio'+eyeFish_BUTTONS, false);



		westForm=	new capturactiva.ux.Generic.Form({
			id			: idFormOrden,
			title		: 'Formulario',
			trackResetOnLoad: false,
			height		: 250,
			split		: true,
			collapseMode: 'mini',
			border		: false,
			frame		: false,
			flex		: 1,
			autoScroll	: true,
			bodyStyle	: 'background-color: #F1F1F4;',
			tools:[
			{
				id:'help',
				qtip: 'Get Help',
				handler: function(event, toolEl, panel){
				}
			}],
			items: [
				{
					layout		: 'column',
					bodyStyle	: 'background-color: #F1F1F4;',
					border		: false,
					items		:[
						{
							columnWidth	: .5,
							layout		: 'form',
							defaults	: {anchor:'100%', labelStyle: 'font-size:11px'},
							labelWidth	: 130,
							bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
							border		: false,
							items		: [
								new Ext.form.NumberField({id:'ose_ncorr', name:'ose_ncorr', fieldLabel: 'ID', disabled:true}),
								new capturactiva.ux.Generic.Selector({id:'clie_vrut',name:'clie_vrut',hiddenName:'clie_vrut',fieldLabel:'Cliente', storeUrl:'../controller/get-selector-generic.php?sp=prc_cliente_listar',allowBlank : false, disabled:false}),
								new capturactiva.ux.Generic.Selector({id:'tise_ncorr',name:'tise_ncorr',hiddenName:'tise_ncorr',fieldLabel:'Tipo servicio', storeUrl:'../controller/get-selector-generic.php?sp=prc_tiposervicio_listar',allowBlank : false, disabled:false}),
								new Ext.form.TextField({ id:'ose_vnombrenave', name:'ose_vnombrenave', fieldLabel: 'Nave', allowBlank : true, disabled:false}),
								new Ext.form.TextArea({ id:'ose_vobservaciones', name:'ose_vobservaciones', fieldLabel: 'Observaciones', height:70, allowBlank : true})
							]
						},
						{
							columnWidth	: .5,
							layout		: 'form',
							defaults	: {anchor:'100%', labelStyle: 'font-size:11px'},
							labelWidth	: 130,
							bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
							border		: false,
							items		: [
								new Ext.form.DateField({ id:'ose_dfechaservicio', name:'ose_dfechaservicio', fieldLabel: 'Fecha orden de servicio', allowBlank : false, disabled:false}),
								new capturactiva.ux.Generic.Selector({id:'clie_vrutsubcliente',name:'clie_vrutsubcliente',hiddenName:'clie_vrutsubcliente',fieldLabel:'Sub cliente', storeUrl:'../controller/get-selector-generic.php?sp=prc_cliente_listar',allowBlank : true, disabled:false}),
								new capturactiva.ux.Generic.Selector({id:'sts_ncorr',name:'sts_ncorr',hiddenName:'sts_ncorr',fieldLabel:'Subtipo servicio', storeUrl:'../controller/get-selector-generic.php?sp=prc_tiposervicio_listar',allowBlank : false, disabled:false}),
								new Ext.form.TextField({ id:'usua_ncorr', name:'usua_ncorr', fieldLabel: 'Vendedor', allowBlank : true, readOnly: true, value:usua_ncorr}),
								new capturactiva.ux.Generic.Selector({id:'lug_ncorr_origen',name:'lug_ncorr_origen',hiddenName:'lug_ncorr_origen',fieldLabel:'Lugar retiro', storeUrl:'../controller/get-selector-generic.php?sp=prc_lugar_listar&id=1',allowBlank : true, disabled:false}),
								new capturactiva.ux.Generic.Selector(
								{
									id:'lug_ncorr_puntocarguio',
									name:'lug_ncorr_puntocarguio',
									hiddenName:'lug_ncorr_puntocarguio',
									fieldLabel:'Puerto carguio', 
									storeUrl: '../controller/get-selector-generic.php?sp=prc_lugar_listar&id=1',
									allowBlank : true, 
									disabled:false}
								),
								//new capturactiva.ux.Generic.Selector({id:'lug_ncorr_destino',name:'lug_ncorr_destino',hiddenName:'lug_ncorr_destino',fieldLabel:'Lugar destino', storeUrl: String.format('../controller/get-lugar-destino.php?id={0}&subID={1}', Ext.getCmp('lug_ncorr_puntocarguio').getValue(),Ext.getCmp('clie_vrut').getValue()),allowBlank : true, disabled:false})
								new capturactiva.ux.Generic.Selector({id:'lug_ncorr_destino',name:'lug_ncorr_destino',hiddenName:'lug_ncorr_destino',fieldLabel:'Lugar destino', storeUrl:'../controller/get-selector-generic.php?sp=prc_lugar_listar&id=1',allowBlank : true, disabled:false}),

							]
						}
					]
				}
			],
			tbar		: [
				'->',
				'-',
				{text	: 'Agregar Orden', id:'agregar-orden', disabled:true, handler:function(){
						Ext.getCmp(idFormOrden).getForm().reset();

						Ext.getCmp(idFormCarga).getForm().reset();
						Ext.getCmp(idFormContenedor).getForm().reset();
						Ext.getCmp(idFormTraslado).getForm().reset();
//						Ext.getCmp(idFormConsolidacion).getForm().reset();
						Ext.getCmp(idFormCargaLibre).getForm().reset();
						Ext.getCmp(idFormRequerimiento).getForm().reset();
						
						Ext.getCmp(idGridCarga).store.load();
						
						changeStateFormButtons(false);
						changeStateFormFields(true);
					}
				},
				'-',
				{text	: 'Modificar Orden', id:'modificar-orden', disabled:true, handler:function(){
						changeStateFormButtons(false);
						changeStateFormFields(true);
					}
				},
				'-',
				{text	: 'Eliminar Orden', id:'eliminar-orden', disabled:true},
				'-',
				{text	: 'Grabar', id:'grabar-orden', disabled:false, handler:function(){
						if (Ext.getCmp(idFormOrden).getForm().isValid()){
							Ext.Ajax.request({
								url		: '../controller/save-orden-servicio.php',
								method	: 'POST',
								params	: {id:'0'+Ext.getCmp('ose_ncorr').getValue(), fieldsForm:Ext.util.JSON.encode(Ext.getCmp(idFormOrden).getForm().getFieldValues())},
								success	: function (form, request){
									messageProcess.msg('Orden Servicio', 'Informacion grabada exitosamente');
									Ext.getCmp('ose_ncorr').setValue(Ext.util.JSON.decode(form.responseText).data[0].ose_ncorr);

									changeStateFormButtons(false);

									Ext.getCmp('agregar-carga').setDisabled(false);
								},
								failure : function (form, action) { }
							});				
						}
						else
							messageProcess.msg('Orden Servicio', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');
					}
				},
				'-',
				{text	: 'Cancelar', id:'cancelar-orden', disabled:false, handler:function(){
						Ext.getCmp('agregar-orden').setDisabled(false);
						Ext.getCmp('modificar-orden').setDisabled(Ext.getCmp('ose_ncorr').getValue()=='');
						Ext.getCmp('eliminar-orden').setDisabled(Ext.getCmp('ose_ncorr').getValue()=='');
						Ext.getCmp('grabar-orden').setDisabled(true);
						Ext.getCmp('cancelar-orden').setDisabled(true);
				
						changeStateFormFields(false);
					}
				},
				'-'
			]
		});

		var storeHeader = new Ext.data.Store({
			url:'../controller/get-orden-servicio-header.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				remoteSort: false,
				fields: [
					{name: 'ose_ncorr', mapping:'ose_ncorr', type:'number'},
					{name: 'ose_dfechaservicio', mapping:'ose_dfechaservicio',type:'date'},					
					{name: 'ose_vnombrenave', mapping:'ose_vnombrenave',type:'string',useNull:true},					
					{name: 'ose_vobservaciones', mapping:'ose_vobservaciones',type:'string',useNull:true},					
					{name: 'clie_vrutsubcliente',mapping:'clie_vrutsubcliente', type:'number',useNull:true},					
					{name: 'sts_ncorr', mapping:'sts_ncorr',type:'number',useNull:true},
					{name: 'lug_ncorr_destino', mapping:'lug_ncorrdestino',type:'number',useNull:true},					
					{name: 'lug_ncorr_puntocarguio', mapping:'lug_ncorr_puntocarguio',type:'number',useNull:true},					
					{name: 'nav_ncorr', mapping:'nav_ncorr',type:'number',useNull:true},					
					{name: 'usua_ncorr', mapping:'usua_ncorr',type:'number',useNull:true},					
					{name: 'tise_ncorr', mapping:'tise_ncorr',type:'number',useNull:true},					
					{name: 'lug_ncorr_origen', mapping:'lug_ncorrorigen',type:'number',useNull:true},					
					{name: 'via_ncorr', mapping:'via_ncorr',type:'number',useNull:true},					
					{name: 'clie_vnombresubcliente',mapping:'clie_vnombresubcliente', type:'string'},					
					{name: 'clie_vrut', mapping:'clie_vrut',type:'number',useNull:true},					
					{name: 'clie_vnombre',mapping:'clie_vnombre', type:'string'},					
					{name: 'tise_ncorr', mapping:'tise_ncorr',type:'number',useNull:true},					
					{name: 'tise_vdescripcion',mapping:'tise_vdescripcion', type:'string'},					
					{name: 'lug_ncorr', mapping:'lug_ncorr',type:'number',useNull:true},					
					{name: 'lug_vnombre',mapping:'lug_vnombre', type:'string'}				
				]
			}),
			listeners: {
				load:function (store,records,options) {
					record=store.getAt(0);

					record.data.clie_vrutsubcliente = record.data.clie_vrutsubcliente==null?'':record.data.clie_vrutsubcliente;
					record.data.lug_ncorr_origen= record.data.lug_ncorr_origen==null?'':record.data.lug_ncorr_origen;
					record.data.via_ncorr = record.data.via_ncorr==null?'':record.data.via_ncorr;					
					record.data.sts_ncorr = record.data.sts_ncorr==null?'':record.data.sts_ncorr;					
					record.data.lug_ncorr_puntocarguio = record.data.lug_ncorr_puntocarguio==null?'':record.data.lug_ncorr_puntocarguio;
					record.data.lug_ncorr_destino= record.data.lug_ncorr_destino==null?'':record.data.lug_ncorr_destino;

					Ext.getCmp(idFormOrden).getForm().loadRecord(record);
					
					Ext.getCmp('agregar-carga').setDisabled(record.length==0);
				}
			}
		});
		storeHeader.load({params:{id:<?php echo($id);?>}});

		var storeCarga = new Ext.data.Store({
			url:'../controller/get-detalle-orden-servicio.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				remoteSort: false,
				fields: [
					{name: 'car_ncorr',type:'number', useNull:true},
					{name: 'car_nbooking', type:'string', useNull:true},
					{name: 'car_voperacion',type:'string', useNull:true},
					{name: 'car_vcontenidocarga', type:'string', useNull:true},
					{name: 'car_ndiascontenedor', type:'number', useNull:true},
					{name: 'car_vmarca', type:'string', useNull:true},
					{name: 'car_npesocarga', type:'number', useNull:true},
					{name: 'car_vobservaciones', type:'string', useNull:true},
					{name: 'tica_ncorr',type:'number', useNull:true},
					{name: 'tica_vdescripcion',type:'string', useNull:true},
					{name: 'tico_ncorr', type:'number', useNull:true},
					{name: 'tico_vdescripcion',type:'string', useNull:true},
					{name: 'esca_ncorr',    type:'number', useNull:true},
					{name: 'esca_vdescripcion',type:'string', useNull:true},
					{name: 'ada_ncorr', type:'number', useNull:true},
					{name: 'ada_vnombre',type:'string', useNull:true},
					{name: 'cada_ncorr', type:'number', useNull:true},
					{name: 'cont_vmarca', type:'string', useNull:true},
					{name: 'cont_vnumcontenedor',type:'string', useNull:true},
					{name: 'cont_vcontenido', type:'string', useNull:true},
					{name: 'cont_dterminostacking', type:'date', useNull:true},
					{name: 'cont_ndiaslibres', type:'number', useNull:true},
					{name: 'cont_vsello', type:'string', useNull:true},
					{name: 'lug_ncorr_devolucion',type:'number', useNull:true},
					{name: 'cont_npeso', type:'number', useNull:true},
					{name: 'med_ncorr', type:'number', useNull:true},
					{name: 'cond_ncorr', type:'number', useNull:true},
					{name: 'lug_ncorr_destino', type:'number', useNull:true},
					{name: 'lug_ncorr_retiro', type:'number', useNull:true},
					{name: 'car_dfecharetiro', type:'date', useNull:true},
					{name: 'car_dfechapresentacion', type:'date', useNull:true},
					{name: 'car_vcontactoentrega',type:'string', useNull:true},
					{name: 'car_vcontactocons', type:'string', useNull:true},
					{name: 'car_dfechacons', type:'date', useNull:true},
					{name: 'lug_ncorr_consolidacion',type:'number', useNull:true},
					{name: 'car_ntemperatura', type:'number', useNull:true},
					{name: 'car_nventilacion',type:'number', useNull:true},
					{name: 'car_vadic_otros',type:'string', useNull:true},
					{name: 'car_vadic_obs',type:'string', useNull:true},
					{name: 'car_ncantidad', type:'number', useNull:true},
					{name: 'um_ncorr', type:'number', useNull:true},
					{name: 'fact_ncorr',type:'number', useNull:true},
					{name: 'carlibre_um',type:'number', useNull:true},
					{name: 'carlibre_cantidad',type:'number', useNull:true}					
				]
			})
		});
		storeCarga.load({params:{id:<?php echo($id);?>, start:0,limit: 15}});

		var sm = new Ext.grid.CheckboxSelectionModel({
			listeners: {
				selectionchange: function(sm) {
					Ext.getCmp('modificar-carga').setDisabled(sm.getCount()==0);
					Ext.getCmp('eliminar-carga').setDisabled(sm.getCount()==0);
				}
			}		
		});

		westGrid=	new Ext.grid.GridPanel({
			id			: idGridCarga,
			title		: 'Resumen',
			stripeRows	: true,
			border		: false,
			flex		: 1,
			frame		: false,
			store		: storeCarga,
			layout		: 'fit',
			tbar		: new Ext.PagingToolbar({
				store 		: storeCarga,
				displayInfo	: true,
				pageSize	: 15,
				buttons		:[					
					'->',					
					'-',					
					{						
						text	: 'Importar Detalle',						
						icon	: '../images/doc-import-16x16.png',						
						id		: 'upload-file'					
					},					
					'-',					
					{						
						text	: 'Agregar Carga',						
						id		: 'agregar-carga',						
						disabled: true, 						
						handler	: function(){							
							Ext.getCmp(idFormCarga).getForm().reset();							
							Ext.getCmp(idFormContenedor).setDisabled(true);							
							Ext.getCmp(idFormTraslado).setDisabled(true);							
//							Ext.getCmp(idFormConsolidacion).setDisabled(true);
							Ext.getCmp(idFormCargaLibre).setDisabled(true);						
							Ext.getCmp(idFormRequerimiento).setDisabled(true);

							Ext.getCmp('esca_ncorr').setValue(1);
							Ext.getCmp('esca_ncorr').setDisabled(true);
							
							changeStateFormButtonsAntecedentes(false);							
							changeStateFormFieldsAntecedentes(true);						
						}					
					},					
					'-',					
					{						
						text	: 'Modificar Carga',						
						id		: 'modificar-carga',						
						disabled: true, 						
						handler	: function(){							
							changeStateFormButtonsAntecedentes(false);							
							changeStateFormFieldsAntecedentes(true);						
						}					
					},					
					'-',					
					{						
						text	: 'Eliminar Carga',						
						id		: 'eliminar-carga',						
						disabled: true,						
						handler : function(){
							Ext.MessageBox.show({
								title:'Eliminar registros?',								
								msg: 'Confirma la eliminacion de los registro(s) seleccionado(s)',								
								buttons: Ext.MessageBox.YESNOCANCEL,								
								fn: function(button){									
									if(button=='yes'){										
										var fieldsForm=[];										
										Ext.each(Ext.getCmp(idGridCarga).selModel.selections.items, function(item){											
											//fieldsForm.push(item.data);
											//console.log(item.data)
																														
											Ext.Ajax.request({											
												url:'../controller/delete-detalle-carga.php',											
												method: 'POST',											
												params:{id:item.data.car_ncorr},											
												success: function () {												
													Ext.getCmp(idGridCarga).store.reload();											
												}										
											});
										});
									}								
								},								
								icon: Ext.MessageBox.QUESTION							
							});						
						}					
					},					
					'-'				
				]
			}),
			columns 	:[
					sm,
					{header:"ID",dataIndex:"car_ncorr", width:40, align:"right", sortable:true},
					{header:"Estado",dataIndex:"esca_vdescripcion", sortable:true},
					{header:"Cantidad",dataIndex:"car_ncantidad", sortable:true},
					{header:"Tipo",dataIndex:"tica_vdescripcion", sortable:true},
					{header:"Peso", dataIndex:"car_npesocarga",sortable:true},
					{header:"Nº Book", dataIndex:"car_nbooking",sortable:true},
					{header:"A.G.A.", dataIndex:"ada_vnombre",sortable:true}
			],
			sm: sm,
			viewConfig: {
				forceFit:true
			},
			listeners: {
				rowclick 	: function(grid,rowIndex,e){
					record=storeCarga.getAt(rowIndex);

					record.data.cont_vmarca= record.data.cont_vmarca==null?'':record.data.cont_vmarca;
					record.data.cont_vnumcontenedor= record.data.cont_vnumcontenedor==null?'':record.data.cont_vnumcontenedor;
					record.data.cont_vcontenido= record.data.cont_vcontenido==null?'':record.data.cont_vcontenido;
					record.data.cont_dterminostacking= record.data.cont_dterminostacking==null?'':record.data.cont_dterminostacking;
					record.data.lug_ncorr_devolucion= record.data.lug_ncorr_devolucion==null?'':record.data.lug_ncorr_devolucion;
					
					record.data.cont_vsello= record.data.cont_vsello==null?'':record.data.cont_vsello;
					record.data.ada_ncorr= record.data.ada_ncorr==null?'':record.data.ada_ncorr;
					record.data.cont_ndiaslibres= record.data.cont_ndiaslibres==null?'':record.data.cont_ndiaslibres;

					record.data.cada_ncorr= record.data.cada_ncorr==null?'':record.data.cada_ncorr;
					record.data.cont_npeso= record.data.cont_npeso==null?'':record.data.cont_npeso;
					record.data.med_ncorr= record.data.med_ncorr==null?'':record.data.med_ncorr;
					record.data.cond_ncorr= record.data.cond_ncorr==null?'':record.data.cond_ncorr;

					record.data.car_dfecharetiro= record.data.car_dfecharetiro==null?'':record.data.car_dfecharetiro;
					record.data.car_dfechapresentacion= record.data.car_dfechapresentacion==null?'':record.data.car_dfechapresentacion;
					record.data.car_vcontactoentrega= record.data.car_vcontactoentrega==null?'':record.data.car_vcontactoentrega;

					record.data.carlibre_cantidad= record.data.carlibre_cantidad==null?'':record.data.carlibre_cantidad;					record.data.carlibre_cantidad= record.data.carlibre_cantidad==null?'':record.data.carlibre_cantidad;
					record.data.carlibre_um= record.data.carlibre_um==null?'':record.data.carlibre_um;					
					
					
					
					Ext.getCmp(idFormCarga).getForm().loadRecord(record);
					Ext.getCmp(idFormContenedor).getForm().loadRecord(record);
					Ext.getCmp(idFormTraslado).getForm().loadRecord(record);
					Ext.getCmp(idFormCargaLibre).getForm().loadRecord(record);
					Ext.getCmp(idFormRequerimiento).getForm().loadRecord(record);
					
					Ext.getCmp(idFormContenedor).setDisabled(false);
					Ext.getCmp(idFormTraslado).setDisabled(false);
//					Ext.getCmp(idFormConsolidacion).setDisabled(false);
					Ext.getCmp(idFormCargaLibre).setDisabled(false);	
					Ext.getCmp(idFormRequerimiento).setDisabled(false);

					if (record.data.esca_ncorr==1){
						Ext.getCmp('eliminar-carga').setDisabled(false);
					
					}
					else{
						Ext.getCmp('eliminar-carga').setDisabled(true);
					}
				},
				rowdblclick	: function(grid, rowIndex, e) {
					changeStateFormButtonsAntecedentes(false);
					changeStateFormFieldsAntecedentes(true);
				}
			}
		});

		var westPanel =	new Ext.Panel({
			layout			: {
				type	: 'vbox',
				align	: 'stretch',
				pack  	: 'start'
			},
		
			region		: 'west',
			height		: '100%',
			width		: '65%',
			split		: true, 
			collapseMode: 'mini', 
			items		: [westForm, westGrid]
		});

		antecedentes=	new capturactiva.ux.Generic.Form({
			id			: idFormCarga,
			title		: 'Antecedentes',
			autoHeight	: false,
			trackResetOnLoad: false,
			defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
			labelWidth	: 130,
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
			autoScroll	: true,
			tools:[
			{
				id:'help',
				qtip: 'Get Help',
				handler: function(event, toolEl, panel){
				}
			}],
			items		: [
				new Ext.form.NumberField({ id:'car_ncorr', name:'car_ncorr', fieldLabel: 'ID', allowBlank : true, disabled:true}),
				new capturactiva.ux.Generic.Selector({id:'esca_ncorr',name:'esca_ncorr',hiddenName:'esca_ncorr',fieldLabel:'Estado', storeUrl:'../controller/get-selector-generic.php?sp=prc_estadocarga_listar',allowBlank : false, disabled:true}),
				new capturactiva.ux.Generic.Selector({id:'tica_ncorr',name:'tica_ncorr',hiddenName:'tica_ncorr',fieldLabel:'Tipo carga', storeUrl:'../controller/get-selector-generic.php?sp=prc_tipocarga_listar',allowBlank : false, disabled:true}),
				new Ext.form.TextField({ id:'car_nbooking', name:'car_nbooking', fieldLabel: 'N° booking', allowBlank : false, disabled:true}),				
				new Ext.form.TextField({ id:'car_voperacion', name:'car_voperacion', fieldLabel: 'N° operacion', allowBlank : false, disabled:true}),
				new Ext.form.TextArea({ id:'car_vobservaciones', name:'car_vobservaciones', fieldLabel: 'Observaciones', allowBlank : true, disabled:true})
			]
		});

		datosContenedor=	new capturactiva.ux.Generic.Form({
			id			: idFormContenedor,
			title		: 'Datos contenedor',
			autoHeight	: false,
			trackResetOnLoad: false,
			defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
			labelWidth	: 130,
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
			autoScroll	: true,
			disabled	: true,
			items		: [
				new Ext.form.TextField({ id:'cont_vmarca', name:'cont_vmarca', fieldLabel: 'Marca contenedor', allowBlank : true, disabled:false}),
				new Ext.form.TextField({ id:'cont_vnumcontenedor', name:'cont_vnumcontenedor', fieldLabel: 'N° contenedor', allowBlank : false, disabled:false,
					monitorValid: true,
					validator	: function(value) {
						var resultsISO9636=validaISO9636(value);
						if (resultsISO9636.error)
							return resultsISO9636.description
						else
							return true;
					}
				}),
				new Ext.form.TextArea({ id:'cont_vcontenido', name:'cont_vcontenido', fieldLabel: 'Contenido', allowBlank : true}),
				new Ext.form.DateField({ id:'cont_dterminostacking', name:'cont_dterminostacking', fieldLabel: 'Termino stacking', allowBlank : true, disabled:false}),
				new capturactiva.ux.Generic.Selector({id:'lug_ncorr_devolucion',name:'lug_ncorr_devolucion',hiddenName:'lug_ncorr_devolucion',fieldLabel:'Lugar devolucion', storeUrl:'../controller/get-selector-generic.php?sp=prc_lugar_listar&id=1',allowBlank : true, disabled:false}),
				new Ext.form.TextField({ id:'cont_vsello', name:'cont_vsello', fieldLabel: 'Sello', allowBlank : false, disabled:false}),				
				new capturactiva.ux.Generic.Selector({id:'ada_ncorr',name:'ada_ncorr',hiddenName:'ada_ncorr',fieldLabel:'Agencia aduana', storeUrl:'../controller/get-selector-generic.php?sp=prc_agenciaaduana_listar',allowBlank : false, disabled:true}),				
				new Ext.form.NumberField({ id:'cont_ndiaslibres', name:'cont_ndiaslibres', fieldLabel: 'Dias libres', allowBlank : true, disabled:false}),

				new capturactiva.ux.Generic.Selector({id:'cada_ncorr',name:'cada_ncorr',hiddenName:'cada_ncorr',fieldLabel:'Contacto agencia', storeUrl:'../controller/get-selector-generic.php?sp=prc_contactoagencia_listar&id=0',allowBlank : false, disabled:true}),				
				new Ext.form.NumberField({ id:'cont_npeso', name:'cont_npeso', fieldLabel: 'Peso carga', allowBlank : false, disabled:true}),				
				new capturactiva.ux.Generic.Selector({id:'med_ncorr',name:'med_ncorr',hiddenName:'med_ncorr',fieldLabel:'Medidas contenedor', storeUrl:'../controller/get-selector-generic.php?sp=prc_medidacontenedor_listar',allowBlank : false, disabled:true}),				
				new capturactiva.ux.Generic.Selector({id:'cond_ncorr',name:'cond_ncorr',hiddenName:'cond_ncorr',fieldLabel:'Condicion especial', storeUrl:'../controller/get-selector-generic.php?sp=prc_condicionespecial_listar',allowBlank : true, disabled:true})			
			]
		});

		var datosTraslado=	new capturactiva.ux.Generic.Form({
			id			: idFormTraslado,
			title		: 'Datos traslado',
			autoHeight	: false,
			trackResetOnLoad: false,
			defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
			labelWidth	: 130,
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
			autoScroll	: true,
			disabled	: true,
			items		: [
				new Ext.form.DateField({ id:'car_dfecharetiro', name:'car_dfecharetiro', fieldLabel: 'Fecha retiro', allowBlank : false, disabled:false}),
				new Ext.form.DateField({ id:'car_dfechapresentacion', name:'car_dfechapresentacion', fieldLabel: 'Fecha presentacion', allowBlank : false, disabled:false}),
				new Ext.form.TextField({ id:'car_vcontactoentrega', name:'car_vcontactoentrega', fieldLabel: 'Contacto entrega', allowBlank : true, disabled:false})
			]
		});

		cargaLibre=	new capturactiva.ux.Generic.Form({			
			id		: idFormCargaLibre,			
			title		: 'Carga libre',			
			autoHeight	: false,			
			trackResetOnLoad: false,			
			defaults	: {
				anchor:'99.5%', 
				labelStyle: 'font-size:11px'
			},			
			labelWidth	: 130,			
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',			
			autoScroll	: true,			
			disabled	: true,			
			items		: [				
				new Ext.form.NumberField({id:'carlibre_cantidad', name:'carlibre_cantidad', fieldLabel: 'Cantidad', allowBlank : false, disabled:true}),				
				new capturactiva.ux.Generic.Selector({id:'carlibre_um',name:'carlibre_um',hiddenName:'carlibre_um',fieldLabel:'Unidad medida', storeUrl:'../controller/get-selector-generic.php?sp=prc_unidadmedida_listar',allowBlank : false, disabled:true})			
			]		
		});		
		
		requerimientosTraslado=	new capturactiva.ux.Generic.Form({
			id			: idFormRequerimiento,
			title		: 'Requerimientos traslado',
			autoHeight	: false,
			trackResetOnLoad: false,
			defaults	: {anchor:'99.5%', labelStyle: 'font-size:11px'},
			labelWidth	: 130,
			bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
			autoScroll	: true,
			disabled	: true,
			items		: [
				new Ext.form.NumberField({ id:'car_ntemperatura', name:'car_ntemperatura', fieldLabel: 'Temperatura °C', allowBlank : true, disabled:false}),
				new Ext.form.NumberField({ id:'car_nventilacion', name:'car_nventilacion', fieldLabel: 'Ventilacion %', allowBlank : true, disabled:false}),				
				new Ext.form.TextArea({ id:'car_vadic_otros', name:'car_vadic_otros', fieldLabel: 'Otros', height:70, allowBlank : true}),				
				new Ext.form.TextArea({ id:'car_vadic_obs', name:'car_vadic_obs', fieldLabel: 'Observaciones', height:70, allowBlank : true})
			]
		});

		var centerAntecedentes=	new Ext.Panel({
			layout			: 'accordion',
			region			: 'center',
			items			: [ antecedentes, datosContenedor, datosTraslado, cargaLibre, requerimientosTraslado],
			bbar		: [
				'->',
				'-',
				{text	: 'Grabar', id:'grabar-carga', disabled:true, handler:function(){
						if (Ext.getCmp(idFormCarga).getForm().isValid()){
							Ext.Ajax.request({
								url		: '../controller/save-detalle-orden-servicio.php',
								method	: 'POST',
								params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), sub_id:'0'+Ext.getCmp('ose_ncorr').getValue(), esca_ncorr:Ext.getCmp('esca_ncorr').getValue(),fieldsForm:Ext.util.JSON.encode(Ext.getCmp(idFormCarga).getForm().getFieldValues())},
								success	: function (form, request){
									messageProcess.msg('Detalle Orden Servicio', 'Informacion grabado exitosamente');
									Ext.getCmp('car_ncorr').setValue(Ext.util.JSON.decode(form.responseText).data[0].car_ncorr);

									if (Ext.getCmp(idFormContenedor).getForm().isValid()){
										Ext.Ajax.request({
											url		: '../controller/save-detalle-contenedor.php',
											method	: 'POST',
											params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), sub_id:'0'+Ext.getCmp('ose_ncorr').getValue(), fieldsForm:Ext.util.JSON.encode(Ext.getCmp(idFormContenedor).getForm().getFieldValues())},
											success	: function (form, request){
												messageProcess.msg('Detalle Contenedor', 'Informacion grabado exitosamente');
											},
											failure : function (form, action) { }
										});				
									}
									else
										messageProcess.msg('Detalle Contenedor', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');

									if (Ext.getCmp(idFormTraslado).getForm().isValid()){
										Ext.Ajax.request({
											url		: '../controller/save-detalle-traslado.php',
											method	: 'POST',
											params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.util.JSON.encode(Ext.getCmp(idFormTraslado).getForm().getFieldValues())},
											success	: function (form, request){
												messageProcess.msg('Detalle Traslado', 'Informacion grabado exitosamente');
											},
											failure : function (form, action) { }
										});				
									}
									else
										messageProcess.msg('Detalle Traslado', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');

									if (Ext.getCmp(idFormCargaLibre).getForm().isValid()){							
										Ext.Ajax.request({								
											url		: '../controller/save-detalle-cargalibre.php',								
											method	: 'POST',								
											params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.util.JSON.encode(Ext.getCmp(idFormCargaLibre).getForm().getFieldValues())},								
											success	: function (form, request){									
												messageProcess.msg('Carga Libre', 'Informacion grabado exitosamente');								
											},								
											failure : function (form, action) { }							
										});										
									}						
									else							
										messageProcess.msg('Carga Libre', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');					

									if (Ext.getCmp(idFormRequerimiento).getForm().isValid()){
										Ext.Ajax.request({
											url		: '../controller/save-detalle-requerimiento.php',
											method	: 'POST',
											params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.util.JSON.encode(Ext.getCmp(idFormRequerimiento).getForm().getFieldValues())},
											success	: function (form, request){
												messageProcess.msg('Detalle Requerimiento', 'Informacion grabado exitosamente');
											},
											failure : function (form, action) { }
										});				
									}
									else
										messageProcess.msg('Detalle Requerimiento', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');
																					
									storeCarga.load({params:{id:Ext.getCmp('ose_ncorr').getValue(), start:0,limit: 15}});

									changeStateFormButtonsAntecedentes(true);
									changeStateFormFieldsAntecedentes(false);
								},
								failure : function (form, action) { }
							});				
						}
						else
							messageProcess.msg('Detalle Orden Servicio', 'Algunos datos son obligatorios o poseen una regla de validacion que no se ha cumplido, favor verifique y re-ingrese');
						}
				},
				'-',
				{text	: 'Cancelar', id:'cancelar-carga', disabled:true, handler:function(){
						Ext.getCmp('agregar-carga').setDisabled(false);
						Ext.getCmp('grabar-carga').setDisabled(true);
						Ext.getCmp('cancelar-carga').setDisabled(true);
				
						changeStateFormFieldsAntecedentes(false);
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
			items		: [westPanel,centerAntecedentes]
		});
		
		upclick({
			element	: document.getElementById('upload-file'),
			action	: '../controller/upload-file.php',
			onstart	:function(filename){
				messageProcess.msg('Importacion', 'Cargando archivo:'+filename);
			},
			oncomplete:function(response_data){
				messageProcess.msg('Importacion', 'Importacion completa:'+response_data);
				
				jsonData=Ext.util.JSON.decode(response_data);

				Ext.Ajax.request({
					url	: '../controller/importacion-carga-txt.php',
					method	: 'POST',
					params	: {file: String.format('../upload-files-carga/{0}',jsonData.file)},
					success	: function (form, request){
						console.log("form.responseText:",form.responseText);

					},
					failure : function (form, action) {
						console.log("Error:",form.responseText);
					 }
				});				
			}
		});					
		
		
	});
</script>