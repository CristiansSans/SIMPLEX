<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<div id="transportista-tarifa">
	<script type="text/javascript"> 
		var idGridTarifas	=Ext.id();
		var hBrowser 		= (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();
		
		Ext.onReady(function(){
			var storeTarifas = new Ext.data.Store({
				url:'../controller/get-transportista-tarifas.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'tar_ncorr', mapping:'tar_ncorr', type:'number', useNull:true},
						{name: 'servicio',mapping:'Servicio', type:'string'},
						{name: 'subtiposervicio', mapping:'Subtiposervicio',type:'string'},
						{name: 'tramo', mapping:'Tramo',type:'string'},
						{name: 'monto', mapping:'Monto',type:'number'}
					]
				})
			});
			
			var grillaTarifas	=new Ext.grid.GridPanel({
				id			: idGridTarifas,
				el			: 'transportista-tarifa', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				//autoHeight	: true,
				store		: storeTarifas,
				tbar		: new Ext.PagingToolbar({
					store		: storeTarifas,
					displayInfo	: true,
					pageSize	: 15,
				}),
				region:'center',
				columns :[
					{header:"Servicio",dataIndex:"servicio", width:70, align:"right", sortable:true},
					{header:"Detalle Servicio",dataIndex:"subtiposervicio", width:70, sortable:true},
					{header:"Tramo",dataIndex:"tramo", sortable:true},
					{header:"Costo",dataIndex:"monto", sortable:true}
				],
				viewConfig: {
					forceFit:true
				},
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {
					}
				}
			});

			storeTarifas.load({params:{start:0,limit: 15}});
			
			grillaTarifas.render(); 
		});
	</script>
</div>