var _PESOMINIMO = 1;
var _PESOMAXIMO = 40000;
var _TIPOCARGA;

function actualizaSubCliente(){
	var codCliente = $("#cboCliente").val();
	cargaCambo(2,codCliente,"#cboSubCliente",0);
	cargaCambo(21,codCliente,"#cboTipoServicio",0);	
}

function cargaGrillaDetalleContenedores(){  	
	var lastsel2;			
	var idContainer = $("#txtCodOrden").val();
	jQuery("#tblDetalleOrden").jqGrid({
		height: 150,
		url : '../../controller/OrdenServicio/carga-listar.php?codOrden='+idContainer,
		datatype : "json",		
		width:850,
	   	colNames:['Id', 'Estado', 'N° contenedor','Peso','Contenido','Observaciones','Sello','ADA_NCORR','CADA_NCORR','MedCont','Condicion','Retiro','Presentacion','Booking','Operacion','Marca','Contenido','TerminoStacking','CodDevolucion','DiasLibres','Contacto entrega','Temperatura','Ventilacio','Otros','esca_ncorr','car_vobservaciones','Opt'],
	   	colModel:[
	   		{name:'car_ncorr',index:'car_ncorr', width:100, sorttype:"float"},
	   		{name:'esca_vdescripcion',index:'esca_vdescripcion', width:120, align:"left"},
	   		{name:'cont_vnumcontenedor',index:'cont_vnumcontenedor', width:150, align:"left", editable:"true"},
	   		{name:'cont_npeso',index:'cont_npeso', width:100, align:"right", editable:"true"},		
	   		{name:'cont_vcontenido',index:'cont_vcontenido', width:250,align:"left", editable:"true"},
	   		{name:'car_vobservaciones',index:'car_vobservaciones', width:400,align:"left", editable:"true"},
	   		{name:'cont_vsello',index:'cont_vsello', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'ada_ncorr',index:'ada_ncorr', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'cada_ncorr',index:'cada_ncorr', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'med_ncorr',index:'med_ncorr', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'cond_ncorr',index:'cond_ncorr', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_dfecharetiro',index:'car_dfecharetiro', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_dfechapresentacion',index:'car_dfechapresentacion', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_nbooking',index:'car_nbooking', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_voperacion',index:'car_voperacion', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'cont_vmarca',index:'cont_vmarca', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'cont_vcontenido',index:'cont_vcontenido', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'cont_dterminostacking',index:'cont_dterminostacking', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'lug_ncorr_devolucion',index:'lug_ncorr_devolucion', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'cont_ndiaslibres',index:'cont_ndiaslibres', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_vcontactoentrega',index:'car_vcontactoentrega', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_ntemperatura',index:'car_ntemperatura', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_nventilacion',index:'car_nventilacion', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'car_votros',index:'car_votros', width:400,align:"left", editable:"true", hidden:true},
	   		{name:'esca_ncorr', index:'esca_ncorr', hidden:true},
	   		{name:'car_vobservaciones', index:'car_vobservaciones', hidden:true},
	   		{name:'act',index:'act', width:75,sortable:false}
	   	],
	   	multiselect: false,
	   	caption: "Contenedores",
	   	emptyrecords: "No hay datos",
	   	viewrecords: true,
	   	rownum: 100,
	   	ondblClickRow : function(rowid){
	   		showFormContainer(rowid);	
	   	},
		/*onSelectRow : function(id) {			            
			showFormContainer(id);			
		},*/	
		loadComplete: function() {
			cargaGrillaDetalleCargaLibre();
		},
		gridComplete: function(){
			 var rows= jQuery("#tblDetalleOrden").jqGrid('getRowData');	
			 for(var i=0;i<rows.length;i++){
			 	var row=rows[i];
			 	if(Number(row['esca_ncorr'])==1){
			 		var idCarga = Number(row['car_ncorr']);
			 		be = "<img src='img/ico_delete.png' onclick='deleteContainer("+ idCarga+")'>";
			 		jQuery("#tblDetalleOrden").jqGrid('setRowData',idCarga,{act:be});	
			 	}
			 };
		}									   	
	});

	$('#tblDetalleOrden').setGridParam({
		url : '../../controller/OrdenServicio/carga-listar.php?codOrden='+idContainer
	}).trigger("reloadGrid");
}

function validaIngresoOrdenServicio(){
	var texto="";
	if ($("#txtFechaOrdenServicio").val()==""){
		texto = "- Fecha orden de servicio\n";
	};
	
	if ($("#cboCliente").val()==0){
		texto += "- Cliente\n";
	};	
	
	if ($("#cboSubCliente").val()==0){
		texto += "- Subcliente\n";
	};	

	if ($("#cboTipoServicio").val()==0){
		texto += "- Tipo de servicio\n";
	};
	
	if ($("#cboSubTipoServicio").val()==0){
		texto += "- Subtipo de servicio\n";
	};	
	
	if ($("#cboLugarRetiro").val()==0){
		texto += "- Lugar de retiro\n";
	};	
	
	if ($("#cboPuertoCarguio").val()==0){
		texto += "- Lugar de carguio\n";
	};	
	
	if ($("#cboLugarDestino").val()==0){
		texto += "- Lugar de destino\n";
	};	
	
	if (texto==""){
		return true;
	}else{
		showMessage("Error","Falta ingesar los siguientes datos :\n" + texto);
		return false;
	}			
	
}

function validaIngresoContainer(){
	var texto="";
	if ($("#txtContenedor_Container").val()==""){
		texto = "- N° de contenedor\n";
	}else{
		var resultadoValidacion = validaISO9636($("#txtContenedor_Container").val());
		if (resultadoValidacion!="OK"){
			texto = " - N° de contenedor incorrecto";
		}
	};
	
	if ($("#txtSello_Container").val()==""){
		texto += "- Sello del container\n";
	};	

	/*
	if ($("#cboAgencia").val()==0){
		texto += "- Agencia de aduana\n";
	};	

	
	if ($("#cboContactoAgencia").val()==0){
		texto += "- Contacto de agencia\n";
	};*/	

	if ($("#txtPesoCarga_Container").val()==""){
		texto += "- Peso de carga\n";
	}else{
		var lnPeso = $("#txtPesoCarga_Container").val();
		if (lnPeso< _PESOMINIMO){
			texto += "- El peso no puede ser menor a " + _PESOMINIMO +" Kg\n";
		}else{
			if (lnPeso> _PESOMAXIMO){
				texto += "- El peso no puede ser mayor a " + _PESOMAXIMO +" Kg\n";
			}
		}
	};	

	/*
	if ($("#cboLugarDevolucion_Container").val()==0){
		texto += "- Lugar devolucion\n";
	};*/

	if ($("#cboMedidasContenedor").val()==0){
		texto += "- Medidas del contenedor\n";
	};	

	if ($("#cboCondicionEspecial").val()==0){
		texto += "- Condicion especial\n";
	};

	/*
	if ($("#txtFechaRetiro_Container").val()==""){
		texto += "- Fecha de retiro\n";
	};
	
	if ($("#txtFechaPresentacion_Container").val()==""){
		texto += "- Fecha de presentacion\n";
	};		
	*/
	
	if (texto==""){
		return true;
	}else{
		showMessage("Error","Falta ingesar los siguientes datos :\n" + texto);
		return false;
	}		
		
}

function validaIngresoCargaLibre(){
	var texto="";
	if ($("#txtCantidad_CargaLibre").val()==""){
		texto = "- Cantidad\n";
	};
	
	if ($("#cboUnidadMedida_CargaLibre").val()==0){
		texto += "- Unidad de medida\n";
	};
	
	/*
	if ($("#txtFechaCarguio_CargaLibre").val()==""){
		texto += "- Fecha de carguio\n";
	};
	
	if ($("#txtFechaEntrega_CargaLibre").val()==""){
		texto += "- Fecha de entrega\n";
	};*/			
	
	if (texto==""){
		return true;
	}else{
		showMessage("Error","Falta ingesar los siguientes datos :\n" + texto);
		return false;
	}				
}

/*
 * Carga la grilla de detalle de carga libre
 */
function cargaGrillaDetalleCargaLibre(){  		
	var lastsel2;			
	var idContainer = $("#txtCodOrden").val();
	jQuery("#tblDetalleCargaLibre").jqGrid({
		height: 150,
		url : '../../controller/OrdenServicio/cargalibre-listar.php?codOrden='+idContainer,
		datatype : "json",		
		width:850,
	   	colNames:['Id', 'Estado', 'Cantidad','UM','Observaciones','codUm','Fecharetiro','FechaPresentacion','Contactoentrega','car_nbooking','car_voperacion','esca_ncorr','Opt'],
	   	colModel:[
	   		{name:'car_ncorr',index:'car_ncorr', width:100, sorttype:"float"},
	   		{name:'esca_vdescripcion',index:'esca_vdescripcion', width:100, sorttype:"date", align:"left"},
	   		{name:'car_cantidad',index:'car_cantidad', width:150, align:"right", editable:"false"},
	   		{name:'im_vdescripcion',index:'im_vdescripcion', width:150, align:"right", editable:"true"},		
	   		{name:'car_vobservaciones',index:'car_vobservaciones', width:300,align:"left", editable:"true"},
	   		{name:'um_ncorr', index:'um_ncorr',hidden:true}	,
	   		{name:'car_dfecharetiro',index:'car_dfecharetiro',hidden:true},
	   		{name:'car_dfechapresentacion',index:'car_dfechapresentacion',hidden:true},
	   		{name:'car_vcontactoentrega',index:'car_vcontactoentrega',hidden:true},
	   		{name:'car_nbooking',index:'car_nbooking',hidden:true},
	   		{name:'car_voperacion', index:'car_voperacion',hidden:true},
	   		{name:'esca_ncorr', index:'esca_ncorr',hidden:true},	   		
	   		{name:'act',index:'act', width:75,sortable:false}
	   	],
	   	multiselect: false,
	   	caption: "Carga libre",
	   	emptyrecords: "No hay datos",
	   	viewrecords: true,
	   	ondblClickRow : function(rowid){
	   		showFormCargaLibre(rowid);	
	   	},
		loadComplete: function() {

		},	
		gridComplete: function(){
			 var rows= jQuery("#tblDetalleCargaLibre").jqGrid('getRowData');	
			 for(var i=0;i<rows.length;i++){
			 	var row=rows[i];
			 	if(Number(row['esca_ncorr'])==1){
			 		var idCarga = Number(row['car_ncorr']);
			 		be = "<img src='img/ico_delete.png' onclick='deleteCargaLibre("+ idCarga+")'>";
			 		jQuery("#tblDetalleCargaLibre").jqGrid('setRowData',idCarga,{act:be});	
			 	}
			 };			
		}								   	
	});

	$('#tblDetalleCargaLibre').setGridParam({
		url : '../../controller/OrdenServicio/cargalibre-listar.php?codOrden='+idContainer
	}).trigger("reloadGrid");	
	
	
			
	jQuery("#tblDetalleCargaLibre").jqGrid({
		datatype: "local",
		height: 150,
		//autowidth : true,
		width:850,
	   	colNames:['Id', 'Estado', 'Cantidad','Tipo','Peso','Booking','AGA'],
	   	colModel:[
	   		{name:'idsolicitud',index:'idsolicitud', width:100, sorttype:"float"},
	   		{name:'estado',index:'estado', width:150, sorttype:"date", align:"left"},
	   		{name:'cantidad',index:'cantidad', width:50, align:"right"},
	   		{name:'tipo',index:'tipo', width:100, align:"left"},		
	   		{name:'peso',index:'peso', width:50,align:"right",sorttype:"float"},		
	   		{name:'booking',index:'booking', width:100, sortable:false},
	   		{name:'AGA',index:'AGA', width:100, sortable:false}		
	   	],
	   	multiselect: false,
	   	caption: "Carga libre"
	});
	
	var mydata = [
			{idsolicitud:"<img src='img/ico_delete.png' /> <img src='img/ico_edit.png' /> 1000",estado:"Ingresada",cantidad:"1",tipo:"Container",peso:"10",booking:'-',AGA:"-"},
			{idsolicitud:"<img src='img/ico_delete.png' /> <img src='img/ico_edit.png' /> 1001",estado:"Programada",cantidad:"1",tipo:"Container",peso:"10",booking:'-',AGA:"-"},
			{idsolicitud:"<img src='img/ico_delete.png' /> <img src='img/ico_edit.png' /> 1002",estado:"En traslado",cantidad:"1",tipo:"Carga libre",peso:"10",booking:'-',AGA:"-"}						
			];
	for(var i=0;i<=mydata.length;i++)  		
		jQuery("#tblDetalleCargaLibre").jqGrid('addRowData',i+1,mydata[i]);
}  			



function cargaCombos(){
	//Combos de la orden de servicio
	cargaCambo(1,"","#cboCliente",0);
	
	//cargaCambo(3,"","#cboTipoServicio",0);
	cargaCambo(4,"","#cboSubTipoServicio",0);
	cargaCambo(11,"","#cboLugarRetiro",0);
	cargaCambo(13,"","#cboLugarDestino",0);	
	cargaCambo(12,"","#cboPuertoCarguio",0);
		
	//Combos del detalle de la orden de servicio
	cargaCambo(5,"","#cboAgencia",0);	
	cargaCambo(6,0,"#cboContactoAgencia",0);
	cargaCambo(7,"","#cboMedidasContenedor",0);
	cargaCambo(8,"","#cboCondicionEspecial",0);
	cargaCambo(9,"","#cboLugarDevolucion_Container",0);		
}

/*
 * Carga los subtipos de servicio
 */
function cargaSubTipoServicio(){
	var codTipoNegocio 	= $("#cboTipoServicio").val();
	var tsNombreCombo 	= "#cboSubTipoServicio";
	var codCliente 		= $("#cboCliente").val();
		
    $.ajax({
        type: "GET",
        async:true,
        cache:false, 
        url: "../../controller/OrdenServicio/comboTipoServicio-listar.php?codCliente="+codCliente+"&codTipoNegocio="+codTipoNegocio,
        //dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	var array = data.split("|");
        	var registros = data.split("|").length;
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));      
            
			for (i=0; i<registros;i++){
				if (array[i]!="" && array[i].length>1){
					var valor = array[i].split(":")[0];
					var texto = array[i].split(":")[1];
					$(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
				}
			}        	
        }
    });	
		
}

