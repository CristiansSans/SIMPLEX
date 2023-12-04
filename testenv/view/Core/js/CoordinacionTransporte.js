var _UBICACION;
function cargaGrillaCoordinacionTransporte(agrupar,campoagrupar){
	var alto = $( document ).height() - 150;
	jQuery("#tblOrdenes").jqGrid({
		datatype 	: "json",		
		url 		: '../../controller/CoordinacionTransporte/CargaSinProgramar-listar.php',
		height 		: alto,
		autowidth 	: true,
	   	colNames:['Id.Carga', 'ETA', 'P.Carguio','Ubicacion','Destino','Nave','Cliente','N°contenedor','Medida','Peso','C.especial','Operacion','sts_ncorr','lug_ncorr'],
	   	colModel:[
	   		{name:'idcarga',index:'idcarga', width:80, sorttype:"float"},
	   		{name:'fechaeta',index:'fechaeta', width:100, sorttype:"date", align:"center"},
	   		{name:'puntocarguio',index:'puntocarguio', width:100, align:"left"},
	   		{name:'ubicacion',index:'ubicacion', width:100, align:"left"},		
	   		{name:'destino',index:'destino', width:100,align:"Left"},		
	   		{name:'nombrenave',index:'nombrenave', width:100, sortable:false,align:"Left"},
	   		{name:'cliente',index:'cliente', width:150, sortable:false,align:"Left"},
	   		{name:'numcontenedor',index:'numcontenedor', width:100, sortable:false,align:"Center"},	   		
	   		{name:'medida',index:'medida', width:50, sortable:false,align:"Center"},
	   		{name:'pesocarga',index:'pesocarga', width:50, sortable:false,align:"Right"},
	   		{name:'condicionespecial',index:'condicionespecial', width:50, sortable:false,align:"Center"},
	   		{name:'operacion',index:'operacion', width:100, sortable:false,align:"Left"},
	   		{name:'sts_ncorr', index:'sts_ncorr', width:50, hidden:true},
	   		{name:'lug_ncorr', index:'lug_ncorr', width:50, hidden:true}		
	   	],
	   	multiselect: true,
	   	caption: "Carga no programada",
		rowNum : 20,
		rowList:[10,20,30,40,50],	   	
	   	pager: '#pagTblOrdenes',	  
        ondblClickRow: function (rowid) {
            //var lnCodOrden = $('#tblOrdenes').jqGrid('getCell', rowid, 'idsolicitud');
            //showOrden(lnCodOrden);
        },		
	    grouping: false,
	   	groupingView : {
	   		groupField : ['ubicacion'],
	   		groupColumnShow : [true],
	   		groupText : ['<b>{0} - {1} Item(s)</b>'],
	   		//groupText : ['<b>{0}</b>'],
	   		groupCollapse : true,
			groupOrder: ['asc'],
			groupSummary : [false],
			groupDataSorted : true
	   	}	       		   	
	});
	jQuery("#tblOrdenes").jqGrid('navGrid',"#pagTblOrdenes",{edit:false,add:false,del:false});

	$('#tblOrdenes').setGridParam({
		url : '../../controller/CoordinacionTransporte/CargaSinProgramar-listar.php'    		
	}).trigger("reloadGrid");	
	
	/*
	$('#tblOrdenes').setGridParam({
		url : '../../controller/CoordinacionTransporte/CargaSinProgramar-listar.php',
	   	grouping:false,
	   	groupingView : {
	   		groupField : ['ubicacion'],
	   		groupColumnShow : [true],
	   		groupText : ['Cargas : {0} - {1} Item(s)'],
	   		groupCollapse : true,
			groupOrder: ['desc']   		
	   	}    		
	}).trigger("reloadGrid");
	
	jQuery("#chngroup").change(function(){
		var vl = $(this).val();
		if(vl) {
			if(vl == "clear") {
				jQuery("#tblOrdenes").jqGrid('groupingRemove',true);
			} else {
				jQuery("#tblOrdenes").jqGrid('groupingGroupBy',vl);
			}
		}
	});
	*/
}	

function cargaCombos(){
	cargaCambo(9,"","#cboDestino",0);
	//cargaCambo(14,"","#cboTransportista",0);	
	formateaFechaHora("#txtFechaCoordinacion");
}

/*
 * Carga el combo de lugares de destino dependiendo del servicio y ubicación actual
 */
