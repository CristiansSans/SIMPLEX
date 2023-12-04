<script>

	var eyeFish_BUTTONS=	'<div class="eye-fish">'+
				'	<article class="breadcrumbs">'+
				'		<a href="javascript:void(0);">Principal</a>'+
				'		<div class="breadcrumb_divider"></div>'+
				'		<a class="current">Task List</a>'+
	//			'		<div class="breadcrumb_divider_end"></div>'+
				'	</article>'+
				'</div>';
/*	
	var eyeFish_BUTTONS=	'<div id="gkBreadcrumb">'+
				'	<div class="breadcrumbs">'+
				'		<ul>'+
				'			<li><a href="/joomla16/jun2012/" class="pathway">Home</a></li>'+
				'			<li class="pathway separator">/</li>'+
				'			<li><a href="/joomla16/jun2012/index.php/template" class="pathway">Template</a></li>'+
				'			<li class="pathway separator">/</li>'+
				'			<li><a href="#" class="pathway">Lorem ipsum</a></li>'+
				'			<li class="pathway separator">/</li>'+
				'			<li><a href="#" class="pathway">Template articles</a></li>'+
				'			<li class="pathway separator">/</li>'+
				'			<li class="pathway">Page breaks</li>'+
				'		</ul>'+
				'	</div>'+
				'</section>';
*/

	function progressBar(value, meta, rec, row, col, store){
	    var id = Ext.id();
	    (function(){
	        new Ext.ProgressBar({
	            renderTo: id,
	            value: value
	        });
	    }).defer(25)
	    console.log(value)
	    return '<span id="' + id + '"></span>';
	}

	Ext.onReady(function(){
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();

		Ext.fly('title-header').update('Task List'+eyeFish_BUTTONS, false);
		
		var store = new Ext.data.Store({
			url:'../controller/task-list.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				remoteSort: false,
				fields: [
					{name: 'id-solicitud', mapping:'ose_ncorr', type:'number'},
					{name: 'fecha',mapping:'ose_dfechaservicio', type:'date'},
					{name: 'cliente', mapping:'clie_vnombre',type:'string'},
					{name: 'servicio', mapping:'tise_vdescripcion',type:'string'},
					{name: 'items', mapping:'items',type:'string'},
					{name: 'estado', mapping:'esca_vdescripcion',type:'string'}
				]
			})
		});
		
		store.load({params:{start:0,limit: 15}});

		var sm = new Ext.grid.CheckboxSelectionModel({
			listeners: {
				selectionchange: function(sm) {
					//Ext.getCmp(id + 'delete.grid').setDisabled(sm.getCount()==0);
				}
			}		
		});
		
		var filters = new Ext.ux.grid.GridFilters({filters:[
			{type: 'date',  dataIndex: 'fecha'},
			{type: 'string',  dataIndex: 'cliente'},
			{type: 'string',  dataIndex: 'servicio'},
			{type: 'string',  dataIndex: 'estado'}
		]});
		
		new Ext.grid.GridPanel({
			id		: id + 'mantenedor.grid',
			renderTo	: 'main-container',
			stripeRows	: true,
			border		: false,
			height		: hBrowser-40,
			store		: store,
			tbar		: new Ext.PagingToolbar({
				store		: store,
				displayInfo	: true,
				pageSize	: 15,
				buttons		: [
					'->',
					'-',
					{text	: 'Agregar Orden', disabled:false, handler:function(){
							loadModulo('orden-servicio.php?id=0&rowindex=-1');
						}
					},
					'-',
					{text	: 'Eliminar Orden'},
					'-'
				]
			}),
			region	: 'center',
			cm	: new Ext.grid.ColumnModel({
				columns :[
					sm,
					{header:"Solicitud",dataIndex:"id-solicitud", width:40, align:"right", sortable:true},
					{header:"Fecha",dataIndex:"fecha", width:40, sortable:true,renderer: Ext.util.Format.dateRenderer('d-m-Y h:i')},
					{header:"Cliente",dataIndex:"cliente", sortable:true},
					{header:"Servicio",dataIndex:"servicio", sortable:true},
					{header:"Items", dataIndex:"items",sortable:true},
					{header:"Estado", dataIndex:"estado",sortable:true}/*,
					{
						header		: "Monitoreo", 
						dataIndex	: "items", 
						renderer	: function (v, m, r) {
							var id = Ext.id();
							return String.format(
								'<table style="width:95%;text-align:center;height:25px;background-color:whiteSmoke; color:#444; line-height:25px; font-size:16px; border: 1px solid gainsboro;">'+
								'	<tr>'+
								'		<td style="width:20%;">01:00</td>'+
								'		<td style="width:20%;">03:00</td>'+
								'		<td style="width:20%;">05:00</td>'+
								'		<td style="width:20%;">07:00</td>'+
								'		<td style="width:20%;">09:00</td>'+
								'	</tr>'+
								'	<tr style="height:17px; border-bottom:">'+
								'		<td style="background-color:green;">'+
								'		<td style="background-color:green;">'+
								'		<td style="background-color:silver;">'+
								'		<td style="background-color:green;">'+
								'		<td style="background-color:silver;">'+
								'	</tr>'+
								'</table>', id);
						}
					}*/
				]
			}),
			sm: sm,
			viewConfig: {
				forceFit:true
			},
			listeners:
				{
					rowdblclick:function (grid, rowIndex) {
						loadModulo('orden-servicio.php?id='+grid.store.reader.jsonData.data[rowIndex].ose_ncorr+'&rowindex='+rowIndex);
					}
				},
			buttons:[
			]
		})
		
		//var d = Ext.DomHelper.append(Ext.select(".x-toolbar").elements[0], paginas_BUTTONS );
	});
</script>