function cargaSubTipoServicioCargado(valorSeleccionar){
    var codTipoNegocio  = $("#cboTipoServicio").val();
    var tsNombreCombo   = "#cboSubTipoServicio";
    var codCliente      = $("#cboCliente").val();
        
    $.ajax({
        type: "GET",
        async:true,
        cache:false, 
        url: "../../controller/OrdenServicio/comboTipoServicio-listar.php?codCliente="+codCliente+"&codTipoNegocio="+codTipoNegocio,
        //dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
            var array = data.split("|");
            var registros = data.split("|").length;
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));      
            
            for (i=0; i<registros;i++){
                if (array[i]!="" && array[i].length>1){
                    var valor = array[i].split(":")[0];
                    var texto = array[i].split(":")[1];
                    
                    if (valorSeleccionar == valor){
                        $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto).attr("selected", "selected"));                        
                    }else{
                        $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
                    }
                    
                    
                }
            }           
        }
    }); 
        
}

/*
 * Cierra el formulario de importacion de carga
 */
function cierraImportacionCarga(){
    $("#divFormCargaLibre").dialog( "close" );
}


/*
 * Obtiene los origenes y destinos del servicio seleccionado
 */
function cargaOrigenDestino(){
	var codServicio 	= $("#cboSubTipoServicio").val();

    $.ajax({
        type: "GET",
        async:true,
        cache:false, 
        url: "../../controller/OrdenServicio/viaje-listar.php?codTipoServicio="+codServicio,
        //dataType: "json",
        error: function (xhr, status, error) {
        },
        success: function (data) {
        	//var array = data.split("|");
        	var data2 = data.replace('"','');
        	var codOrigen 	= data2.split("|")[0].replace('"','');
        	var codDestino	= data2.split("|")[1].replace('"','');
			cargaCambo(11,"","#cboLugarRetiro",codOrigen);
			cargaCambo(13,"","#cboLugarDestino",codDestino);
			console.log(codOrigen);	
			cargaCambo(24,codOrigen,"#cboPuertoCarguio",0);
        	
        }
    });	
	
}

