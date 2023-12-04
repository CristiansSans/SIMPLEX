<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

<div id="facturas">
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

			var storeFacturas = new Ext.data.Store({
				url:'../controller/get-facturas.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'fact_ncorr', mapping:'fact_ncorr', type:'number', useNull:true},
						{name: 'numfactura',mapping:'numfactura', type:'number', useNull:true},
						{name: 'cliente', mapping:'cliente',type:'string', useNull:true},
						{name: 'fecha', mapping:'fecha',type:'date', useNull:true},
						{name: 'total',mapping:'total', type:'number', useNull:true},
						{name: 'estado', mapping:'estado',type:'string', useNull:true}
					]
				})
			});
			
			var grillaFacturas	=new Ext.grid.GridPanel({
				id		: 'grid-facturas',
				el		: 'facturas', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				autoHeight	: true,
				store		: storeFacturas,
				tbar		: new Ext.PagingToolbar({
							store		: storeFacturas,
							displayInfo	: true,
							pageSize	: 15,
							buttons		: [
								'-',
								new Ext.form.Label({text:'Facturas '}),
								new Ext.form.NumberField({ id:'factura', name:'factura', fieldLabel: 'Factura', allowBlank : false, disabled:false, width:80}),								
								'-',
								new Ext.form.Label({text:'Orden '}),
								new Ext.form.NumberField({ id:'ordenservicio-2', name:'ordenservicio-2', fieldLabel: 'Orden', allowBlank : false, disabled:false, width:80}),								
								'-',
								new Ext.form.Label({text:'Cliente '}),
								new capturactiva.ux.Generic.Selector({id:'cliente-2',name:'cliente-2',hiddenName:'cliente-2',fieldLabel:'Cliente', storeUrl:'../controller/get-selector-generic.php?sp=prc_cliente_listar',allowBlank : false, disabled:false, width:130}),
								'-',
								{
									id	: 'refrescar-facturas',
									text	: 'Refrescar', 
									disabled:false, 
									handler:function(){
										storeFacturas.load({params:{factura:'0'+Ext.getCmp('factura').getValue(),orden:'0'+Ext.getCmp('ordenservicio-2').getValue(),cliente:'0'+Ext.getCmp('cliente-2').getValue(),start:0,limit: 15}});
									}
								},
								'-'
							]
				}),
				region:'center',
				columns :[
					{header:"Factura",dataIndex:"numfactura", width:70, align:"right", sortable:true},
					{header:"Cliente",dataIndex:"cliente", width:70, sortable:true},
					{header:"Fecha factura",dataIndex:"fecha", width:70, sortable:true,renderer: Ext.util.Format.dateRenderer('d-m-Y h:i')},
					{header:"Monto",dataIndex:"total", sortable:true},
					{header:"Estado",dataIndex:"estado", sortable:true,
						renderer: function (v, m, r) {
							if (!Ext.isEmpty(v))
								return String.format('<table><tr><td style="height:24px;vertical-align:center;"><a href="../controller/generate-factura.php?id={0}"><img src="../images/icon-pdf.png" /></a></td><td style="height:24px;vertical-align:center;"><span>{1}</span></td></tr></table>',r.data.fact_ncorr,v)
						}
					}
				],
				viewConfig: {
					forceFit:true
				},
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {

					}
				}
			});

			storeFacturas.load({params:{factura:'0'+Ext.getCmp('factura').getValue(),orden:'0'+Ext.getCmp('ordenservicio').getValue(),cliente:'0'+Ext.getCmp('cliente').getValue(),start:0,limit: 15}});
			
			grillaFacturas.render(); 
		});
	</script>
</div>