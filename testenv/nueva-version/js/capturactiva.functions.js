Ext.ns('capturactiva');

capturactiva.GLOBAL = {
  loadOrdenServicio:function(id){
    Ext.define("model-get_ordenservicio", {
        extend: 'Ext.data.Model',
    		proxy 		: {
    			type		: 'ajax',
    			actionMethods	: 'POST',
    			url 		: 'server/view/get-ordenservicio.php',
    			reader 		: {
    				type	: 'json',
    				root 	: 'data'
    			}
    		},
    		
        fields: [
					{name: 'ose_ncorr', type:'number'},
					{name: 'ose_dfechaservicio', type:'date'},					
					{name: 'ose_vnombrenave', type:'string',useNull:true},					
					{name: 'ose_vobservaciones', type:'string',useNull:true},					
					{name: 'clie_vrutsubcliente',type:'number',useNull:true},					
					{name: 'sts_ncorr', type:'number',useNull:true},
					{name: 'lug_ncorrdestino', type:'number',useNull:true},					
					{name: 'lug_ncorr_puntocarguio', type:'number',useNull:true},					
					{name: 'nav_ncorr', type:'number',useNull:true},					
					{name: 'usua_ncorr', type:'number',useNull:true},					
					{name: 'tise_ncorr', type:'number',useNull:true},					
					{name: 'lug_ncorrorigen', type:'number',useNull:true},					
					{name: 'via_ncorr', type:'number',useNull:true},					
					{name: 'clie_vnombresubcliente',type:'string'},					
					{name: 'clie_vrut', type:'number',useNull:true},					
					{name: 'clie_vnombre',type:'string'},					
					{name: 'tise_ncorr', type:'number',useNull:true},					
					{name: 'tise_vdescripcion',type:'string'},					
					{name: 'lug_ncorr', type:'number',useNull:true},					
					{name: 'lug_vnombre',type:'string'}				
        ]
    });

	Ext.create('Ext.data.Store', {
	  storeId   : 'store-get_ordenservicio',
		model     : 'model-get_ordenservicio',
		listeners : {
			load  : function (store,records,options) {
					Ext.getCmp('administracion-orden-servicio-formulario').getForm().loadRecord(store.getAt(0));
					Ext.getStore('store-administracion-orden-servicio-detalle-carga').load({params:{id:id}});
					Ext.getCmp('agregar-carga').setDisabled(false);
			  }
		} 
	});
    
    Ext.getStore('store-get_ordenservicio').load({params:{id:id}});
/*    
    Ext.define("model-ordenservicio_detallecarga", {
        extend: 'Ext.data.Model',
    		proxy 		: {
    			type		: 'ajax',
    			actionMethods	: 'POST',
    			url 		: 'server/view/get-ordenserviciodetallecarga.php',
    			reader 		: {
    				type	: 'json',
    				root 	: 'data'
    			}
    		},
        fields: [
					{name: 'car_ncorr',type:'number', useNull:true},
					{name: 'car_nbooking', type:'string', useNull:true},
					{name: 'car_voperacion',type:'string', useNull:true},
					{name: 'car_vcontenidocarga', type:'string', useNull:true},
					{name: 'car_ndiascontenedor', type:'number', useNull:true},
					{name: 'car_vmarca', type:'string', useNull:true},
					{name: 'car_npesocarga', type:'number', useNull:true},
					{name: 'car_vobservaciones', type:'string', useNull:true},
					{name: 'tica_ncorr',type:'number', useNull:true},
					{name: 'tica_vdescripcion',type:'string', useNull:true},
					{name: 'tico_ncorr', type:'number', useNull:true},
					{name: 'tico_vdescripcion',type:'string', useNull:true},
					{name: 'esca_ncorr',    type:'number', useNull:true},
					{name: 'esca_vdescripcion',type:'string', useNull:true},
					{name: 'ada_ncorr', type:'number', useNull:true},
					{name: 'ada_vnombre',type:'string', useNull:true},
					{name: 'cada_ncorr', type:'number', useNull:true},
					{name: 'cont_vmarca', type:'string', useNull:true},
					{name: 'cont_vnumcontenedor',type:'string', useNull:true},
					{name: 'cont_vcontenido', type:'string', useNull:true},
					{name: 'cont_dterminostacking', type:'date', useNull:true},
					{name: 'cont_ndiaslibres', type:'number', useNull:true},
					{name: 'cont_vsello', type:'string', useNull:true},
					{name: 'lug_ncorr_devolucion',type:'number', useNull:true},
					{name: 'cont_npeso', type:'number', useNull:true},
					{name: 'med_ncorr', type:'number', useNull:true},
					{name: 'cond_ncorr', type:'number', useNull:true},
					{name: 'lug_ncorr_destino', type:'number', useNull:true},
					{name: 'lug_ncorr_retiro', type:'number', useNull:true},
					{name: 'car_dfecharetiro', type:'date', useNull:true},
					{name: 'car_dfechapresentacion', type:'date', useNull:true},
					{name: 'car_vcontactoentrega',type:'string', useNull:true},
					{name: 'car_vcontactocons', type:'string', useNull:true},
					{name: 'car_dfechacons', type:'date', useNull:true},
					{name: 'lug_ncorr_consolidacion',type:'number', useNull:true},
					{name: 'car_ntemperatura', type:'number', useNull:true},
					{name: 'car_nventilacion',type:'number', useNull:true},
					{name: 'car_vadic_otros',type:'string', useNull:true},
					{name: 'car_vadic_obs',type:'string', useNull:true},
					{name: 'car_ncantidad', type:'number', useNull:true},
					{name: 'um_ncorr', type:'number', useNull:true},
					{name: 'fact_ncorr',type:'number', useNull:true},
					{name: 'carlibre_um',type:'number', useNull:true},
					{name: 'carlibre_cantidad',type:'number', useNull:true}					
        ]
    });
	
	Ext.create('Ext.data.Store', {
	  storeId   : 'store-ordenservicio_detallecarga',
		model     : 'model-ordenservicio_detallecarga',
		listeners : {
			load  : function (store,records,options) {
				Ext.getCmp('administracion-orden-servicio-antecedentes').getForm().loadRecord(store.getAt(0));
				Ext.getCmp('administracion-orden-servicio-datos-contenedor').getForm().loadRecord(store.getAt(0));
				Ext.getCmp('administracion-orden-servicio-datos-traslado').getForm().loadRecord(store.getAt(0));
				Ext.getCmp('administracion-orden-servicio-carga-libre').getForm().loadRecord(store.getAt(0));
				Ext.getCmp('administracion-orden-servicio-requerimiento-traslado').getForm().loadRecord(store.getAt(0));
				
				Ext.getCmp('administracion-orden-servicio-ingreso-carga').setDisabled(false);
			}
		} 
	});
*/	
//	Ext.getStore('store-ordenservicio_detallecarga').load({params:{id:id}});
//	Ext.getStore('store-administracion-orden-servicio-detalle-carga').load({params:{id:id}});
  },  
	removeModule:function(){
		if (Ext.isDefined(Ext.getCmp('panel-centro').getComponent('tasklist'))){
			//Ext.getCmp('panel-centro').getComponent('tasklist').hide();
			//Ext.getCmp('panel-centro').remove('tasklist');
			Ext.getCmp('panel-centro').removeAll();
		}
		if (Ext.isDefined(Ext.getCmp('panel-centro').getComponent('administracion-orden-servicio'))){
			//Ext.getCmp('panel-centro').getComponent('administracion-orden-servicio').hide();
			//Ext.getCmp('panel-centro').remove('administracion-orden-servicio');
			Ext.getCmp('panel-centro').removeAll();
		}
	},
	
	loadModule:function(module, record){
	   Ext.getCmp('panel-centro').show();
		this.removeModule();
		switch (module){
			case 'tasklist':
				if (Ext.isDefined(Ext.getCmp('panel-centro').getComponent('tasklist'))){
					//Ext.getCmp('panel-centro').getComponent('tasklist').show();
				}
				else{
					Ext.getCmp('panel-centro').add(
						Ext.create('simplex.view.business-process.tasklist-detalle-orden',{
							region	: 'center'
						})
					);
				}
				break;

			case 'administracion-orden-servicio':
				if (Ext.isDefined(Ext.getCmp('panel-centro').getComponent('administracion-orden-servicio'))){
					//Ext.getCmp('panel-centro').getComponent('administracion-orden-servicio').show();
					//Ext.getCmp('administracion-orden-servicio').getComponent('administracion-orden-servicio-formulario').getForm().loadRecord(record);
				}
				else{
/*          dynamicPanel = new Ext.Component({
                     loader: {
                        url: 'app/view/business-process/administracion-orden-servicio.js',
                        renderer: 'html',
                        autoLoad: true,
                        scripts: true
                        }
                     });
*/
//Ext.getCmp('specific_panel_id').add(dynamicPanel);
				
					Ext.getCmp('panel-centro').add(
						Ext.create('simplex.view.business-process.administracion-orden-servicio',{
							region	: 'center',
							record	: record
						})
					);
				}
				break;
		}
	},
	
	linkModule:function(){
		return 	'<div id="ja-right" class="column sidebar" style="width:25%">'+
				'	<div class="ja-colswrap clearfix ja-r1">'+
				'		<div id="ja-right2" class="ja-col  column" style="width:100%">'+
				'			<div class="ja-moduletable moduletable  clearfix" id="Mod29">'+
				'				<h3><span>Temas relacionados</span></h3>'+
				'				<div class="ja-box-ct clearfix">'+
				'					<ul class="mostread">'+
				'						<li><a href="#" onClick="capturactiva.GLOBAL.loadModule(this.id);" id="menu-21"><span>Servicios</span></a></li>'+
				'						<li><a href="#" onClick="capturactiva.GLOBAL.loadModule(this.id);" id="menu-22"><span>Soluciones</span></a></li>'+
//				'						<li><a href="#" onClick="capturactiva.GLOBAL.loadModule(this.id);" id="menu-23"><span>Proyectos</span></a></li>'+
				'						<li><a href="#" onClick="capturactiva.GLOBAL.loadModule(this.id);" id="menu-24"><span>Calidad</span></a></li>'+
				'						<li><a href="#" onClick="capturactiva.GLOBAL.loadModule(this.id);" id="menu-25"><span>Mision</span></a></li>'+
				'						<li><a href="#" onClick="capturactiva.GLOBAL.loadModule(this.id);" id="menu-26"><span>Valores</span></a></li>'+
				'					</ul>'+
				'				</div>'+
				'			</div>'+
				'			<div class="ja-moduletable moduletable  clearfix" id="Mod136">'+
				'				<div class="ja-box-ct clearfix">'+
				'					<div class="custom">'+
				'					</div>'+
				'				</div>'+
				'			</div>'+
				'		</div>'+
				'	</div>'+
				'</div>';
	},
	
	drawEtapa:function(recordGrid){
		var logs = new Array(7);
		var statusEtapas=["off","off","off","off","off","off","off"];
		
		if (recordGrid.estid!=0){
			for (var index=0;index<=recordGrid.estid;index++){
				statusEtapas[index]="on";
			}
		}
		statusEtapas[0]=(recordGrid.otabono?"on":"off");
		statusEtapas[6]=(recordGrid.saldo?"on":"off");
		
		for(var index=0;index<statusEtapas.length;index++){
			logs[index]='';
		};
		Ext.each(recordGrid.logs, function(data){
			logs[data.estid<0?0:data.estid] +=data.logfecha+'<br>'+data.logdescripcion+'<br>';
		});
		
		return	'	<div class="box-header">'+
				'		<h2>Bitacora de actividades</h2>'+
				'	</div>'+
				'	<div class="box-content" style="height:250px;overflow:auto;">'+
				'		<table width="95%" style="margin-left:auto;margin-right:auto;font-weight: bold;text-align:center;font-size:12px;">'+
				'			<tr>'+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/dinero-recibido-{0}-128x128.png"></td>',statusEtapas[0])+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/etapa-{0}-128x128.png"></td>',statusEtapas[1])+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/etapa-{0}-128x128.png"></td>',statusEtapas[2])+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/etapa-{0}-128x128.png"></td>',statusEtapas[3])+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/etapa-{0}-128x128.png"></td>',statusEtapas[4])+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/etapa-{0}-128x128.png"></td>',statusEtapas[5])+
				Ext.String.format(	'				<td width="15%" style="text-align:center;"><img src="resources/images/icons/dinero-recibido-{0}-128x128.png"></td>',statusEtapas[6])+
				'			</tr>'+
				'			<tr>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;">'+(recordGrid.otabono?'<a href="javascript:appendLogsSaldoAbono('+recordGrid.id+',-1);">Abono Realizado</a>':'Abono Realizado')+'</td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',1);">Planificacion Terreno</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',2);">Visita Terreno OK</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',3);">Informe Realizado</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',4);">Informe Revisado</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',5);">Informe Entregado</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;">'+(recordGrid.saldo?'<a href="javascript:appendLogsSaldoAbono('+recordGrid.id+',6);">Saldo Realizado</a>':'Saldo Realizado')+'</td>'+
				'			</tr>'+
				'			<tr>'+
				Ext.String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[0])+
				Ext.String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[1])+
				Ext.String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[2])+
				Ext.String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[3])+
				Ext.String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[4])+
				Ext.String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[5])+
				'				<td style="font-size:9px;text-align:center;">&nbsp;</td>'+
				'			</tr>'+
				'		</table>'+
				'	<div>';
	},

	renderCell:function (v,p,r){
		p.style='line-height:30px;';
		return v;
	},
	
	renderIcon:function(value, metaData, record, rowIndex, colIndex, store){
		if(colIndex==11)
			return Ext.String.format('<a href="javascript:uploadWindow({0});"><img src="resources/images/icons/upload-24x24.png" title="Subir informe..."/></a>',record.get("proid"));	
		else{
			var files		=record.get('files'),
				lnkHref		='';
				
			Ext.each(files, function(item){
				//var extension	=item.file.split('.')
				if(Ext.isEmpty(item)){
					extension='';
				}
				else{
					extension = (item.file.substring(item.file.lastIndexOf(".")+1)).toLowerCase(); 
				}

				//switch (extension[1].toLowerCase()) {
				switch (extension) {
					case 'doc':
						lnkHref += '<div>'
						if(userAdministrator){
							lnkHref += Ext.String.format('<a href="download.php?file={0}"><img src="resources/images/icons/doc-24x24.png" title="Descargar archivo doc..."/></a>', item.file);
							lnkHref += Ext.String.format('<br><a href="javascript:deleteUpload(\'{0}\');" title="Eliminar documento..."><b>x</b></a>', item.file)
						}
						lnkHref += '</div>'
						break;
						
					case 'xls':
						lnkHref += '<div>'
						lnkHref += Ext.String.format('<a href="download.php?file={0}"><img src="resources/images/icons/xls-24x24.png" title="Descargar archivo xls..."/></a>', item.file);
						if(userAdministrator){
							lnkHref += Ext.String.format('<br><a href="javascript:deleteUpload(\'{0}\');" title="Eliminar documento..."><b>x</b></a>', item.file)
						}
						lnkHref += '</div>'
						break;
						
					case 'pdf':
						lnkHref += '<div>'
						lnkHref += String.format('<a href="download.php?file={0}"><img src="css/icons/pdf-22x22.png" title="Descargar archivo pdf..."/></a>', item.file);
						if(userAdministrator){
							lnkHref += String.format('<br><a href="javascript:deleteUpload(\'{0}\');" title="Eliminar documento..."><b>x</b></a>', item.file)
						}
						lnkHref += '</div>'
						break;
						
					case 'jpg':
						lnkHref += '<div>'
						lnkHref += String.format('<a href="download.php?file={0}"><img src="css/icons/jpg-24x24.png" title="Descargar archivo jpg..."/></a>', item.file);
						if(userAdministrator){
							lnkHref += String.format('<br><a href="javascript:deleteUpload(\'{0}\');" title="Eliminar documento..."><b>x</b></a>', item.file)
						}
						lnkHref += '</div>'
						break;
						
					default:
						lnkHref += '<div>&nbsp;</div>'
				};
			});
			return lnkHref;
		}
	},

	renderAbono:function(value, metaData, record, rowIndex, colIndex, store){
		if(value!=null)
			if (record.get('fecha-abono')!=null)
				return record.get('fecha-abono').dateFormat('d-m-Y')
			else
				return "";
		else
			return 'No';
	},

	renderDate:function(value, metaData, record, rowIndex, colIndex, store){
		if(value!=null){
			return value.dateFormat('d-m-Y');
			}
		else
			return '*** Indefinido ***';
	},

	addTabAdministracion:function (id1, id2){ 
		var tab=Ext.getCmp('TabMain').getComponent(id1);
		if(!tab){ //si no existe lo creamos
			tab = Ext.create(id2, {});
			Ext.getCmp('TabMain').add(tab); //Se agrega el Panel Cliente al TabMain 
			Ext.getCmp('TabMain').doLayout(); //Redibujado del Panel 
			Ext.getCmp('TabMain').setActiveTab(tab); //Activamos el Tab
		}
		Ext.getCmp('TabMain').setActiveTab(tab);
	},

	clearFormulario:function(formularioID){
		Ext.getCmp(formularioID).getForm().reset();
	},
	saveFormulario:function(){
		if (Ext.getCmp('proyecto-administracion-formulario').getForm().isValid()){
			Ext.getCmp('proyecto-administracion-formulario').getForm().submit({
				url: 'server/view/save-portada-proyecto.php',
				waitMsg: 'Actualizando informacion...',
				success: function(fp, o) {
					Ext.getStore('proyecto-store').load();
					//msg('Success', 'Processed file "' + o.result.file + '" on the server');
				},
				failure : function (form, action){
					console.log("fallo:",form)
				}
			});
		}
	},
	saveFormularioNoticias:function(){
		if (Ext.getCmp('noticia-administracion-formulario').getForm().isValid()){
			Ext.getCmp('noticia-administracion-formulario').getForm().submit({
				url: 'server/view/save-portada-noticia.php',
				waitMsg: 'Actualizando informacion...',
				success: function(fp, o) {
					Ext.getStore('noticia-store').load();
				},
				failure : function (form, action){
					console.log("fallo:",form)
				}
			});
		}
	},
	saveFormularioClientes:function(){
		if (Ext.getCmp('administracion-clientes-formulario').getForm().isValid()){
			Ext.getCmp('administracion-clientes-formulario').getForm().submit({
				url: 'server/view/save-cliente.php',
				waitMsg: 'Actualizando informacion...',
				success: function(fp, o) {
					Ext.getStore('store-cliente').load();
				},
				failure : function (form, action){
					console.log("fallo:",form)
				}
			});
		}
	},
	saveFormularioOT:function(){
		if (Ext.getCmp('administracion-ot-formulario').getForm().isValid()){
			Ext.getCmp('administracion-ot-formulario').getForm().submit({
				url: 'server/view/save-ot.php',
				waitMsg: 'Actualizando informacion...',
				success: function(fp, o) {
					Ext.getStore('store-ot').load();
				},
				failure : function (form, action){
					console.log("fallo:",form)
				}
			});
		}
	},

    dependencySelector: function (selectorParent, keyValue, selectorsChild, filter, includeAllChild) {
        includeAllChild = (!Ext.isDefined(includeAllChild) ? true : includeAllChild);

        if (!includeAllChild) {
            selectorsChild = new Array(selectorsChild);
        }

        Ext.each(selectorsChild, function (item) {
			if (includeAllChild)
				item = Ext.getCmp(item.id);
			
			item.enable();
			item.clearValue();
			if (includeAllChild) {
				if (Ext.isDefined(item.idChild)) {
					if (item.idChild.length) {
						capturactiva.GLOBAL.dependencySelector(item, null, item.idChild, filter, true);
					}
				}
			}
        });
    }
}