/*
 * Elimina un registro de carga libre
 */
function deleteCargaLibre(idCarga) {
	var r = confirm("¿Esta seguro de eliminar el registro seleccionado");
	if (r == true) {
		x = "Carga eliminada correctamente";
	    $.ajax({
	        type: "GET",
	        async:false,
	        cache:false, 
	        url: "../../controller/OrdenServicio/carga-eliminar.php?id="+idCarga,
	        //dataType: "json",
	        error: function (xhr, status, error) {
	            // you may need to handle me if the json is invalid
	            // this is the ajax object
	        },
	        success: function (data) {
	        	cargaGrillaDetalleCargaLibre();
	        }
	    });			
		
	} else {
		//x = "You pressed Cancel!";
	}
}

/*
 * Elimina un container de la orden de servicio
 */
function deleteContainer(idContainer){
	var r = confirm("¿Esta seguro de eliminar el registro seleccionado");
	if (r == true) {
		x = "Carga eliminada correctamente";
	    $.ajax({
	        type: "GET",
	        async:false,
	        cache:false, 
	        url: "../../controller/OrdenServicio/carga-eliminar.php?id="+idContainer,
	        //dataType: "json",
	        error: function (xhr, status, error) {
	            // you may need to handle me if the json is invalid
	            // this is the ajax object
	        },
	        success: function (data) {
	        	cargaGrillaDetalleContenedores();
	        }
	    });			
		
	} else {
		//x = "You pressed Cancel!";
	}
}

