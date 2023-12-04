Ext.require("simplex.view.capturactiva.generic.selector");
Ext.define('simplex.view.business-process.administracion-orden-servicio-carga-libre', {
	extend	: 'Ext.form.Panel',
	autoHeight	: false,
	trackResetOnLoad: false,
	autoScroll	: true,
	border		: false,
	bodyPadding	: 5,
	title		: 'Carga suelta',
	id:'administracion-orden-servicio-carga-libre',
	fieldDefaults: {
		labelSeparator	: '',
		labelAlign		: 'left',
		anchor			: '100%',
		labelStyle		: 'font-size:11px;text-align:left;vertical-align:middle;padding-top:4px; height:20px;margin-bottom:1px;'
	},
	listeners: {
		afterrender : function(cmp,eOpt){
//			Ext.fly('panel-title').update(	'<p><b>Orden Servicio</b></p>'+
//											'<p>Permite administrar un proyecto de portada para visualizarlo en el sitio principal</p>',
//											false);
			
		},
		expand: {
			fn: function(){
			}
		}
	},	
	
    initComponent: function() {
        this.callParent();
    },
	
	items: [{
		xtype		: 'numberfield',
		name		: 'carlibre_cantidad',
		fieldLabel	: 'Cantidad',
		allowBlank	: false
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'carlibre_um',
		fieldLabel	: 'Unidad medida',
		url		: 'server/view/get-generic.php?sp=prc_unidadmedida_listar',
		allowBlank 	: false
	}]
});