Ext.require("simplex.view.capturactiva.generic.selector");
Ext.define('simplex.view.business-process.administracion-orden-servicio-antecedentes', {
	extend	: 'Ext.form.Panel',
	id         : 'administracion-orden-servicio-antecedentes',
	autoHeight : false,
	trackResetOnLoad: false,
	autoScroll	: true,
	border		: false,
	bodyPadding	: 5,
	title		: 'Antecedentes',
	
	fieldDefaults: {
		labelSeparator	: '',
		labelAlign		: 'left',
		anchor			: '100%',
		labelStyle		: 'font-size:11px;text-align:left;vertical-align:middle;padding-top:4px; height:20px;margin-bottom:1px;'
	},
	listeners: {
		afterrender : function(cmp,eOpt){
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
		xtype     : 'textfield',
		id        : 'car_ncorr',
		fieldLabel: 'ID',
		readOnly	: true
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'esca_ncorr',
		fieldLabel	: 'Estado',
		url			: 'server/view/get-generic.php?sp=prc_estadocarga_listar',
		allowBlank 	: false
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'tica_ncorr',
		fieldLabel	: 'Tipo carga',
		url			: 'server/view/get-generic.php?sp=prc_tipocarga_listar',
		allowBlank 	: false
	}, {
		xtype		: 'textfield',
		name		: 'car_nbooking',
		fieldLabel	: 'N&deg; booking',
		allowBlank 	: false
	},{
		xtype		: 'textfield',
		name		: 'car_voperacion',
		fieldLabel	: 'N&deg; operacion',
		allowBlank 	: false
	},{
		xtype		: 'textarea',
		name		: 'car_vobservaciones',
		fieldLabel	: 'Observaciones',
		allowBlank 	: true
	}]
});