/*
 * Formatea fecha de orden de servicio
 */
function formateaFechas(){
	formateaFecha("#txtFechaOrdenServicio");
	formateaFecha("#txtFechaRetiro_Container");
	formateaFecha("#txtFechaPresentacion_Container");
	formateaFecha("#txtTerminoStacking_Container");
	formateaFecha("#txtFechaCarguio_CargaLibre");
	formateaFecha("#txtFechaEntrega_CargaLibre");		
}

function guardaContainer(){
	if (validaIngresoContainer()){
		var idCarga				= $("#lblCodCarga").text();
		var codOrdenServicio	= $("#txtCodOrden").val();
		var codEstadoCarga		= 1;
		var codTipoCarga		= 1;
		var numBooking			= $("#txtBooking_Container").val();
		var operacion			= $("#txtOperacion_Container").val();
		var observaciones		= $("#txtObservaciones_Container").val();
		var marca				= $("#txtMarca_Container").val();
		var numcontainer		= $("#txtContenedor_Container").val();
		var	contenido			= $("#txtContenido_Container").val();
		var terminostacking		= $("#txtTerminoStacking_Container").val();
		var lugardevolucion		= $("#cboLugarDevolucion_Container").val();
		var diaslibres			= $("#txtDiasLibres_Container").val()==""?0:$("#txtDiasLibres_Container").val();
		var sello				= $("#txtSello_Container").val();
		var ada					= $("#cboAgencia").val();
		var cada				= 0;//$("#cboContactoAgencia").val();
		var pesoContainer		= $("#txtPesoCarga_Container").val();
		var medidaContainer		= $("#cboMedidasContenedor").val();
		var condicionEspecial	= $("#cboCondicionEspecial").val();
		var fecharetiro			= text2date($("#txtFechaRetiro_Container").val());
		var fechapresentacion	= text2date($("#txtFechaPresentacion_Container").val());
		var contactoentega		= $("#txtContactoEntrega_Container").val();
		var temperatura			= $("#txtTemperatura_Container").val();
		var ventilacion			= $("#txtVentilacion_Container").val();
		var otros				= $("#txtOtros_Container").val();
		
		guarda_info_carga(idCarga,codOrdenServicio,codEstadoCarga,codTipoCarga,numBooking,operacion,observaciones);
				
		if (idCarga==0){
			var ultimaCarga = obtieneUltimaCarga(codOrdenServicio);
			idCarga = ultimaCarga;
		}
		
		guarda_info_container(idCarga,marca,numcontainer,contenido,terminostacking, lugardevolucion, diaslibres, sello, ada, cada,pesoContainer,medidaContainer,condicionEspecial);
		guarda_info_traslado(idCarga,fecharetiro,fechapresentacion,contactoentega);
		guarda_info_adicional(idCarga,temperatura,ventilacion,otros,"");
		
		$("#divFormContainer").dialog( "close" );
		cargaGrillaDetalleContenedores();
		
		showMessage("Confirmacion","Información almacenada correctamente");
		showMessageAuxiliar("Container almacenado exitosamente");
		return true;
	}else{
		return false;
	}
}

function guarda_info_adicional(idCarga, temperatura, ventilacion, otros, observaciones){
	
	if (temperatura!="" || ventilacion!="" || otros !=""){
		var p01 = idCarga;
		var p02 = temperatura==""?"NULL":temperatura;
		var p03 = ventilacion==""?"NULL":ventilacion;
		var p04 = otros;
		var p05 = observaciones;		
		
	    $.ajax({
	        type: "GET",
	        async:true,
	        cache:false, 
	        url: "../../controller/OrdenServicio/info_adicional-ingresar.php?p01="+p01+"&p02="+p02+"&p03="+p03+"&p04="+p04+"&p05="+p05,
	        //dataType: "json",
	        error: function (xhr, status, error) {
	            // you may need to handle me if the json is invalid
	            // this is the ajax object
	        },
	        success: function (data) {
	        	if (data==1){	        			        		
	        		return true;
	        	}else{
	        		return false;
	        	}
	        }
	    });			
		
	}
}

function guarda_info_container(	idCarga, marca, numcontenedor, contenido, terminostacking, lugardevolucion, 
								diaslibres,sello, ada, cada, peso, med, cond){

	var p01 = idCarga;
	var p02 = marca;
	var p03 = numcontenedor;
	var p04 = contenido;
	var p05 = terminostacking;
	var p06 = lugardevolucion;
	var p07 = diaslibres;
	var p08 = sello;
	var p09 = ada;
	var p10 = cada;
	var p11 = peso;
	var p12 = med;
	var p13 = cond;
	
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/OrdenServicio/info_container-ingresar.php?p01="+p01+"&p02="+p02+"&p03="+p03+"&p04="+p04+"&p05="+p05+"&p06="+p06+"&p07="+p07+"&p08="+p08+"&p09="+p09+"&p10="+p10+"&p11="+p11+"&p12="+p12+"&p13="+p13,
        //dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	if (data==1){	        			        		
        		return true;
        	}else{
        		return false;
        	}
        }
    });		
}


