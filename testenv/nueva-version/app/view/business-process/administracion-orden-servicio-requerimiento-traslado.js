Ext.require("simplex.view.capturactiva.generic.selector");
Ext.define('simplex.view.business-process.administracion-orden-servicio-requerimiento-traslado', {
	extend	: 'Ext.form.Panel',
	autoHeight	: false,
	trackResetOnLoad: false,
	autoScroll	: true,
	border		: false,
	bodyPadding	: 5,
	title		: 'Requerimiento traslado',
	id:'administracion-orden-servicio-requerimiento-traslado',
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
		xtype		: 'textfield',
		name		: 'car_ntemperatura',
		fieldLabel	: 'Temperatura &deg;C',
		allowBlank	: true
	}, {
		xtype		: 'textfield',
		name		: 'car_nventilacion',
		fieldLabel	: 'Ventilacion %',
		allowBlank	: true
	}, {
		xtype		: 'textarea',
		name		: 'car_vadic_otros',
		fieldLabel	: 'Otros',
		allowBlank	: true,
		height		: 70
	}, {
		xtype		: 'textarea',
		name		: 'car_vadic_obs',
		fieldLabel	: 'Observaciones',
		allowBlank	: true,
		height		: 70
	}]
});