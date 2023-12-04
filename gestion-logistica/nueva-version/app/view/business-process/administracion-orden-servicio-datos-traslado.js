Ext.require("simplex.view.capturactiva.generic.selector");
Ext.define('simplex.view.business-process.administracion-orden-servicio-datos-traslado', {
	extend	: 'Ext.form.Panel',
	autoHeight	: false,
	trackResetOnLoad: false,
	autoScroll	: true,
	border		: false,
	bodyPadding	: 5,
	title		: 'Datos traslado',
	id:'administracion-orden-servicio-datos-traslado',
	fieldDefaults: {
		labelSeparator	: '',
		labelAlign		: 'left',
		anchor			: '100%',
		labelStyle		: 'font-size:11px;text-align:left;vertical-align:middle;padding-top:4px; height:20px;margin-bottom:1px;'
	},
	listeners: {
		afterrender : function(cmp,eOpt){
//			Ext.fly('panel-title').update(	'<p><b>Orden Servicio</b></p>'+
//
//											'<p>Permite administrar un proyecto de portada para visualizarlo en el sitio principal</p>',
//
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
		xtype		: 'datefield',
		name		: 'car_dfecharetiro',
		fieldLabel	: 'Fecha retiro',
		allowBlank	: false
	}, {
		xtype		: 'datefield',
		name		: 'car_dfechapresentacion',
		fieldLabel	: 'Fecha presentacion',
		allowBlank	: false
	}, {
		xtype		: 'textfield',
		name		: 'car_vcontactoentrega',
		fieldLabel	: 'Contacto entrega',
		allowBlank 	: true
	}]
});