function guarda_info_carga(idCarga, codOrdenServicio, codEstadoCarga, codTipoCarga, numBooking, operacion, observaciones){
	var p01 = idCarga;
	var p02 = codOrdenServicio;
	var p03 = codEstadoCarga;
	var p04 = codTipoCarga;
	var p05 = numBooking;
	var p06 = operacion;
	var p07 = observaciones;
	
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/OrdenServicio/detallecarga-ingresar.php?p01="+p01+"&p02="+p02+"&p03="+p03+"&p04="+p04+"&p05="+p05+"&p06="+p06+"&p07="+p07,
        //dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	return data.car_ncorr;
        }
    });	
}

function guarda_info_cargalibre(idCarga, um, cantidad){
	var p01 = idCarga;
	var p02 = um;
	var p03 = cantidad;
	
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/OrdenServicio/info_cargalibre-ingresar.php?p01="+p01+"&p02="+p02+"&p03="+p03,
        //dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	return 1;
        }
    });		
}

function guarda_info_traslado(idCarga, fecharetiro, fechapresentacion, contactoentrega){
	var p01 = idCarga;
	var p02 = fecharetiro;
	var p03 = fechapresentacion;
	var p04 = contactoentrega;
		
    $.ajax({
        type: "GET",
        async:true,
        cache:false, 
        url: "../../controller/OrdenServicio/info_traslado-ingresar.php?p01="+p01+"&p02="+p02+"&p03="+p03+"&p04="+p04,
        //dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	return 1;
        }
    });		
}

function guardaCargaLibre(){
	if (validaIngresoCargaLibre()){
		var idCarga				= $("#lblIdCarga_CargaLibre").text();
		var codOrdenServicio	= $("#txtCodOrden").val();
		var codEstadoCarga		= 1;
		var codTipoCarga		= 2;
		var numBooking			= $("#txtNumBooking_CargaLibre").val();
		var operacion			= $("#txtNumOperacion_CargaLibre").val();
		var observaciones		= $("#txtObservaciones_CargaLibre").val();
		var um					= $("#cboUnidadMedida_CargaLibre").val();
		var cantidad			= $("#txtCantidad_CargaLibre").val();
		var fechaRetiro			= text2date($("#txtFechaCarguio_CargaLibre").val());
		var fechaPresentacion	= text2date($("#txtFechaEntrega_CargaLibre").val());
		var contactoEntrega		= $("#txtContactoEntrega_CargaLibre").val();
		
		guarda_info_carga(idCarga,codOrdenServicio,codEstadoCarga,codTipoCarga,numBooking,operacion,observaciones);
		
		if (idCarga==0){
			var ultimaCarga = obtieneUltimaCarga(codOrdenServicio);
			idCarga = ultimaCarga;
		}		
		
		guarda_info_cargalibre(idCarga,um,cantidad);
		guarda_info_traslado(idCarga,fechaRetiro, fechaPresentacion, contactoEntrega);
		
		$("#divFormCargaLibre").dialog( "close" );
		cargaGrillaDetalleCargaLibre();
		
		//showMessage("Confirmacion","Información almacenada correctamente");
		showMessageAuxiliar("Carga almacenada exitosamente");
		return true;
	}else{
		return false;
	}
}

function guardarOrdenServicio(){	
	if (validaIngresoOrdenServicio()){

		var p01 = $("#txtCodOrden").val();
		var p02 = text2date($("#txtFechaOrdenServicio").val());
		var p03 = $("#cboCliente").val();
		var p04 = $("#cboSubCliente").val();
		var p05 = $("#cboTipoServicio").val();
		var p06 = $("#cboSubTipoServicio").val();
		var p07 = $("#txtNave").val();
		var p08 = $("#cboLugarRetiro").val();
		var p09 = $("#cboPuertoCarguio").val();
		var p10 = $("#cboLugarDestino").val();
		var p11 = $("#txtObservaciones").val();		
		var p12 = $("#txtCodUsuario").val();
	
	    $.ajax({
	        type: "GET",
	        async:true,
	        cache:false, 
	        url: "../../controller/OrdenServicio/ordenservicio-ingresar.php?p01="+p01+"&p02="+p02+"&p03="+p03+"&p04="+p04+"&p05="+p05+"&p06="+p06+"&p07="+p07+"&p08="+p08+"&p09="+p09+"&p10="+p10+"&p11="+p11+"&p12="+p12,
	        //dataType: "json",
	        error: function (xhr, status, error) {
	            // you may need to handle me if the json is invalid
	            // this is the ajax object
	        },
	        success: function (data) {
	        	cargaGrillaOrdenesServicio();
	        	if (data==1){	        		
					$("#formOrdenServicio").dialog( "close" );	
					showMessage("Confirmacion","Orden ingresada correctamente");	
					showMessageAuxiliar("Orden ingresada correctamente");
							        		
	        		return true;
	        	}else{
	        		return false;
	        	}
	        }
	    });	
		
	}else{
		return false;
	}	
}

/*
 * Carga la grilla con las ordenes de servicio
 */
