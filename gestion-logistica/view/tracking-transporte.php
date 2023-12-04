<style>
	.x-form-radio{
    		vertical-align: bottom;
    		margin-bottom: 4px;
	}
	.x-form-cb-label {
		vertical-align: top;
		top: 5px;
	}

	label {
		padding-right: 2px;
	}

	x-grid3-body {
		width:600px;
	}
	.x-grid3-locked .x-grid3-scroller{
		overflow:auto;
	}
	
/*	
	x-grid3-body {
		width:600px;
	}
	.x-grid3-locked .x-grid3-scroller{
		overflow:auto;
	}
	.x-grid3-scroller{
		width:660px;
	}

	.x-grid3-locked{
		overflow:auto;
	}
	
*/	
	.timeline-layer{
		width:1200px;
		height:31px;
	}
	
	.timeline-layer table{
		zoom:100%;
		-moz-transform:scale(1);
		/*width:300px;*/
		text-align:left;
		align:left;
		vertical-align:middle;
		/*height:2px;*/
		/*background-color:whiteSmoke; */
		color:#444; 
		/*line-height:2px; */
		/*border: 1px solid gainsboro;*/
		padding:0px 0px;

	}
	
	.timeline-layer td{
		font-family: Trebuchet MS,Helvetica,Arial,sans serif;
		font-size: 8pt;
		line-height:8px;
	}
	
	.timeline-default-font {
		font-family: Trebuchet MS,Helvetica,Arial,sans serif;
		font-size: 20pt;
	}	
</style>

