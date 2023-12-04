Ext.define('simplex.view.business-process.administracion-orden-servicio', {
	extend			: 'Ext.Panel',
	alias			: 'widget.administracionordenservicio',
	itemId			: 'administracion-orden-servicio',
	region			: 'center',
	layout			: 'border',
	border			: false,
	initComponent	: function() {
		this.callParent();
	},
				
	listeners: {
		afterrender : function(panel) {
			Ext.fly('panel-title').update(
			'	<p><b>Orden Servicio</b></p>'+
			'	<p>Permite administrar un proyecto de portada para visualizarlo en el sitio principal</p>',
			false
			);
		}
	},
	
	items: [
		Ext.create('simplex.view.business-process.administracion-orden-servicio-ingreso-carga',{
			region		: 'center',
			width		: '30%',
			split		: true,
			collapseMode: 'mini', 
			collapsible : true,
			border		: true,
			shadow		: 'frame',
			shadowOffset: 20,
			activeItem	: 1,
			disabled    : true,
			
			id:'administracion-orden-servicio-ingreso-carga',
			listeners	: {
				afterrender: function(){
					this.getHeader().hide();
				}
			}
			
		}),

		{
			xtype	: 'panel',
			region	: 'west',
			width	: '70%',
			layout	: 'border',
			border	: false,
			items	: [
				Ext.create('simplex.view.business-process.administracion-orden-servicio-formulario',{
					region		: 'center',
					height		: '58%',
					autoScroll	: true,
					
					listeners	: {
						afterrender: function(){
							//console.log(record);
							//this.getForm().loadRecord(record);							
						}
					}
					
				}),

				Ext.create('simplex.view.business-process.administracion-orden-servicio-detalle-carga',{
					region	: 'south',
					height	: '42%'
				})
			]
		}
	]
});