function cargaGrillaOrdenesServicio(){
	var alto = $( document ).height() - 120;
	
	jQuery("#tblOrdenes").jqGrid({
		url : '../../controller/OrdenServicio/ordenservicio-listar.php',
		datatype : "json",
		height : alto,
		autowidth : true,
	   	colNames:['Id', 'Fecha', 'Cliente','Servicio','Items','Estado','Rut','Subrut','Tise_ncorr','STS_Ncorr','Vendedor','Nave','Observaciones','lug_ncorrorigen','lug_ncorrdestino','lug_ncorr_puntocarguio','usua_ncorr'],
	   	colModel:[
	   		{name:'ose_ncorr',index:'ose_ncorr', width:20, sorttype:"float", sortable:true, align:"center"},
	   		{name:'ose_dfechaservicio',ose_dfechaservicio:'fecha', width:50, sorttype:"date", align:"center", sortable:false},
	   		{name:'clie_vnombre',index:'clie_vnombre', width:100, align:"left", sortable:true},
	   		{name:'tise_vdescripcion',index:'tise_vdescripcion', width:150, align:"left", sortable:true},		
	   		{name:'items',index:'items', width:20,align:"center",sorttype:"float", sortable:false},		
	   		{name:'esca_vdescripcion',index:'esca_vdescripcion', width:50, sortable:false, hidden:true},
	   		{name:'clie_vrut',index:'clie_vrut', hidden:true},
	   		{name:'CLIE_VRUTSUBCLIENTE',index:'CLIE_VRUTSUBCLIENTE', hidden:true},
	   		{name:'TISE_NCORR',index:'TISE_NCORR', hidden:true},
	   		{name:'STS_NCORR',index:'STS_NCORR', hidden:true},
	   		{name:'vendedor',index:'vendedor', hidden:false, width:100},
	   		{name:'ose_vnombrenave',index:'ose_vnombrenave',hidden:true},	   		
	   		{name:'ose_vobservaciones',index:'ose_vobservaciones', hidden:false},
	   		{name:'lug_ncorrorigen',index:'lug_ncorrorigen',hidden:true},
	   		{name:'lug_ncorrdestino',index:'lug_ncorrdestino',hidden:true},
	   		{mame:'lug_ncorrcarguio',index:'lug_ncorrcarguio',hidden:true},
	   		{name:'usua_ncorr', index:'usua_ncorr',hidden:true}
	   	],
		rowNum : 20,
		rowList:[20,30,40,50],
		pager: '#pagTblOrdenes',	   	
	   	//multiselect: false,
	   	loadtext: "<img src='img/ico_Loading.gif'>Cargando ordenes de servicio",
	   	caption: "Ordenes de servicio",
	    onComplete: function(data, response) {
	          showMessageAuxiliar("Modulo de ordenes de servicio inicializado correctamente");
	    },	   	
        ondblClickRow: function (rowid) {
            var lnCodOrden 			= $('#tblOrdenes').jqGrid('getCell', rowid, 'ose_ncorr');
            var lsFecha 			= $('#tblOrdenes').jqGrid('getCell', rowid, 'ose_dfechaservicio');
            var lnRutCliente 		= $('#tblOrdenes').jqGrid('getCell', rowid, 'clie_vrut');
            var lnRutSubCliente 	= $('#tblOrdenes').jqGrid('getCell', rowid, 'CLIE_VRUTSUBCLIENTE');
            var lnTipoServicio 		= $('#tblOrdenes').jqGrid('getCell', rowid, 'TISE_NCORR');
            var lnSubTipoServicio	= $('#tblOrdenes').jqGrid('getCell', rowid, 'STS_NCORR');     
            var lsNombreNave 		= $('#tblOrdenes').jqGrid('getCell', rowid, 'ose_vnombrenave');
            var lsNombreVendedor 	= $('#tblOrdenes').jqGrid('getCell', rowid, 'vendedor');   
            var lsObservaciones 	= $('#tblOrdenes').jqGrid('getCell', rowid, 'ose_vobservaciones');
            var codOrigen 			= $('#tblOrdenes').jqGrid('getCell', rowid, 'lug_ncorrorigen');
            var codCarga 			= $('#tblOrdenes').jqGrid('getCell', rowid, 15);
            var codDestino 			= $('#tblOrdenes').jqGrid('getCell', rowid, 'lug_ncorrdestino');
            var codUsuario          = $('#tblOrdenes').jqGrid('getCell', rowid, 16);
            
            showMessageAuxiliar("Abriendo orden de servicio");                 
            showOrden(lnCodOrden, lsFecha, lnRutCliente, lnRutSubCliente, lnTipoServicio, lnSubTipoServicio, lsNombreNave, lsNombreVendedor, lsObservaciones, codOrigen, codDestino, codCarga, codUsuario);
        }				   	
	});
	
	jQuery("#tblOrdenes").jqGrid('navGrid',"#pagTblOrdenes",{edit:false,add:false,del:false});
	
	$('#tblOrdenes').setGridParam({
		url : '../../controller/OrdenServicio/ordenservicio-listar.php'
	}).trigger("reloadGrid");	
}	

function showOrden(idOrden){
	showOrden(0,"","","","","","","","","","","","",0);
}