function cargaComboLugares(codServicio, codUbicacion,tsNombreCombo){
	var cuenta;
	cuenta = 0;
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/CoordinacionTransporte/comboDestinos-listar.php?codServicio="+codServicio+"&codLugar="+codUbicacion,
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	var array = data.split("|");
        	var registros = data.split("|").length;
        	console.log(registros);
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));      
            
			for (i=0; i<registros;i++){
				if (array[i]!="" && array[i].length>1){
					var valor = array[i].split(":")[0];
					var texto = array[i].split(":")[1];	
					$(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
					cuenta++;								
				}
			}
				
			if (cuenta==0){
				showMessage("Error","No hay tramos configurados para el servicio asociado a esta carga");
			}				
        }
    });		
}

/*
 * Carga el combo de la empresa asociada a la coordinacion de transporte
 */
function cargaComboEmpresa(){
	var tsNombreCombo = "#cboTransportista";
	var codDestino = $("#cboDestino").val();
	
	cargaComboEmpresas_OrigenDestino(tsNombreCombo, codDestino);
}

/*
 * Despliega pantalla de coordinacion de transporte
 */
function coordinarTransporte(){
	var cargasSeleccionadas 	= recuperaIdsSeleccionados("#tblOrdenes");	
	var sts_ncorr;
	var validacionLugar;
	var validacionServicio;
	
	_UBICACION 			= "";
	sts_ncorr 			= "";
	validacionLugar 	= true;
	validacionServicio	= true;
	
	$.each(cargasSeleccionadas, function () {
		var objeto = jQuery('#tblOrdenes').jqGrid('getRowData', this);
						
		if (_UBICACION==""){
			_UBICACION = objeto.lug_ncorr;
		}else{
			if (_UBICACION!=objeto.lug_ncorr){
				validacionLugar = false;
			}
		}
		
		if (sts_ncorr==""){
			sts_ncorr = objeto.sts_ncorr;
		}else{
			if (sts_ncorr != objeto.sts_ncorr){
				validacionServicio = false;
			}
		}
	});
	
	if (!validacionLugar || !validacionServicio){
		var lsMensaje = "Se han encontrado los siguientes errores: \n";
		if (!validacionLugar){
			lsMensaje = "- No puede seleccionar cargas de ubicaciones distintas\n";
		}
		if (!validacionServicio){
			lsMensaje = "- No puede seleccionar servicios distintos\n";
		}
		showMessage("Error",lsMensaje);					
	}else{
		cargaComboLugares(sts_ncorr,_UBICACION,"#cboDestino");

		$("#divCoordinarTransporte").dialog({
			modal:true,
			title:"Coordinar transporte",
			width:"400",
			height:"250",
			buttons:{
				"Guardar":function(){
					guardarCoordinacionTransporte();
					$( this ).dialog( "close" );
				},
				"Cerrar":function(){
					$( this ).dialog( "close" );	
				}
			}
		});			
	}		
}

/*
 * Guarda la coordinacion de transporte
 */
function guardarCoordinacionTransporte(){
	var cargasSeleccionadas 	= recuperaIdsSeleccionados("#tblOrdenes");
	var ubicacion, sts_ncorr;
	var validacionLugar;
	var validacionServicio;
	
	if (cargasSeleccionadas!=""){
		if (validaIngresoCoordinacion()){
			var fecha 			= text2dateTime($("#txtFechaCoordinacion").val());
			var codDestino		= $("#cboDestino").val();
			var codEmpresa		= $("#cboTransportista").val();
			
			ubicacion 			= "";
			sts_ncorr 			= "";
			validacionLugar 	= true;
			validacionServicio	= true;

			$.each(cargasSeleccionadas, function () {
				if (this!=""){
				    $.ajax({
				        type: "GET",
				        async:true,
				        cache:false, 
				        url: "../../controller/CoordinacionTransporte/CargaSinProgramar-ingresar.php?id="+this+"&fecha="+fecha+"&codDestino="+codDestino+"&codTransportista="+codEmpresa,
				        //dataType: "json",
				        error: function (xhr, status, error) {
				            // you may need to handle me if the json is invalid
				            // this is the ajax object
				        },
				        success: function (data) {
			            
				        }
				    });						
				}
			});
			cargaGrillaCoordinacionTransporte(false,"");
			//showMessage("Confirmacion","Registros ingresados exitosamente");
			showMessageAuxiliar("Registros ingresados exitosamente");			
		}
	}else{
		showMessage("Error","No hay cargas seleccionadas");
	}
	
}

function validaIngresoCoordinacion(){
	var texto="";
	if ($("#txtFechaCoordinacion").val()==""){
		texto = "- Fecha coordinacion\n";
	};
	/*
	if ($("#cboDestino").val()==0){
		texto += "- Destino\n";
	};
	
	if ($("#cboTransportista").val()==0){
		texto += "- Transportista\n";
	};*/
	
	if (texto==""){
		return true;
	}else{
		showMessage("Error","Falta ingesar los siguientes datos :\n" + texto);
		return false;
	}				
}
