Ext.ns('capturactiva');

//Ext.QuickTips.init();
//Ext.form.Field.prototype.msgTarget = 'side';
//Ext.form.Field.prototype.msgTarget = 'under';

capturactiva.GLOBAL = {
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
//		item.getStore().removeAll();
		
//		item.store.baseParams={id:keyValue};
//		item.store.load();
//		item.getStore().removeAll();

		item.store.load({params:{id:keyValue}});
		
//		item.store.filters.removeAtKey('filtersId');
//		item.store.filters.add('filtersId', new Ext.util.Filter({
//		  property: filter,
//		  value: keyValue
//		}));
		
//		item.store.filter(filter, keyValue);		
//		item.store.load();
		
//item.store.filterBy(function(record,id){
//console.log("filter:",filter,":keyValue:",keyValue, "record:",record);
//        return record.get('idparent') == 5; 
//    }); 
    				
//		item.store.filterBy(function (rec) {
//                	filtrosRecord = rec.get(filter)
//                	return rec.get(filter) == keyValue;
//            	});

		if (includeAllChild) {
                	if (Ext.isDefined(item.idChild)) {
                    		if (item.idChild.length) {
                        		storbox.GLOBAL.dependencySelector(item, null, item.idChild, filter, true);
                    		}
                	}
            	}
        });
    }
}

	var getValueCombobox=function(control){
		var index = control.store.find('description',control.getValue(),0,true,false);
		if (index==-1){
			index = control.store.find('id',control.getValue(),0,true,false);
			if(index>=0){
				var record = control.store.getAt(index);
				return record.get('id')
			}
			else{
				var record = control.initialConfig.store.data;
				return record.get('id')
			}
		}
		else{
			var record = control.store.getAt(index);
			return record.get('id')
		}
	}

	var validaISO9636=function(auxTexto){
		var subResultado=0,
			jsonResults={error:false, description:''};
			
		if (auxTexto.length>=10){
			subResultado += getNumeroAsociado(auxTexto[0])*1;
			subResultado += getNumeroAsociado(auxTexto[1])*2;
			subResultado += getNumeroAsociado(auxTexto[2])*4;
			subResultado += getNumeroAsociado(auxTexto[3])*8;
			subResultado += auxTexto[4]*16;
			subResultado += auxTexto[5]*32;
			subResultado += auxTexto[6]*64;
			subResultado += auxTexto[7]*128;
			subResultado += auxTexto[8]*256;
			subResultado += auxTexto[9]*512;
			
			var amt = parseFloat(subResultado/11);
			var subResultado2 = amt.toFixed(0);
			var digito = subResultado - (subResultado2 * 11);
			if (auxTexto[10]==digito || (digito == -3 && auxTexto[10]==8)){
				jsonResults.error=false;
				jsonResults.description='';
			}
			else{
				jsonResults.error=true;
				jsonResults.description='El digito verificador es incorrecto';
			}		
		}
		else{
			jsonResults.error=true;
			jsonResults.description='El texto posee solo ' + auxTexto.length + ' caracteres';
		}

		return jsonResults;
	}

	var getNumeroAsociado=function(caracter){
		switch(caracter){
			case 'A':
				return 10;
				break;
			case 'B':
				return 12;
				break;
			case 'C':
				return 13;
				break;
			case 'D':
				return 14;
				break;
			case 'E':
				return 15;
				break;
			case 'F':
				return 16;
				break;
			case 'G':
				return 17;
				break;
			case 'H':
				return 18;
				break;
			case 'I':
				return 19;
				break;
			case 'J':
				return 20;
				break;
			case 'K':
				return 21;
				break;			
			case 'L':
				return 23;
				break;		
			case 'M':
				return 24;
				break;		
			case 'N':
				return 25;
				break;		
			case 'O':
				return 26;
				break;		
			case 'P':
				return 27;
				break;		
			case 'Q':
				return 28;
				break;		
			case 'R':
				return 29;
				break;		
			case 'S':
				return 30;
				break;		
			case 'T':
				return 31;
				break;		
			case 'U':
				return 32;
				break;		
			case 'V':
				return 34;
				break;		
			case 'W':
				return 35;
				break;		
			case 'X':
				return 36;
				break;		
			case 'Y':
				return 37;
				break;																																																																										
			case 'Z':
				return 38;
				break;		
		}
	}

	var loadModulo=function(url){
		Ext.get('main-container').load({
			url : url,
			scripts : true
		});
	}

	var renderDate=function(value, metaData, record, rowIndex, colIndex, store){
		if(value!=null){
			return value.dateFormat('d-m-Y');
			}
		else
			return '';
	}

	var renderDateTime=function(value, metaData, record, rowIndex, colIndex, store){
		if(value!=null){
			return value
		}
		else
			return '';
	}
	
	var LoadInnerHTML=function(el, url){
		Ext.get(el).load({url:url});
	}

	var validationLogin=function(idDataWindow){
		if(Ext.isEmpty(Ext.get('username').dom.value)||Ext.isEmpty(Ext.get('password').dom.value)){
			Ext.get('mensaje-login').dom.innerHTML='Credenciales inválidas, re-intente ingresar correctamente...';
			return false;
		}
		
		var store = new Ext.data.Store({
			url:'back-end/eonsis.validate-cuenta-usuario.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				fields: [
					{name: 'id', mapping:'usrid'},
					{name: 'admin', mapping:'usradmin'},
					{name: 'descripcion', mapping:'usrdescripcion'}
				]
			})
		});
		store.load({params:{username:Ext.get('username').dom.value, password:Ext.get('password').dom.value}});
		store.on('load',function(store, records, options){
			window.location = 'tracking-proyectos.php';
		});
		
		Ext.get('mensaje-login').dom.innerHTML='Credenciales inválidas, re-intente ingresar correctamente...';
	}
	
	var loginWindow=function(){
		var textHref=Ext.util.Format.trim(document.getElementById('loginWindow').innerHTML).toLowerCase().replace('&nbsp;','');
		if(textHref=="logout"){
				Ext.Ajax.request({
					url:'back-end/eonsis.reset-session.php',
					method: 'POST',
					success: function () {
						window.location = 'index.php'
					}
				});
		}
		else{
			var idDataWindow=Ext.id();

			new Ext.Window({
				id			: 'w-'+idDataWindow,
				title		: "Autenticar",
				autoDestroy	: false,
				shadow		: false,
				padding		: 5,
				width		: 465,
				autoHeight	: true,
				modal		: true,
				layout		: 'fit',
				html		: 	'<div id="tabs-1" class="tabbox ui-tabs-panel ui-widget-content ui-corner-bottom">'+
								'	<div class="login-box-error-small corners">'+
								'		<p id="mensaje-login">Ingrese sus credenciales para acceder!</p>'+
								'	</div>'+
								'	<div class="login-box-row-wrap corners">'+
								'		<label for="username">Usuario:</label>'+
								'		<input type="text" id="username" value="" name="" class="input-1">'+
								'	</div>'+
								'	<div style="height: 34px;" class="login-box-row-wrap corners">'+
								'		<label for="password">Password:</label>'+
								'		<input type="password" id="password" value="" name="" class="input-1 password">'+
								'		<a style="left: 387px; top: 17px;" class="show-password-link" href="#">Show</a>'+
								'		<input type="text" style="display: none; left: 150px; top: 10px;" class="password-showing">'+
								'	</div>'+
								'	<div class="login-box-row corners">'+
								'		<input type="checkbox" name="" id="field-remember"> <label for="field-remember">Recordarme?</label>'+
								'		<input type="submit" onclick="validationLogin(\'w-'+idDataWindow+'\');" name="" value="Login" id="submit">'+
								'	</div>'+
								'</div>'
			}).show(Ext.getBody());
		}
	}
	
	var editLogs=function(id, estid){
		var idDataWindow=Ext.id();
		var store = new Ext.data.Store({
			url:'back-end/get-logs.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				fields: [
					{name: 'id', mapping:'logid'},
					{name: 'estado-proyecto', mapping:'estdescripcion'},
					{name: 'fecha-log', mapping:'logfecha'},
					{name: 'descripcion', mapping:'logdescripcion',type: 'string'}
				]
			})
		});
		store.load({params:{id:id, estid:estid}});
		
		var editorLogs=new Ext.ux.grid.RowEditor({
			saveText: 'Actualizar',
			cancelText: 'Cancelar',
			commitChangesText: 'Existen cambios realizados al registro, actualize o cancele la edicion.'
		});
		new Ext.Window({
			id			: 'w-'+idDataWindow,
			title		: "Modificar Registro",
			autoDestroy	: false,
			shadow		: false,
			padding		: 5,
			width		: 700,
			autoHeight	: true,
			modal		: true,
			layout		: 'fit',
			items:[
				new Ext.grid.GridPanel({
				    id: id + 'logs.grid',
				    stripeRows: true,
					border:false,
					height:400,
					store:store,
					plugins:[editorLogs],
					columns :[
						{header:"ID",dataIndex:"id", width:30, align:"right"},
						{header:"Estado Proyecto",dataIndex:"estado-proyecto",width:60},
						{header:"Fecha", dataIndex:"fecha-log",renderer:renderDateTime,format:'d-m-Y',width:50},
						{header:"Descripcion",dataIndex:"descripcion", editor: {xtype: 'textarea',allowBlank: false}}
					],
					viewConfig: {
						forceFit:true,
						markDirty: false
					}
				})
			]
		}).show(Ext.getBody());
		
		editorLogs.on({
			scope: this,
			afteredit: function (roweditor, changes, record, rowIndex) {
				Ext.Ajax.request({
					url:'back-end/save-mantencion-logs.php',
					method: record.phantom ? 'POST' : 'PUT',
					params:{id:record.data.id, fieldsForm:Ext.util.JSON.encode(record.data)},
					success: function () {
						Ext.getCmp('w-'+idDataWindow).close();
					}
				});
			}
		});
		
	}
	
	var drawEtapa=function(recordGrid){
	//console.log(recordGrid);
		var logs = new Array(5);
		var statusEtapas=["off","off","off","off","off","off","off"];
		
		if (recordGrid.estid!=0){
			for (var index=0;index<=recordGrid.estid;index++){
				statusEtapas[index]="on";
			}
		}
		statusEtapas[0]=(recordGrid.otabono?"on":"off");
		statusEtapas[6]=(recordGrid.saldo?"on":"off");
		
		for(var index=1;index<statusEtapas.length;index++){
			logs[index]='';
		};
		Ext.each(recordGrid.logs, function(data){
			logs[data.estid] +=data.logfecha+'<br>'+data.logdescripcion+'<br>';
		});
		
		return	'	<div class="box-header">'+
				'		<h2>Bitacora de actividades</h2>'+
				'	</div>'+
				'	<div class="box-content" style="height:250px;overflow:auto;">'+
				'		<table width="95%" style="margin-left:auto;margin-right:auto;font-weight: bold;text-align:center;font-size:12px;">'+
				'			<tr>'+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/dinero-recibido-{0}-128x128.png"></td>',statusEtapas[0])+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/etapa-{0}-128x128.png"></td>',statusEtapas[1])+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/etapa-{0}-128x128.png"></td>',statusEtapas[2])+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/etapa-{0}-128x128.png"></td>',statusEtapas[3])+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/etapa-{0}-128x128.png"></td>',statusEtapas[4])+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/etapa-{0}-128x128.png"></td>',statusEtapas[5])+