function showOrden(idOrden, Fecha, RutCliente, RutSubCliente, TipoServicio, SubTipoServicio, NombreNave, NombreVendedor, Observaciones, codOrigen, codDestino, codCarguio, codUsuario){
	$("#divBarraCarga").fadeIn();
	if (idOrden>0){
		$("#txtCodOrden").val(idOrden);
		$("#txtFechaOrdenServicio").val(Fecha);	
		$("#txtNave").val(NombreNave);
		$("#lblVendedor").text(NombreVendedor);
		$("#cboCliente").val(RutCliente);
		$("#cboTipoServicio").val(TipoServicio);
		$("#txtObservaciones").val(Observaciones);
		$("#cboLugarRetiro").val(codOrigen);
		$("#cboPuertoCarguio").val(codCarguio);
		$("#cboLugarDestino").val(codDestino);
		$("#txtCodUsuario").val(codUsuario);
		
		cargaCambo(1,"","#cboSubCliente",RutCliente);
		cargaComboSincrono(21,RutCliente,"#cboTipoServicio",TipoServicio); 
		cargaSubTipoServicioCargado(SubTipoServicio);
		//cargaCambo(4,TipoServicio,"#cboSubTipoServicio",SubTipoServicio);	
	}else{
		$("#txtCodOrden").val(0);
		$("#txtFechaOrdenServicio").val(getFecha());	
		$("#txtNave").val("");
		$("#lblVendedor").text("");	
		$("#cboCliente").val(0);
		$("#cboTipoServicio").val(0);
		$("#cboSubTipoServicio").val(0);
		$("#cboSubCliente").val(0);		
		$("#txtObservaciones").val("");
		$("#cboLugarRetiro").val(0);
		$("#cboPuertoCarguio").val(0);
		$("#cboLugarDestino").val(0);
		$("#txtCodUsuario").val(0);									
	}

	cargaGrillaDetalleContenedores();
	$("#divBarraCarga").fadeOut();
	
	$("#formOrdenServicio").dialog({
		modal:true,
		title:"Orden de servicio",
		width:"950",
		height:"600",
		buttons:{
			"Guardar":function(){
				if (guardarOrdenServicio()==true){
				}
			},
			"Cerrar":function(){
				$( this ).dialog( "close" );	
			}
		}
	});	
}


function setearImportacionCarga(){
    var enviado;
    
    //$(".messages").hide();
    //queremos que esta variable sea global
    var fileExtension = "";
    //función que observa los cambios del campo file y obtiene información
    $(':file').change(function()
    {
        enviado = false;
        console.log("test file_change");
        //obtenemos un array con los datos del archivo
        var file = $("#imagen")[0].files[0];
        console.log("file :" + file);
        //obtenemos el nombre del archivo
        var fileName = file.name;
        console.log("filename :" + fileName);
        //obtenemos la extensión del archivo
        fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1);
        console.log("extension :" + fileExtension);
        //obtenemos el tamaño del archivo
        var fileSize = file.size;
        //obtenemos el tipo de archivo image/png ejemplo
        var fileType = file.type;
        //mensaje con la información del archivo
        showMessageAuxiliar("Archivo para subir: "+fileName+", peso total: "+fileSize+" bytes.");
        //showMessage("<span class='info'>Archivo para subir: "+fileName+", peso total: "+fileSize+" bytes.</span>");
    });

    $(':button').click(function(){
        showlog("Boton enviar");
        var formData = new FormData($(".formulario")[0]);
        var message = "";   
        
        var file = $("#imagen")[0].files[0];
        var fileName = file.name;
        fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1);
        showlog("extension :" + fileExtension);
        //obtenemos el tamaño del archivo        
        
        if (fileExtension=="csv"){
            if (enviado==false){
                
                $.ajax({
                    url         : '../../controller/OrdenServicio/subirArchivo.php?tipo='+_TIPOCARGA,  
                    type        : 'POST',
                    data        : formData,
                    cache       : false,
                    contentType : false,
                    processData : false,
                    async       : false,
                    beforeSend: function(){
                        showMessageAuxiliar("Subiendo la imagen, por favor espere...");
                    },
                    success: function(data){
                        enviado = true;
                        showMessageAuxiliar("El archivo ha subido correctamente.");
                        //showlog(data);
                        showMessage("Importacion",data);
                        $("#divImportarArchivo").dialog("close");
                        if (_TIPOCARGA==1){
                            cargaGrillaDetalleContenedores();    
                        }else{
                            cargaGrillaDetalleCargaLibre();
                        }
                        
                    },
                    //si ha ocurrido un error
                    error: function(){
                        //showMessage("Ha ocurrido un error");
                    }
                });
            }
        }else{
            showMessage("Error","Tipo de archivo incorrecto");
        }
    });    
}

