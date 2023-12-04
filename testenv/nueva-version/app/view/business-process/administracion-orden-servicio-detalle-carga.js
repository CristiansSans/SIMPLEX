Ext.define('simplex.view.business-process.administracion-orden-servicio-detalle-carga', {
    extend	: 'Ext.Panel',
	alias	: 'widget.administracion-orden-servicio-detalle-carga',
    layout	: 'fit',
	itemId	: 'administracion-orden-servicio-detalle-carga',
	
	initComponent: function() {
 		Ext.define('model-administracion-orden-servicio-detalle-carga', {
			extend: 'Ext.data.Model',
			fields: [
					{name: 'car_ncorr',type:'number', useNull:true},
					{name: 'car_nbooking', type:'string', useNull:true},
					{name: 'car_voperacion',type:'string', useNull:true},
					{name: 'car_vcontenidocarga', type:'string', useNull:true},
					{name: 'car_ndiascontenedor', type:'number', useNull:true},
					{name: 'car_vmarca', type:'string', useNull:true},
					{name: 'car_npesocarga', type:'string', useNull:true},
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
		});

		Ext.create('Ext.data.Store', {
			storeId		: 'store-administracion-orden-servicio-detalle-carga',
			model		: 'model-administracion-orden-servicio-detalle-carga',
			autoLoad	: true,
			remoteSort	: false,
			proxy 		: {
				type			: 'ajax',
				actionMethods	: 'POST',
				url 			: 'server/view/get-ordenserviciodetallecarga.php',
				reader 			: {
					type			: 'json',
					root 			: 'data',
					totalProperty	: 'total'
				},
				simpleSortMode : true
			}
		});

		this.items = [
			Ext.create('Ext.grid.Panel', {
				frame		: false,
				store		: 'store-administracion-orden-servicio-detalle-carga',
				layout		: 'fit',
				resizable	: false,
				border		: false,
				// bbar		: Ext.create('Ext.PagingToolbar', {
					// store		: 'store-administracion-orden-servicio-detalle-carga',
					// displayInfo	: true
				// }),
				buttons		: [
					{
						text	: 'Agregar Carga',
						id		: 'agregar-carga',
						disabled:true,
						handler	: function(){
							Ext.getCmp('administracion-orden-servicio-ingreso-carga').setDisabled(false);
							Ext.getCmp('administracion-orden-servicio-antecedentes').getForm().reset();
							Ext.getCmp('administracion-orden-servicio-datos-contenedor').getForm().reset();
							Ext.getCmp('administracion-orden-servicio-datos-traslado').getForm().reset();
							Ext.getCmp('administracion-orden-servicio-carga-libre').getForm().reset();
							Ext.getCmp('administracion-orden-servicio-requerimiento-traslado').getForm().reset();
						}
					},
					{
						text	: 'Modificar Carga', 
						id		: 'modificar-carga',
						disabled: true,
						handler	: function(){
							Ext.getCmp('administracion-orden-servicio-ingreso-carga').setDisabled(false);
						}
					},
					{text	: 'Eliminar Carga', disabled:true}
				],
				enableRowHeightSync: true,
				viewConfig: {
					stripeRows: true,
					forceFit: true,
				},
				listeners: {
					afterrender : function(panel) {
//						Ext.fly('panel-title').update(	'<p><b>Task List</b></p>'+
//														'<p>Permite administrar un proyecto de portada para visualizarlo en el sitio principal</p>',
//														false);
					},
					
					beforerender : function(cmp,eOpt){
						cmp.headerCt.setHeight(30);
						
					},

					itemclick	: function( grid, record, item, index, event){
						Ext.getCmp('administracion-orden-servicio-antecedentes').getForm().loadRecord(record);
						Ext.getCmp('administracion-orden-servicio-datos-contenedor').getForm().loadRecord(record);
						Ext.getCmp('administracion-orden-servicio-datos-traslado').getForm().loadRecord(record);
						Ext.getCmp('administracion-orden-servicio-carga-libre').getForm().loadRecord(record);
						Ext.getCmp('administracion-orden-servicio-requerimiento-traslado').getForm().loadRecord(record);
						
						Ext.getCmp('agregar-carga').setDisabled(false);
						Ext.getCmp('modificar-carga').setDisabled(false);
					}
				},
				columns: [
					{text:"ID",dataIndex:"car_ncorr", flex:1, width:40, align:"right", sortable:true},
					{text:"Estado",dataIndex:"esca_vdescripcion",  flex:1, sortable:true},
					{text:"Cantidad",dataIndex:"car_ncantidad",  flex:1, sortable:true},
					{text:"Tipo",dataIndex:"tica_vdescripcion",  flex:1, sortable:true},
					{text:"Peso", dataIndex:"car_npesocarga", flex:1, sortable:true},
					{text:"N&deg; Book", dataIndex:"car_nbooking", flex:1, sortable:true},
					{text:"A.G.A.", dataIndex:"ada_vnombre", flex:1, sortable:true}
				]
			})
		];
		this.callParent();
    }
});