<div id="div-grid-tracking">
	<script type="text/javascript">
		var trackingWindow= function(rowIndex){
			record=storeTracking.getAt(rowIndex);

			var storeRecordTracking = new Ext.data.Store({
				url:'../controller/get-record-tracking.php',
				reader: new Ext.data.JsonReader({
					root:'data',
					totalProperty: 'total',
					id: 'id',
					remoteSort: false,
					fields: [
						{name: 'tiposervicio', mapping:'tiposervicio', type:'string', useNull:true},
						{name: 'tramo', mapping:'tramo', type:'string', useNull:true},
						{name: 'car_ncorr', mapping:'car_ncorr', type:'int', useNull:true},
						{name: 'patentecamion', mapping:'patentecamion', type:'string', useNull:true},
						{name: 'nombrechofer', mapping:'nombrechofer', type:'string', useNull:true},
						{name: 'numhito', mapping:'numhito', type:'number', useNull:true},
						{name: 'nombrehito', mapping:'nombrehito', type:'string', useNull:true},
						{name: 'km', mapping:'km', type:'int', useNull:true},
						{name: 'horaprogramada', mapping:'horaprogramada', type:'string', useNull:true},
						{name: 'horareal',mapping:'horareal', type:'string', useNull:true}
					]
				}),
				listeners: {
					load:function (store,records,options) {
							record2=storeRecordTracking.getAt(0);
							new Ext.Window({
								id			: 'tracking-window',
								title		: 'Registro Seguimiento',
								autoDestroy	: false,
								shadow		: false,
								width		: 565,
								height		: 350,
								modal		: true,
								resizable	: false,
								autoScroll	: true,
								layout		: 'fit',
								fbar: [{
									text	: 'Cerrar',
									handler: function () {
										Ext.getCmp('tracking-window').close();
									}
								}],
								items		: [
									new Ext.Panel({
										title		: 'Resumen',
										layout			: {
											type	: 'vbox',
											align	: 'stretch',
											pack  	: 'start'
										},
									
										region		: 'center',
										height		: '100%',
										width		: '100%',
										items		: [
											new capturactiva.ux.Generic.Form({
												id			: 'tracking-formulario',
												trackResetOnLoad: false,
												height		: 70,
												border		: false,
												frame		: false,
												flex		: 1,
												autoScroll	: true,
												bodyStyle	: 'background-color: #F1F1F4;',
												items		: [
													{
														layout		: 'column',
														bodyStyle	: 'background-color: #F1F1F4;',
														border		: false,
														items		:[
															{
																columnWidth	: .5,
																layout		: 'form',
																defaults	: {anchor:'100%', labelStyle: 'font-size:11px'},
																labelWidth	: 70,
																bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
																border		: false,
																items		: [
																	new Ext.form.Label({fieldLabel:'Servicio', text:record.data.tiposervicio}),
																	new Ext.form.Label({fieldLabel:'Tramo', text:record2.data.tramo})
																]
															},
															{
																columnWidth	: .5,
																layout		: 'form',
																defaults	: {anchor:'100%', labelStyle: 'font-size:11px'},
																labelWidth	: 70,
																bodyStyle	: 'background-color: #F1F1F4; padding:10px;',
																border		: false,
																items		: [
																	new Ext.form.Label({fieldLabel:'Patente', text:record2.data.patentecamion}),
																	new Ext.form.Label({fieldLabel:'Chofer', text:record.data.chofer})
																]
															}
														]
													}
												]
											}),

											new Ext.grid.EditorGridPanel({
												id			: 'grid-registro-seguimiento',
												stripeRows	: true,
												border		: false,
												frame		: false,
												autoHeight	: true,
												autoScroll	: true,
												store		: storeRecordTracking,
												region		: 'center',
												layout		: 'fit',
												listeners	: {afteredit:function(evt){
													this.store.commitChanges();
													
													Ext.Ajax.request({
														url		: '../controller/save-record-tracking.php',
														method	: 'POST',
														params	: {codservicio:record.data.serv_ncorr, numhito:evt.record.data.numhito, hora:evt.value},
														success	: function (form, request){
															Ext.getCmp('grid-tracking').store.reload();

															messageProcess.msg('Registro Seguimiento', 'Informacion grabada exitosamente');
														},
														failure : function (form, action) { }
													});				
												}},									
												columns 	: [
													{header:"ID",dataIndex:"numhito", width:30, align:"right", sortable:true},
													{header:"Hito", dataIndex:"nombrehito",sortable:true},
													{header:"Km", dataIndex:"km",sortable:true},
													{header: "Hora programada", dataIndex	: "horaprogramada",sortable	: true},
													{
														header		: "Hora real", 
														dataIndex	: "horareal",
														sortable	: true,
														clicksToEdit: 1,
														editor		: new Ext.form.TimeField({
															name:'horareal',
															readOnly: false,
															width: 100,
															allowBlank :false,
															increment: 1,
															minValue: '00:01 AM',
															maxValue: '23:59 PM',
															format:'H:i'
														})
													}
												],
												viewConfig: {
													forceFit: true
												}
											})					
										]
									})					
								]
							}).show();
						}
					}
			});

			storeRecordTracking.load({params:{codservicio:record.data.serv_ncorr,start:0,limit: 15}});
		};

		var id		 =Ext.id();
		var idWindow	 =Ext.id();
		var idFormEdicion=Ext.id();
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();

		var storeTracking = new Ext.data.Store({
			url:'../controller/get-tracking.php',
			reader: new Ext.data.JsonReader({
				root:'data',
				totalProperty: 'total',
				id: 'id',
				remoteSort: false,
				fields: [
					{name: 'serv_ncorr', mapping:'serv_ncorr', type:'number', useNull:true},
					{name: 'nombreempresa', mapping:'nombreempresa', type:'string', useNull:true},
					{name: 'tiposervicio', mapping:'tiposervicio', type:'string', useNull:true},
					{name: 'camion', mapping:'camion', type:'string', useNull:true},
					{name: 'chofer', mapping:'chofer', type:'string', useNull:true},
					{name: 'numcontenedor', mapping:'numcontenedor', type:'string', useNull:true},
					{name: 'origen', mapping:'origen', type:'string', useNull:true},
					{name: 'destino', mapping:'destino', type:'string', useNull:true},
					{name: 'fono', mapping:'fono', type:'string', useNull:true},
					{name: 'diaservicio',mapping:'diaservicio', type:'date', useNull:true},//convert:renderFecha},//dateFormat: 'dddd, MMMM Do YYYY, hh:mm:ss'},
					{name: 'inicioplan', mapping:'inicioplan',type:'time', useNull:true},
					{name: 'inicioreal', mapping:'inicioreal',type:'time', useNull:true},
					{name: 'terminoplan', mapping:'terminoplan', type:'time', useNull:true},						
					{name: 'terminoreal', mapping:'terminoreal',type:'time', useNull:true},
					{name: 'total', mapping:'total',type:'time', useNull:true},
					{name: 'movimiento', mapping:'movimiento',type:'string', useNull:true},
					{name: 'distancia', mapping:'distancia',type:'string', useNull:true},
					{name: 'uavance', mapping:'uavance',type:'time', useNull:true},
					{name: 'atrasoinicio', mapping:'atrasoinicio',type:'number', useNull:true},
					{name: 'atrasoavance', mapping:'atrasoavance',type:'number', useNull:true},
					{name: 'avance', mapping:'avance',type:'number', useNull:true},
					{name: 'totaltiempo', mapping:'totaltiempo',type:'number', useNull:true}
				]
			}),
			listeners: {
				load:function (store,records,options) {
					//Ext.select('div.x-grid3-body').setStyle('width', '600px');
					//Ext.select('div.x-grid3-body').setStyle('overflow-x', 'visible');
					
					Ext.select('div.x-grid3-row').setStyle('width', '1500px');
					//Ext.select('div.x-grid3-row-first').setStyle('width', '600px');
					Ext.select('table.x-grid3-row-table').setStyle('width', '1500px');
										
					//var items = Ext.DomQuery.select('div.x-grid3-body');
					//Ext.each(Ext.select("div.x-grid3-body").elements[0], function (item) {
					//	divBody=(Ext.get(item)).id;
					//});
										
					//console.log(divBody, Ext.get(divBody).dom.childNodes);
				}
			}
		});
		
		Ext.fly('title-header').update('Tracking'+eyeFish_BUTTONS, false);
		
		Ext.onReady(function(){
			var renderFecha = function(v,record){
		           var dt = new Date(v);
		           return dt.format('dd-mm-yyyy h:i'); 
		        };

			var grillaTracking	= new Ext.grid.GridPanel({
				id		: 'grid-tracking',
				el		: 'div-grid-tracking', 
				stripeRows	: true,
				border		: false,
				frame		: false,
				height		: hBrowser-50,
				store		: storeTracking,
				tbar		: new Ext.PagingToolbar({
							store		: storeTracking,
							displayInfo	: true,
							pageSize	: 15,
							buttons		: [
								'-',
								new Ext.form.Label({text:'Orden '}),
								new Ext.form.NumberField({ id:'ordenservicio', name:'ordenservicio', fieldLabel: 'Orden', allowBlank : false, disabled:false, width:80}),								
								'-',
								new Ext.form.Label({text:'Cliente '}),
								new capturactiva.ux.Generic.Selector({id:'clie_vrut',name:'clie_vrut',hiddenName:'clie_vrut',fieldLabel:'Cliente', storeUrl:'../controller/get-selector-generic.php?sp=prc_cliente_listar',allowBlank : false, disabled:false, width:130}),
								'-',
								new Ext.form.Label({text:'Transportista '}),
								new capturactiva.ux.Generic.Selector({id:'emp_vnombre',name:'emp_vnombre',hiddenName:'emp_vnombre',fieldLabel:'Transportista', storeUrl:'../controller/get-selector-generic.php?sp=prc_transportista_listar',allowBlank : false, disabled:false,width:130}),
								'-',
								new Ext.form.Label({text:'Periodo '}),
								new Ext.form.DateField({ id:'periodo-inicial', name:'periodo-inicial', fieldLabel: 'periodo-inicial', allowBlank : false, disabled:false, value: new Date(), width:90}),
								new Ext.form.DateField({ id:'periodo-final', name:'periodo-final', fieldLabel: 'periodo-final', allowBlank : false, disabled:false, value: new Date(), width:90}),								
								'-',
								{text	: 'Refrescar', disabled:false, handler:function(){
										storeTracking.load({params:{codorden:'0'+Ext.getCmp('ordenservicio').getValue(), codcliente:'0'+Ext.getCmp('clie_vrut').getValue(), codtransportista:'0'+Ext.getCmp('emp_vnombre').getValue(), inicioperiodo:Ext.getCmp('periodo-inicial').getValue(), terminoperiodo:Ext.getCmp('periodo-final').getValue(),start:0,limit: 15}});
									}
								},
								'-'
							]
				}),
				region:'center',
				colModel : new Ext.ux.grid.LockingColumnModel([				
					{header:"ID",dataIndex:"serv_ncorr", width:30, align:"right", sortable:true},
					{
						header:"U.Avance", 
						dataIndex:"uavance",
						sortable:true,
						//locked:true,
						renderer: function (value, metadata, record, rowIndex, colIndex, store) {
							if (!Ext.isEmpty(value))
								//return String.format('<table><tr><td style="height:32px;vertical-align:center;"><a href="../controller/generate-factura.php?id={0}"><img src="../images/pin-out.png" /></a></td><td style="height:32px;vertical-align:center;"><img src="../images/trash.png" /></td></tr></table>',value,value)
								return String.format('<table><tr><td style="height:25px;vertical-align:center;"><a href="javascript:trackingWindow({0});"><img src="../images/icon-edit.png" /></a></td><td style="height:24px;vertical-align:center;"><span>{1}</span></td></tr></table>',rowIndex, value)
						}
					},

					{header:"Empresa", dataIndex:"nombreempresa",sortable:true},
					{header:"Tipo servicio", dataIndex:"tiposervicio",sortable:true},
					{header:"Camion", dataIndex:"camion",sortable:true},
					{header:"Chofer", dataIndex:"chofer",sortable:true},
					{header:"Nª contenedor", dataIndex:"numcontenedor",sortable:true},
					{header:"Origen", dataIndex:"origen",sortable:true},
					{header:"Destino", dataIndex:"destino",sortable:true},
					{header:"Fono", dataIndex:"fono",sortable:true},
					{header:"Fecha",dataIndex:"diaservicio", width:40, sortable:true,renderer: Ext.util.Format.dateRenderer('d-m-Y')},
					{header:"Inicio plan",dataIndex:"inicioplan", width:40, sortable:true},
					{header:"Inicio real",dataIndex:"inicioreal", width:40, sortable:true},
					{header:"Fin plan",dataIndex:"terminoplan", width:60, sortable:true},
					{header:"Fin real", dataIndex:"terminoreal",width:60, sortable:true},
					{header:"Tiempo total", dataIndex:"total",width:60, sortable:true},
					{header:"Movimiento", dataIndex:"movimiento",sortable:true},
					{header:"Distancia", dataIndex:"distancia",sortable:true},
					{
						header:"Avance", 
						dataIndex:"avance",
						width:360,
						sortable:true,
						locked:true,
						renderer	: function (value, metadata, record, rowIndex, colIndex, store) {
							if (!Ext.isEmpty(value)){
								totalHoras	= parseInt(record.data.terminoplan.substr(0,2),10)-parseInt(record.data.inicioplan.substring(0,2),10);
								horaInicio	= parseInt(record.data.inicioplan.substr(0,2),10);
								minutoInicio= parseInt(record.data.inicioplan.substr(3,2),10);
								horaFaltante= parseInt(record.data.totaltiempo,10)-(parseInt(record.data.atrasoinicio,10) + parseInt(record.data.avance,10) + parseInt(record.data.atrasoavance,10));

								console.log(",inicioplan:",record.data.inicioplan,",horaInicio:",horaInicio,",minutoInicio:",minutoInicio,",atrasoinicio:",record.data.atrasoinicio,"avance:",record.data.avance,",atrasoavance:",record.data.atrasoavance,",horaFaltante:",horaFaltante,",terminoplan:",record.data.terminoplan);
								
								rowDivider	= '';
								rowHours	= '';

								layerTime		 =	'				<div class="timeline-layer">'+
													String.format('		<table class="drag-zone" cellspacing=0 cellpadding=0 style="width:{0}px;">',(60*23))+
													'						<tr>';
								for (var i=0;i<24;i++){
									rowDivider 	+=	'							<td style="width:60px;height:8px;border-right: 1px dotted #444;">&nbsp;</td>';
									rowHours 	+=	String.format('				<td class="drag-zone" style="width:60px;height:15px;">{0}</td>',(i>9?i:"0"+i.toString())+":00");
								}

								layerTime		+=  rowDivider+
													'						</tr>'+
													'						<tr>'+
													rowHours+
													'						</tr>'+
													'						<tr>';
								for (var i=0;i<24;i++){
									if (horaInicio==i){
										break;
									}
									else{
										layerTime	+=	String.format('			<td colspan=1 style="padding-bottom:5px;width:{0}px;">&nbsp;</td>',60);
									}
								}
								
								avancePX		 = 	parseInt(record.data.avance,10);
								atrasoAvancePX	 =  parseInt(record.data.atrasoavance,10);
								anchoGrafico	 =  minutoInicio+parseInt(record.data.atrasoinicio,10)+parseInt(record.data.avance,10)+parseInt(record.data.atrasoavance,10);
								
								layerTime		+=  String.format('				<td style="padding-bottom:5px;width:{0}px;">',anchoGrafico)+
													String.format('					<table cellspacing=0 cellpadding=0 style="width:{0}px;">',anchoGrafico)+
													String.format('						<tr>')+
													String.format('							<td colspan=1 style="background-color:whiteSmoke;width:{0}px;">&nbsp;</td>',minutoInicio);
													
								if (parseInt(record.data.atrasoinicio,10)==0){
									//layerTime	+=	String.format('							<td colspan=1 title="{1}" style="cursor:pointer;background-color:lightgreen;width:{0}px;">&nbsp;</td>',60-minutoInicio,'Avance de '+avancePX+' minuto(s)');
								}
								else{									
									layerTime	+=	String.format('							<td colspan=1 title="{1}" style="cursor:pointer;background-color:red;width:{0}px;">&nbsp;</td>',parseInt(record.data.atrasoinicio,10),'Atraso de '+parseInt(record.data.atrasoinicio,10)+' minuto(s)');//+
													//String.format('							<td colspan=1 title="{1}" style="cursor:pointer;background-color:lightgreen;width:{0}px;">&nbsp;</td>',60-parseInt(record.data.atrasoinicio,10),'Avance de '+avancePX+' minuto(s)');
								}	
								
								layerTime	+=		String.format('							<td colspan=1 title="{1}" style="cursor:pointer;background-color:lightgreen;width:{0}px;">&nbsp;</td>',avancePX,'Avance de '+avancePX+' minuto(s)')+
													String.format('							<td colspan=1 title="{1}" style="cursor:pointer;background-color:red;width:{0}px;">&nbsp;</td>',atrasoAvancePX,'Atraso de '+atrasoAvancePX+' minuto(s)');
													
								if(horaFaltante>0){
									layerTime	+=	String.format('							<td colspan=1 title="{1}" style="cursor:pointer;background-color:blue;width:{0}px;">&nbsp;</td>',horaFaltante,'Trayectoria pendiente de '+horaFaltante+' minuto(s)');
								}
													
								layerTime	+=		String.format('						</tr>')+
													String.format('					</table>')+
													String.format('				</td>')+
													String.format('			</tr>')+
													String.format('		</table>')+
													String.format('	</div>');

												
												
								return layerTime;
							}
						}
					}
				]),
				viewConfig	: new Ext.ux.grid.LockingGridView(), 
				listeners: {
					rowdblclick:function (grid, rowIndex, e) {
					}
				}
			});

			storeTracking.load({params:{codorden:'0'+Ext.getCmp('ordenservicio').getValue(), codcliente:'0'+Ext.getCmp('clie_vrut').getValue(), codtransportista:'0'+Ext.getCmp('emp_vnombre').getValue(), inicioperiodo:Ext.getCmp('periodo-inicial').getValue(), terminoperiodo:Ext.getCmp('periodo-final').getValue(),start:0,limit: 15}});
			
			grillaTracking.render();
		});
		
		$(document).ready(function () {       
			$('.x-grid3-scroller').mousedown(function (event) {
				$(this)
					.data('down', true)
					.data('x', event.clientX)
					.data('scrollLeft', this.scrollLeft);
					
				return false;
			}).mouseup(function (event) {
				$(this).data('down', false);
			}).mousemove(function (event) {
				if ($(this).data('down') == true) {
					this.scrollLeft = $(this).data('scrollLeft') + $(this).data('x') - event.clientX;
				}
			}).mousewheel(function (event, delta) {
				this.scrollLeft -= (delta * 30);
			}).css({
			  //'overflow' : 'hidden',
			    'overflow' : 'auto',
				'cursor' : '-moz-grab'
			});
		});
		
		$(window).mouseout(function (event) {
			if ($('.x-grid3-scroller').data('down')) {
				try {
					if (event.originalTarget.nodeName == 'BODY' || event.originalTarget.nodeName == 'HTML') {
						$('.x-grid3-scroller').data('down', false);
					}                
				} catch (e) {}
			}
		});		
	</script>
</div>