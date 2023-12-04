Ext.require("simplex.view.capturactiva.generic.selector");
Ext.define('simplex.view.business-process.administracion-orden-servicio-datos-contenedor', {
	extend	: 'Ext.form.Panel',
	autoHeight	: false,
	trackResetOnLoad: false,
	autoScroll	: true,
	border		: false,
	bodyPadding	: 5,
	title		: 'Datos contenedor',
	id:'administracion-orden-servicio-datos-contenedor',
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
		xtype		: 'textfield',
		name		: 'cont_vmarca',
		fieldLabel	: 'Marca contenedor',
		true		: true
	}, {
		xtype		: 'textfield',
		name		: 'cont_vnumcontenedor',
		fieldLabel	: 'N&deg; contenedor',
		allowBlank 	: false
	},{
		xtype		: 'textarea',
		name		: 'cont_vcontenido',
		fieldLabel	: 'Contenido',
		allowBlank 	: true
	},{
		xtype		: 'datefield',
		name		: 'cont_dterminostacking',
		fieldLabel	: 'Termino stacking',
		allowBlank 	: true
	},{
		xtype		: 'capturactiva.generic.selector',
		name		: 'lug_ncorr_devolucion',
		fieldLabel	: 'Lugar devolucion',
		url		: 'server/view/get-generic.php?sp=prc_lugar_listar&id=1',
		allowBlank 	: true
	}, {
		xtype		: 'textfield',
		name		: 'cont_vsello',
		fieldLabel	: 'Sello',
		allowBlank 	: false
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'ada_ncorr',
		fieldLabel	: 'Agencia aduana',
		url		: 'server/view/get-generic.php?sp=prc_agenciaaduana_listar',
		allowBlank 	: false
	}, {
		xtype		: 'numberfield',
		name		: 'cont_ndiaslibres',
		fieldLabel	: 'Dias libres',
		allowBlank 	: true
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'cada_ncorr',
		fieldLabel	: 'Contacto agencia',
		url		: 'server/view/get-generic.php?sp=prc_contactoagencia_listar&id=0',
		allowBlank 	: false
	}, {
		xtype		: 'textfield',
		name		: 'cont_npeso',
		fieldLabel	: 'Peso carga',
		allowBlank 	: false
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'med_ncorr',
		fieldLabel	: 'Medidas contenedor',
		url		: 'server/view/get-generic.php?sp=prc_medidacontenedor_listar',
		allowBlank 	: false
	}, {
		xtype		: 'capturactiva.generic.selector',
		name		: 'cond_ncorr',
		fieldLabel	: 'Condicion especial',
		url		: 'server/view/get-generic.php?sp=prc_condicionespecial_listar',
		allowBlank 	: false
	}]
});