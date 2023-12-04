<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<div id="transportista-camiones-chasis">
	<script type="text/javascript"> 
		var idGridCamiones	=Ext.id();
		var hBrowser 		= (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		
		Ext.onReady(function(){
			var storeCamiones = new Ext.data.Store({
				url:'../controller/get-transportista-camiones-chasis.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'cam_ncorr', mapping:'cam_ncorr', type:'number', useNull:true},
						{name: 'cam_vpatente',mapping:'cam_vpatente', type:'string'},
						{name: 'cam_vmarca', mapping:'cam_vmarca',type:'string'},
						{name: 'cam_vmodelo', mapping:'cam_vmodelo',type:'string'}
					]
				})
			});
			
			var grillaCamiones	=new Ext.grid.GridPanel({
				id			: idGridCamiones,
				el			: 'transportista-camiones-chasis', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				//autoHeight	: true,
				store		: storeCamiones,
				tbar		: new Ext.PagingToolbar({
					store		: storeCamiones,
					displayInfo	: true,
					pageSize	: 15,
				}),
				region:'center',
				columns :[
					{header:"Patente",dataIndex:"servicio", width:70, align:"right", sortable:true},
					{header:"Marca",dataIndex:"subtiposervicio", width:70, sortable:true},
					{header:"Modelo",dataIndex:"tramo", sortable:true},
					{header:"Capacidad",dataIndex:"monto", sortable:true}
				],
				viewConfig: {
					forceFit:true
				},
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {
					}
				}
			});

			storeCamiones.load({params:{start:0,limit: 15}});
			
			grillaCamiones.render(); 
		});
	</script>
</div>