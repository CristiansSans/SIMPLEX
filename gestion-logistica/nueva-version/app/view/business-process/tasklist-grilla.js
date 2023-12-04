Ext.define('simplex.view.business-process.tasklist-detalle-orden', {
    extend	: 'Ext.Panel',
	alias	: 'widget.tasklist',
	closable: false,  
	//title   : 'Task List',
    layout	: 'fit',
	itemId	: 'tasklist',
	
	initComponent: function() {
 		Ext.define('model-tasklist', {
			extend: 'Ext.data.Model',
			fields: [
				{name: 'id-solicitud', mapping:'ose_ncorr', type:'number'},
				{name: 'fecha',mapping:'ose_dfechaservicio', type:'date'},
				{name: 'cliente', mapping:'clie_vnombre',type:'string'},
				{name: 'servicio', mapping:'tise_vdescripcion',type:'string'},
				{name: 'items', mapping:'items',type:'string'},
				{name: 'estado', mapping:'esca_vdescripcion',type:'string'}
			]
		});

		Ext.create('Ext.data.Store', {
			storeId		: 'store-tasklist',
			model		: 'model-tasklist',
			autoLoad	: true,
			remoteSort	: false,
			proxy 		: {
				type			: 'ajax',
				actionMethods	: 'POST',
				url 			: 'server/view/get-tasklist.php',
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
				store		: 'store-tasklist',
				layout		: 'fit',
				resizable	: false,
				border		: false,
				bbar		: Ext.create('Ext.PagingToolbar', {
					store		: 'store-tasklist',
					displayInfo	: true
				}),
				enableRowHeightSync: true,
				viewConfig: {
					stripeRows: true,
					forceFit: true,
				},
				listeners: {
					afterrender : function(panel) {
						Ext.fly('panel-title').update(	'<p><b>Task List</b></p>'+
														'<p>Permite administrar un proyecto de portada para visualizarlo en el sitio principal</p>',
														false);
					},
					
					beforerender : function(cmp,eOpt){
						cmp.headerCt.setHeight(30);
						
					},

					itemclick	: function( grid, record, item, index, event){
					}
				},
				columns: [
					{
						text		: "Solicitud",
						dataIndex	: "id-solicitud", 
						flex		: 1, 
						width		: 40, 
						align		: "right", 
						sortable	: true,
						renderer	: function(value, metaData, record, row, col, store, gridView){
							metaData.style='line-height:30px;';
							return value;
						}
					},
					{
						text		: "Fecha",
						dataIndex	: "fecha",
						flex		: 1, 
						width		: 40, 
						sortable	: true,
						renderer	: function(value, metaData, record, row, col, store, gridView){
							return Ext.Date.format(new Date(value), "d-m-Y h:i");
						}
					},
					{text: "Cliente",dataIndex:"cliente", flex:1, sortable:true},
					{text: "Servicio",dataIndex:"servicio", flex:1, sortable:true},
					{text: "Items", dataIndex:"items",flex:1, sortable:true},
					{text: "Estado", dataIndex:"estado",flex:1, sortable:true}
				]
			})
		];
		this.callParent();
    }
});