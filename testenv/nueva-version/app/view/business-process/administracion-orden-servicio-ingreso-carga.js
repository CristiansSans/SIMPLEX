Ext.define('simplex.view.business-process.administracion-orden-servicio-ingreso-carga', {
	extend		: 'Ext.Panel',
	frame		: false,
	border		: false,
	layout		: 'accordion',
	
	//region		: 'west',
	id		: 'administracion-orden-servicio-ingreso-carga',
	bbar		: [
		'->',
		'-',
		{
      text	: 'Grabar', 
      id:'grabar-carga', 
      disabled:false, 
      handler:function(){
        if(Ext.getCmp('administracion-orden-servicio-antecedentes').getForm().isValid()){
    			Ext.Ajax.request({
    				url		: 'server/view/save-ordenservicioantecedentes.php',
    				method	: 'POST',
    				params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), sub_id:'0'+Ext.getCmp('ose_ncorr').getValue(), fieldsForm:Ext.JSON.encode(Ext.getCmp('administracion-orden-servicio-antecedentes').getForm().getFieldValues())},
    				success	: function (form, request){
    					Ext.getCmp('car_ncorr').setValue(Ext.JSON.decode(form.responseText).data[0].car_ncorr);
    
    					if(Ext.getCmp('administracion-orden-servicio-datos-contenedor').getForm().isValid()){
    						Ext.Ajax.request({
    							url		: 'server/view/save-ordenserviciodatoscontenedor.php',
    							method	: 'GET',
    							params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.JSON.encode(Ext.getCmp('administracion-orden-servicio-datos-contenedor').getForm().getFieldValues())},
    							success	: function (form, request){
          					if(Ext.getCmp('administracion-orden-servicio-datos-traslado').getForm().isValid()){
          						Ext.Ajax.request({
          							url		: 'server/view/save-ordenserviciodatostraslado.php',
          							method	: 'GET',
          							params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.JSON.encode(Ext.getCmp('administracion-orden-servicio-datos-traslado').getForm().getFieldValues())},
          							success	: function (form, request){
                					if(Ext.getCmp('administracion-orden-servicio-carga-libre').getForm().isValid()){
                						Ext.Ajax.request({
                							url		: 'server/view/save-ordenserviciocargalibre.php',
                							method	: 'GET',
                							params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.JSON.encode(Ext.getCmp('administracion-orden-servicio-carga-libre').getForm().getFieldValues())},
                							success	: function (form, request){
                                if(Ext.getCmp('administracion-orden-servicio-requerimiento-traslado').getForm().isValid()){
                      						Ext.Ajax.request({
                      							url		: 'server/view/save-ordenserviciorequerimientotraslado.php',
                      							method	: 'GET',
                      							params	: {id:'0'+Ext.getCmp('car_ncorr').getValue(), fieldsForm:Ext.JSON.encode(Ext.getCmp('administracion-orden-servicio-requerimiento-traslado').getForm().getFieldValues())},
                      							success	: function (form, request){
                      
                      							},
                      							failure : function (form, action) { }
                      						});
                                }
                							},
                							failure : function (form, action) { }
                						});				
                					}
          
          							},
          							failure : function (form, action) { }
          						});				
          					}
    
    							},
    							failure : function (form, action) { }
    						});				
    					}
					


              console.log(Ext.getCmp('ose_ncorr').getValue());
              Ext.getStore('store-administracion-orden-servicio-detalle-carga').load({params:{id:Ext.getCmp('ose_ncorr').getValue()}});
				    },
				  failure : function (form, action) { }
        });				
      }
    }
  },
	'-',
	{text	: 'Limpiar', id:'cancelar-carga', disabled:true, handler:function(){}},
],
	
    initComponent: function() {
        this.callParent();
    },
	
	items: [
		Ext.create('simplex.view.business-process.administracion-orden-servicio-antecedentes'),
		Ext.create('simplex.view.business-process.administracion-orden-servicio-datos-contenedor'),
		Ext.create('simplex.view.business-process.administracion-orden-servicio-datos-traslado'),
		Ext.create('simplex.view.business-process.administracion-orden-servicio-carga-libre'),
		Ext.create('simplex.view.business-process.administracion-orden-servicio-requerimiento-traslado')
	]
});