function showFormCargaLibre(rowid){
    _TIPOCARGA = 2;
	$("#lblIdCarga_CargaLibre").text(rowid);
	if (rowid>0){
		$("#lblEstado_CargaLibre").text($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'esca_vdescripcion'));		
		$("#txtCantidad_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_cantidad'));
		$("#car_vobservaciones").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_vobservaciones'));
		var codUM = $('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'um_ncorr');
		cargaCambo(10,"","#cboUnidadMedida_CargaLibre",codUM);
		$("#txtFechaCarguio_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_dfecharetiro'));
		$("#txtFechaEntrega_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_dfechapresentacion'));
		$("#txtContactoEntrega_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_vcontactoentrega'));
		$("#txtNumBooking_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_nbooking'));
		$("#txtNumOperacion_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_voperacion'));
		$("#txtObservaciones_CargaLibre").val($('#tblDetalleCargaLibre').jqGrid('getCell', rowid, 'car_vobservaciones'));
		
	}else{
		$("#lblEstado_CargaLibre").text("Sin ingresar");		
		$("#txtCantidad_CargaLibre").val("");
		$("#car_vobservaciones").val("");
		cargaCambo(10,"","#cboUnidadMedida_CargaLibre",0);
		$("#txtFechaCarguio_CargaLibre").val("");
		$("#txtFechaEntrega_CargaLibre").val("");
		$("#txtContactoEntrega_CargaLibre").val("");
		$("#txtNumBooking_CargaLibre").val("");
		$("#txtNumOperacion_CargaLibre").val("");
		$("#txtObservaciones_CargaLibre").val("");
		
	}
	
	$("#divFormCargaLibre").dialog({
		modal:true,
		title:"Carga libre",
		width:"450",
		height:"400",
		buttons:{
			"Guardar":function(){
				if (guardaCargaLibre()){
					$("#divFormCargaLibre").dialog( "close" );
				}
			},
			"Cerrar":function(){
				$( this ).dialog( "close" );
			}
		}
	});	
}

function showFormContainer(rowid){	
    _TIPOCARGA = 1;
	if (rowid>0){
		$("#lblCodCarga").text(rowid);
		$("#txtContenedor_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_vnumcontenedor'));
		$("#txtObservaciones_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_vobservaciones'));
		$("#txtSello_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_vsello'));
		var pesoCarga = $('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_npeso');
		$("#txtPesoCarga_Container").val(pesoCarga.split(' ')[0]);
		$("#txtFechaRetiro_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_dfecharetiro'));
		$("#txtFechaPresentacion_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_dfechapresentacion'));
		
		$("#txtBooking_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_nbooking'));
		$("#txtOperacion_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_voperacion'));
		$("#txtMarca_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_vmarca'));
		$("#txtContenido_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_vcontenido'));		
		$("#txtTerminoStacking_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_dterminostacking'));
		//$("#txtLugarDevolucion_Container").val();
		$("#txtDiasLibres_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'cont_ndiaslibres'));
		$("#txtContactoEntrega_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_vcontactoentrega'));
		$("#txtTemperatura_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_ntemperatura'));
		$("#txtVentilacion_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_nventilacion'));
		$("#txtOtros_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_votros'));
		
		var codAgencia = $('#tblDetalleOrden').jqGrid('getCell', rowid, 'ada_ncorr');
		var codMedida = $('#tblDetalleOrden').jqGrid('getCell', rowid, 'med_ncorr');
		var codCondicion = $('#tblDetalleOrden').jqGrid('getCell', rowid, 'cond_ncorr');
		var codLugarDevolucion = $('#tblDetalleOrden').jqGrid('getCell', rowid, 'lug_ncorr_devolucion');
		$("#cboAgencia").val(codAgencia);
		$("#cboMedidasContenedor").val(codMedida);
		$("#cboCondicionEspecial").val(codCondicion);
		$("#cboLugarDevolucion_Container").val(codLugarDevolucion);
		cargaCambo(6,codAgencia,"#cboContactoAgencia",codAgencia);
		$("#txtObservacionesTraslado_Container").val($('#tblDetalleOrden').jqGrid('getCell', rowid, 'car_vobservaciones'));
		$("#lblEstadoContainer").text($('#tblDetalleOrden').jqGrid('getCell', rowid, 'esca_vdescripcion'));
	}else{
		$("#lblCodCarga").text(0);
		$("#txtContenedor_Container").val("");
		$("#txtObservaciones_Container").val("");
		$("#txtSello_Container").val("");
		$("#txtPesoCarga_Container").val("");
		$("#lblEstadoContainer").text("Sin ingresar");	
		$("#txtFechaRetiro_Container").val("");
		$("#txtFechaPresentacion_Container").val("");
		
		$("#txtBooking_Container").val("");
		$("#txtOperacion_Container").val("");
		$("#txtMarca_Container").val("");
		$("#txtContenido_Container").val("");
		
		$("#txtTerminoStacking_Container").val("");
		$("#txtLugarDevolucion_Container").val("");
		$("#txtDiasLibres_Container").val("");
		$("#txtContactoEntrega_Container").val("");
		$("#txtTemperatura_Container").val("");
		$("#txtVentilacion_Container").val("");
		$("#txtOtros_Container").val("");
		
		$("#cboAgencia").val(0);
		$("#cboMedidasContenedor").val(0);
		$("#cboCondicionEspecial").val(0);
		$("#cboLugarDevolucion_Container").val(0);				
	}
		
	$("#divFormContainer").dialog({
		modal:true,
		title:"Container",
		width:"450",
		height:"400",
		buttons:{
			"Guardar":function(){
				if (guardaContainer()){
					
				}
			},
			"Cerrar":function(){
				$( this ).dialog( "close" );
			}
		}
	});
	showMessageAuxiliar("<b>Tip!</b><br/>Para editar una carga haga doble click sobre el registro");	
}


/*
 * Importa un archivo csv con informacion de carga libre o contenedores
 */
function importarCarga(tipo){
    _TIPOCARGA = tipo;
    $("#divImportarArchivo").dialog({
        modal:true,
        title:tipo==1?"Importar contenedores":"importar carga libre",
        width:"350",
        height:"200",
        buttons:{
            "Cerrar":function(){
                $( this ).dialog( "close" );
            }
        }
    });    
}

/*
 * Valida la extension del archivo
 */
function isImage(extension)
{
    switch(extension.toLowerCase()) 
    {
        case 'csv':
            return true;
        break;
        default:
            return false;
        break;
    }
}

function muestraAvanzadoContainer(){
	$("#tblAvanzadoContainer").fadeIn();
	$("#lnkOcultarAvanzado").fadeIn();
	$("#lnkMostrarAvanzado").fadeOut();
}

function obtieneUltimaCarga(codOrden){
	var salida;
	$.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/OrdenServicio/ultimoIdCarga-listar.php?codOrden="+codOrden,
        //dataType: "json",
        error: function (xhr, status, error) {
        	salida = 0;
        },
        success: function (data) {
        	salida = data;
        }
    });	
    return salida;
}

function ocultarAvanzadoContainer(){
	$("#tblAvanzadoContainer").fadeOut();
	$("#lnkOcultarAvanzado").fadeOut();
	$("#lnkMostrarAvanzado").fadeIn();	
}