String.format(	'				<td width="15%" style="text-align:center;"><img src="css/icons/dinero-recibido-{0}-128x128.png"></td>',statusEtapas[6])+
				'			</tr>'+
				'			<tr>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;">Abono Realizado</td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',1);">Planificacion Terreno</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',2);">Visita Terreno OK</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',3);">Informe Realizado</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',4);">Informe Revisado</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;"><a href="javascript:editLogs('+recordGrid.id+',5);">Informe Entregado</a></td>'+
				'				<td style="font-weight: bold;text-align:center;font-size:12px;">Saldo Realizado</td>'+
				'			</tr>'+

				'			<tr>'+
				'				<td style="font-size:9px;text-align:center;">&nbsp;</td>'+
String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[1])+
String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[2])+
String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[3])+
String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[4])+
String.format(	'				<td style="font-size:9px;text-align:center;">{0}</td>',logs[5])+
				'				<td style="font-size:9px;text-align:center;">&nbsp;</td>'+
				'			</tr>'+
				'		</table>'+
				'	<div>';
	}
	
	var itemsOfForm=function(formID, userAdministrator){
		switch(formID){
			case 1://Tracking
				return [
					new Ext.form.NumberField({ name:'id', fieldLabel: 'Cliente', disabled:false}),
					new Ext.form.TextField({ name:'otinterno', fieldLabel: 'Rut', allowBlank : false, disabled:false}),
					new Ext.form.TextField({ name:'otobra', fieldLabel: 'Direccion', allowBlank : false, disabled:false}),
					//new capturactiva.ux.Generic.Selector({id:'zondescripcion',name:'zondescripcion',hiddenName:'zondescripcion',fieldLabel:'Zona', storeUrl:'back-end/get-selector-zona.php',allowBlank : false, disabled:true}),
					new Ext.form.TextField({ name:'otdireccion', fieldLabel: 'Contacto', allowBlank : false, disabled:false}),
					new Ext.form.TextField({ name:'recepcion-oc', fieldLabel: 'Tipo Orden', allowBlank : false, disabled:false}),
					new Ext.form.TextField({ name:'otabono', fieldLabel: 'ETA', allowBlank : false}),
					//new capturactiva.ux.Generic.Selector({id:'estdescripcion',name:'estdescripcion',hiddenName:'estdescripcion',fieldLabel:'Estado', storeUrl:'back-end/get-selector-estado.php',allowBlank : true, disabled:!userAdministrator}),
					new Ext.form.TextField({ name:'observaciones', fieldLabel: 'Naviera', allowBlank : false}),
					new Ext.form.TextField({ name:'observaciones', fieldLabel: 'Nave', allowBlank : false}),
					new Ext.form.TextField({ name:'observaciones', fieldLabel: 'N. Booking', allowBlank : false}),
					new Ext.form.TextField({ name:'observaciones', fieldLabel: 'Agente Aduana', allowBlank : false}),
					new Ext.form.TextArea({ name:'observaciones', fieldLabel: 'Observaciones', allowBlank : false})
				]
				break;
			
			case 2://Clientes
				return[
					new Ext.form.NumberField({ id:'id',name:'id', fieldLabel: 'ID', disabled:true}),
					new Ext.form.TextField({ id:'rut',name:'rut', fieldLabel: 'Rut', allowBlank : false}),
					new Ext.form.TextField({ name:'razon-social', fieldLabel: 'Razon social', allowBlank : false}),
					new Ext.form.TextField({ name:'direccion', fieldLabel: 'Direccion', allowBlank : false}),
					new Ext.form.TextField({ name:'contacto', fieldLabel: 'Contacto', allowBlank : false}),
					new Ext.form.TextField({ name:'telefono', fieldLabel: 'Telefono', allowBlank : false})
				]
				break;
			
			case 3://OT
				return [
					new Ext.form.NumberField({ id:'id',name:'id', fieldLabel: 'ID', disabled:true}),
					new Ext.form.NumberField({ id:'ot', name:'ot', fieldLabel: 'OT', allowBlank : false}),
					new Ext.form.TextField({ name:'oc', fieldLabel: 'OC', allowBlank : false}),
					new Ext.form.DateField({ id:'fecha-recepcion-oc',name:'fecha-recepcion-oc', fieldLabel: 'Recepcion OC', allowBlank : false}),
					new Ext.form.DateField({ id:'fecha-emision-ot',name:'fecha-emision-ot', fieldLabel: 'Emision OT', allowBlank : false
						// validator:function(){
							// Ext.getCmp('abono').setDisabled(Ext.isEmpty(this.getValue()));
							// Ext.getCmp('fecha-abono').setDisabled(Ext.isEmpty(this.getValue()));
						// }
					}),
					
					new capturactiva.ux.Generic.Selector({id:'mandante',name:'mandante',hiddenName:'mandante', fieldLabel:'Cliente', storeUrl:'back-end/get-selector-cliente.php',allowBlank : false}),
					new Ext.form.TextField({ name:'obra', fieldLabel: 'Obra/Nombre', allowBlank : false}),
					new capturactiva.ux.Generic.Selector({id:'zona',name:'zona',hiddenName:'zona',fieldLabel:'Zona', storeUrl:'back-end/get-selector-zona.php',allowBlank : false}),
					new Ext.form.TextField({ name:'direccion', fieldLabel: 'Direccion', allowBlank : false}),
					new Ext.form.TextField({ name:'nombre-contacto', fieldLabel: 'Contacto', allowBlank : false}),
					new Ext.form.TextField({ name:'telefono-contacto', fieldLabel: 'Telefono', allowBlank : false}),
					new Ext.form.Checkbox({ id:'abono', name:'abono', fieldLabel: 'Abono'}),
					new Ext.form.DateField({ id:'fecha-abono', name:'fecha-abono', fieldLabel: 'Recepcion abono'}),
					new Ext.form.Checkbox({ id:'saldo', name:'saldo', fieldLabel: 'Saldo'})
				]
				break;
				
			case 4://Alerta
				return[
					new Ext.form.NumberField({ id:'id',name:'id', fieldLabel: 'ID', disabled:true}),
					new capturactiva.ux.Generic.Selector({id:'proyecto-descripcion',name:'proyecto-descripcion',hiddenName:'proyecto-descripcion', fieldLabel:'Proyecto', storeUrl:'back-end/get-selector-proyecto.php',allowBlank : false}),
					new capturactiva.ux.Generic.Selector({id:'estado-descripcion',name:'estado-descripcion',hiddenName:'estado-descripcion',fieldLabel:'Estado', storeUrl:'back-end/get-selector-estado.php',allowBlank : false}),
					new Ext.form.DateField({ id:'fecha-inicio', name:'fecha-inicio', fieldLabel: 'Fecha inicio',allowBlank : false, editable:false}),
					new Ext.form.TimeField({ id:'hora-inicio', name:'hora-inicio', fieldLabel: 'Hora inicio', format:'H:i:s',allowBlank : false, editable:false}),
					new Ext.form.DateField({ id:'fecha-termino', name:'fecha-termino', fieldLabel: 'Fecha termino',allowBlank : false, editable:false}),
					new Ext.form.TimeField({ id:'hora-termino', name:'hora-termino', fieldLabel: 'Hora termino', format:'H:i:s',allowBlank : false, editable:false}),
					new Ext.form.NumberField({id:'frecuencia', name:'frecuencia', fieldLabel: 'Intervalo',allowBlank : false}),
					new Ext.form.TextField({ name:'encargado', fieldLabel: 'Encargado', allowBlank : false, vtype:'email'})
				]
				break;
				
			case 5://Cuenta-usuario
				return[
					new Ext.form.NumberField({ id:'id',name:'id', fieldLabel: 'ID', disabled:true}),
					new Ext.form.TextField({ name:'account-login', fieldLabel: 'Usuario', allowBlank : false}),
					new Ext.form.TextField({ name:'account-password', fieldLabel: 'Password', allowBlank : false}),
					new Ext.form.TextField({ name:'account-description', fieldLabel: 'Descripcion', allowBlank : false}),
					new Ext.form.Checkbox({ name:'account-administrator', fieldLabel: 'Administrador'}),
					new capturactiva.ux.Generic.Selector({id:'account-customer',name:'account-customer',hiddenName:'account-customer', fieldLabel:'Cliente', storeUrl:'back-end/get-selector-cliente.php',allowBlank : true})
				]
				break;
		}
	}

	var dataWindow=function(grid, rowIndex){
		var idDataWindow=Ext.id();

		if (Ext.isDefined(rowIndex))
			recordGrid = grid.getStore().getAt(rowIndex);
			
		new Ext.Window({
			id			: 'w-'+idDataWindow,
			title		: "Detalle Orden de servicio",
			autoDestroy	: false,
			shadow		: false,
			padding		: 5,
			width		: 650,
			autoHeight	: true,
			modal		: true,
			layout		: 'fit',
			items:[
				new Ext.FormPanel({
					id			: 'f-'+idDataWindow,
					width		: 450,
					trackResetOnLoad: true,
					//autoWidth	: true,
					autoHeight	: true,
					border		: false,
					defaults	: {anchor:'99.5%'},
					labelWidth	: 130,
					bodyStyle	: 'background-color: #E8E8E8;',
					autoScroll	: false,
					items:new itemsOfForm(1,1),
					buttons:[
					]
				})
			]
		}).show(Ext.getBody());
	}
	
	var getValueCombobox=function(control){
		var index = control.store.find('description',control.getValue(),0,true,false);
		if (index==-1){
			index = control.store.find('id',control.getValue(),0,true,false);
			if(index>=0){
				var record = control.store.getAt(index);
				return record.get('id')
			}
			else{
				var record = control.initialConfig.store.data;
				return record.get('id')
			}
		}
		else{
			var record = control.store.getAt(index);
			return record.get('id')
		}
	}

	var two=function(x) {return ((x>9)?"":"0")+x}
	var three=function(x) {return ((x>99)?"":"0")+((x>9)?"":"0")+x}	
	
	var getMiliseconds=function(record){
		var fechaTermino=new Date(record.get("fecha-inicio").dateFormat('Y m d').replace(/-/g, "/") + " " + record.get("hora-inicio"));
		var fechaInicio=new Date();

		return fechaInicio-fechaTermino
	}
	
	var renderTime=function(value, metaData, record, rowIndex, colIndex, store){
		var arrayTiempo=record.get("hora-inicio").split(':');
		var hor=arrayTiempo[0]
		var min=arrayTiempo[1]
		var sec=arrayTiempo[2]
		var fechaTermino=new Date(record.get("fecha-inicio").dateFormat('Y m d').replace(/-/g, "/") + " " + record.get("hora-inicio"));
		
		var arrayTiempo=record.get("hora-inicio").split(':');
		var hor=arrayTiempo[0]
		var min=arrayTiempo[1]
		var sec=arrayTiempo[2]
		var fechaInicio=new Date();

		ms=fechaInicio-fechaTermino
		var sec = Math.floor(ms/1000)
		ms = ms % 1000
		t = three(ms)

		var min = Math.floor(sec/60)
		sec = sec % 60
		t = two(sec) + ":" + t

		var hr = Math.floor(min/60)
		min = min % 60
		t = two(min) + ":" + t

		var day = Math.floor(hr/60)
		hr = hr % 60
		t = two(hr) + ":" + t
		t = day + ":" + t
		
		var timeConverted='';
		if(day!=0)	{timeConverted+=String.format("{0} dia(s) ",Math.abs(day))}
		if(hr!=0)	{timeConverted+=String.format("{0} hora(s) ",Math.abs(hr))}
		if(min!=0)	{timeConverted+=String.format("{0} minuto(s) ",Math.abs(min))}

		timeConverted=(day>=0?"Iniciada ":"Falta ")+timeConverted;
		return timeConverted;
	}

	var callAlert=function(interval){
		var storeMail = new Ext.data.Store({
			url:'back-end/eonsis.send-mail.php',
			reader: new Ext.data.JsonReader({
				root:'data'
			})
		});
		storeMail.load();
		
		setTimeout(String.format('callAlert({0})',interval),interval)
	}
	
	var getAlertFromDay=function(){
		var store = new Ext.data.Store({
			url:'back-end/eonsis.get-alerta.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				fields: [
					{name: 'id', mapping:'aleid'},
					{name: 'proyecto-id', mapping:'proid', type:'int',useNull:true},
					{name: 'proyecto-descripcion', mapping:'otobra', type:'string',useNull:true},
					{name: 'estado-id', mapping:'estid', type:'int',useNull:true},
					{name: 'estado-descripcion', mapping:'estdescripcion', type:'string',useNull:true},
					{name: 'fecha-inicio', mapping:'alefechainicio', type:'date', format:'Y/m/d'},
					{name: 'hora-inicio', mapping:'alehorainicio',type: 'time'},
					{name: 'fecha-termino', mapping:'alefechatermino', type:'date', format:'Y/m/d'},
					{name: 'hora-termino', mapping:'alehoratermino',type: 'time'},
					{name: 'frecuencia', mapping:'alefrecuencia'},
					{name: 'encargado', mapping:'aleencargado', type:'string'}
				]
			})
		});
		
		store.on('load',function(store, records, options){
			if (store.getCount())
				callAlert(store.data.items[0].get('frecuencia')*1000*60);
			
			//window.location = 'tracking-proyectos.php';
		});
		
		store.on('exception',function(error){
			//console.log(error)
		});
		
		store.load({params:{onlyToday:true}});
		//setTimeout('getAlert()',3000);
	}

	var messageProcess = function(){
		var msgCt;

		function createBox(t, s){
		   return '<div class="msg"><h3>' + t + '</h3><p>' + s + '</p></div>';
		}
		return {
			msg : function(title, format){
				if(!msgCt){
					msgCt = Ext.DomHelper.insertFirst(document.body, {id:'msg-div'}, true);
				}
				//console.log(Array.prototype.slice.call(arguments, 1))
				//var s = Ext.String.format.apply(String, Array.prototype.slice.call(arguments, 1));
				//var s = Array.prototype.slice.call(arguments, 1);
				var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
				var m = Ext.DomHelper.append(msgCt, {html:createBox(title, s)}, true);
				m.slideIn('b').pause(1).ghost("b", {remove:true});
				//m.hide();
				//m.slideIn('t').ghost("t", { delay: 9000, remove: true});
				//m.slideIn('t').pause(4).ghost("t", {remove:true});
			},

			init : function(){
			}
		};
	}();
	
	Ext.onReady(function() {
		var currentSelection=null;	

		Ext.select('a').on('click',
			function(e, el, o){
			//console.log(Ext.get(el).dom.parentElement.hash)				
				if(currentSelection!=null)					
					currentSelection.removeClass('active');
					
				Ext.get(el.parentNode.parentNode).addClass('active');				
				currentSelection=Ext.get(el.parentNode.parentNode);								
				switch(Ext.get(el).dom.parentElement.hash){					
					case '#/rutas':						
						loadModulo('planeacion-rutas.php');						
						break;					
					case '#/task-list':						
						loadModulo('task-list.php');						
						break;				
				}			
			}		
		);  		
		loadModulo('task-list.php');	

	//var alertActived=getAlertFromDay();
	});