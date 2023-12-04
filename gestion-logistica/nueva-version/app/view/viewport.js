Ext.form.Field.prototype.msgTarget = 'under';  
Ext.define("search", {
    extend: 'Ext.data.Model',
		proxy 		: {
			type		: 'ajax',
			actionMethods	: 'POST',
			url 		: 'server/view/get-ordenserviciosearch.php',
			reader 		: {
				type	: 'json',
				root 	: 'data'
			}
		},
    fields: [
        {name: 'ose_ncorr', type :'int'},
        {name: 'ose_vnombrenave', type : 'string'}
    ]
});

ds = Ext.create('Ext.data.Store', {
    pageSize: 10,
    model: 'search'
});

var	tplSearch= new Ext.Template(
	'<div id="panel-header-title" class="x-column-header" style="background-color:#fff; border-bottom: 1px solid #ccc;border-top: 1px solid #ccc;padding:5px;height:50px;width:100%;">',
		'<div id="panel-title" style="position:absolute;top:10;height:45px;width:50%;"></div>',
		'<div id="panel-search" style="position:absolute;top:0;left:50%;height:45px;width:50%;"></div>',
	'</div>'
);

Ext.define('simplex.view.viewport',{
	extend	: 'Ext.container.Viewport',
	layout	: 'border',
	id		: 'viewport-main',
//	margins		: '3,3,3,3',
	
    initComponent: function() {
		var me=this;
		me.items = [{
			xtype	: 'panel',
			id		: 'panel-norte',
			region	: 'north',
			height	: 110,
			activeItem	: 0,
			shadow		: 'frame',
			shadowOffset: 10,
			border		: false,
//			bodyStyle	: 'border-width: 0;',
			listeners	: {
				afterrender : function(){
				}
			},
			html		:	new Ext.Template(
				'<div id="rt-header">',
					'<div class="rt-container">',
						'<div class="rt-grid-3 rt-alpha">',
							'<div class="rt-block"><div id="rt-logo"></div>',
						'</div>',
					'</div>',
					'<div class="rt-icons">',
						'<a id="iconos-header-home" href="#" title="Ir a principal"></a>',
						'<a id="iconos-coordinacion"  href="#" title="Coordinacion"></a>',
						'<a id="iconos-header-map"  href="#" title="Planeacion rutas"></a>',
						'<a id="iconos-invoice" href="#" title="Facturacion"></a>',
						'<a id="iconos-tracking"  href="#" title="Tracking"></a>',
					'</div>',
				'</div>'
			)
		},{
			xtype		: 'panel',
			id			: 'panel-centro',
			region		: 'center',
			layout		: 'border',
			border		: true,
			shadow		: 'frame',
			shadowOffset: 20,
			margins	: '2 2 2 2',
      		listeners: {
      			afterrender : function(cmp,eOpt){
      			}
      		},	
			items		: [{
  				xtype	: 'panel',
  				region	: 'north',
  				height	: 55,
  				border	: false,
//  			bodyStyle	: 'border-bottom-width: 1px; border-top-width: 1px;',
				html		: tplSearch,
        		listeners: {
        			afterrender : function(cmp,eOpt){
						Ext.create('Ext.form.Panel',  {
							height:45,
							width:500,
							frame		: false,
							border		: false,
							bodyPadding	: 5,
							fieldDefaults: {
								labelSeparator	: '',
								labelAlign		: 'left',
								anchor			: '100%',
								labelStyle		: 'font-size:11px;vertical-align:middle;padding-top:4px; height:20px;margin-bottom:1px;'
							},
							renderTo : 'panel-search',
							items:[{
								xtype: 'combo',
								store: ds,
								displayField: 'ose_vnombrenave',
								fieldLabel	: 'Orden',
								typeAhead: false,
//								hideLabel: true,
								hideTrigger:true,
								anchor: '100%',
//								width : 500,
//								renderTo : 'panel-search',
								listConfig: {
									loadingText: 'Buscando informacion...',
									emptyText: 'No existen resultados para la busqueda..',
//									Custom rendering template for each item
									getInnerTpl: function() {
										return	'<a class="search-item" href="javascript:capturactiva.GLOBAL.loadOrdenServicio({ose_ncorr});">' +
												'<h3><span>{ose_ncorr}|{ose_vnombrenave}</span></h3>' +
												'</a>';
									}
								},
								pageSize: 10
							}]
						})
					}
				}
			},

			Ext.create('simplex.view.business-process.administracion-orden-servicio',{
				region	: 'center'
			})
/*					Ext.create('simplex.view.business-process.tasklist-detalle-orden',{
						region	: 'center'
					})
*/					
			]
		},{
			xtype		: 'panel',
			id			: 'panel-sur',
			region		: 'south',
			height		: 21,
			activeItem	: 0,
			style		: 'font-size: 8px; text-align: left;',
			html		: new Ext.Template(
				'<div class="rounded social-callout" style="margin:0;">',
					'<p><em>Capturactiva,  todos los derechos reservados 2008-2013</em></p>',
				'</div>',
				{
					compiled: true
				}
			)
		}];
        me.callParent();
    }
 });
