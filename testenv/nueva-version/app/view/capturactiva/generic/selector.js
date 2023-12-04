Ext.define('capturactiva.generic.model', {
    extend: 'Ext.data.Model', 
	fields: [
		{name:'id', type: 'int'},
		{name:'idparent', type: 'int'},
		{name:'description', type : 'string'}
	]
});

Ext.define('capturactiva.generic.selector', {
	extend	: 'Ext.form.field.ComboBox',
	alias	: 'widget.capturactiva.generic.selector',
//    	setValue: function(value, doSelect) {
//        	if(this.store.loading){
//            		this.store.on('load', Ext.bind(this.setValue, this, arguments));
//            		return;
//        	}
//      },

	constructor: function(config) {
		var store = Ext.create('Ext.data.Store', {
			model		: 'capturactiva.generic.model',
			autoLoad	: false,
			//autoLoad	: true,
			//remoteSort	: true,
			proxy 		: {
				type		: 'ajax',
				actionMethods	: 'POST',
				url 		: config.url,
				reader 		: {
					type	: 'json',
					root 	: 'data'
				}
				//simpleSortMode	: true
			},
			listeners: {
				load: function(sender, node, records) {
				},
				exception : function(proxy, response, operation) {
					if (operation) {
						console(operation.error);
					} else {
						console(operation.error);
					}
				}				
			}			
		});
		
		Ext.apply(this, config, {
			store		: store,
			displayField: 'description',
			valueField	: 'id',
			hiddenValue	: 'id',
			hiddenId	: 'id',
			queryMode	: 'remote',
////			mode:'remote',
			minChars:2,
//			forceSelection:true,
			typeAhead:true,
			emptyText	: 'Seleccione un item...'
			//editable: false
		});		
		
		this.callParent(arguments);
	}
});