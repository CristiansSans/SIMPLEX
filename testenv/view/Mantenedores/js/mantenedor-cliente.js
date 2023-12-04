function cargaGrillaClientes() {
	var alto = $( document ).height() - 150;
	//CLIE_VRUT, CLIE_VNOMBRE, CLIE_VCONTACTOCOMERCIAL, CLIE_VDIRECCION, CLIE_VCOMUNA, CLIE_VGIRO, CLIE_VFONO, CLIE_NDIASLIBRES
	var lastsel2;
	jQuery("#tblClientes").jqGrid({
		url : '../../controller/mantenedores/listar-grilla_clientes.php',
		datatype : "json",
		colNames : ['Rut', 'Nombre','Razon social', 'Direccion', 'Contacto', 'Comuna', 'Giro', 'Telefono', 'Dias libres','Actividad'],
		colModel : [{
			name : 'CLIE_VRUT',
			index : 'CLIE_VRUT',
			editable : false,
			editoptions : {
				size : "20",
				maxlength : "10"
			},
			width : 150
		}, {
			name : 'CLIE_VNOMBRE',
			index : 'CLIE_VNOMBRE',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "100"
			},
			width : 200
		},{
			name : 'CLIE_VRAZONSOCIAL',
			index : 'CLIE_VRAZONSOCIAL',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "100"
			},
			width : 200,
			hidden: true
		},{
			name : 'CLIE_VDIRECCION',
			index : 'CLIE_VDIRECCION',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "250"
			},
			width : 300
		}, {
			name : 'CLIE_VCONTACTOLEGAL',
			index : 'CLIE_VCONTACTOLEGAL',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "200"
			},
			width : 200
		}, {
			name : 'CLIE_VCOMUNA',
			index : 'CLIE_VCOMUNA',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "45"
			},
			width : 200
		}, {
			name : 'CLIE_VGIRO',
			index : 'CLIE_VGIRO',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "100"
			},
			width : 200
		}, {
			name : 'CLIE_VFONO',
			index : 'CLIE_VFONO',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "100"
			},
			width : 200
		}, {
			name : 'CLIE_NDIASLIBRES',
			index : 'CLIE_NDIASLIBRES',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "5"
			},
			width : 100
		}, {
			name : 'CLIE_VACTIVIDAD',
			index : 'CLIE_VACTIVIDAD',
			editable : true,
			editoptions : {
				size : "20",
				maxlength : "100"
			},
			width : 200
		}],
		rowNum : 20,
		rowList : [20, 30, 40],
		pager : '#pagTblClientes',
		sortname : 'CLIE_VNOMBRE',
		viewrecords : true,
		sortorder : "ASC",
		editurl : "../../controller/mantenedores/editar-cliente2.php",
		caption : "Clientes",
		autowidth : true,
		height : alto,
		gridComplete: function(){
			 var rows= jQuery("#tblClientes").jqGrid('getRowData');	
			 for(var i=0;i<rows.length;i++){
			 	var row=rows[i];
			 	var rut = row['CLIE_VRUT'];
			 	var dv = obtenerDV(rut);			 	
			 	var nrut = rut + "-" + dv;
			 	
			 	jQuery("#tblClientes").jqGrid('setRowData',rut,{CLIE_VRUT:nrut});	
			 };
		},			
		ondblClickRow : function(rowid) {
			var codCliente = $('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VRUT');
			if (codCliente != "0") {
				$("#txtRut").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VRUT'));
				$("#txtNombre").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VNOMBRE'));
				$("#txtContactoLegal").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VCONTACTOLEGAL'));
				$("#txtDireccion").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VDIRECCION'));
				$("#txtCiudad").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VCOMUNA'));
				$("#txtComuna").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VCOMUNA'));
				$("#txtFono").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VFONO'));
				$("#txtGiro").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VGIRO'));
				$("#txtDiasLibres").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_NDIASLIBRES'));
				$("#txtRazonSocial").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VRAZONSOCIAL'));
				$("#txtActividad").val($('#tblClientes').jqGrid('getCell', rowid, 'CLIE_VACTIVIDAD'));
				
				muestraFichaCliente(codCliente);
				llenaGrillaTarifasCliente(codCliente);
			}
		},
	});

	jQuery("#tblClientes").jqGrid('navGrid', "#pagTblClientes", {
		edit : false,
		add : false,
		del : true
	});
	jQuery("#tblClientes").jqGrid('inlineNav', "#tblClientes");
	
	$('#tblClientes').setGridParam({
		url : '../../controller/mantenedores/listar-grilla_clientes.php'
	}).trigger("reloadGrid");	

}

function agregarNuevoCliente() {
	muestraFichaCliente(0);
}

function llenaGrillaTarifasCliente(rutCliente) {
    /*
    if (rutCliente==""){
       rutCliente = 0; 
    }else{
	   rutCliente = rutCliente.split('-')[0];
	}
	$.ajax({
		type : "POST",
		url : "../../controller/mantenedores/comboSubTipoServicios-listar.php",
		dataType : "json",
		success : function(result) {
			var lastsel2;
			var comboValuesTipoServicio = {
				value : "1:T.Exportacion;2:T.Importacion;3:T.Local;4:T.Nacional;5:Desconsolidacion;6:Almacenaje cont.;7:Recepcion y despacho cont"
			};
			var comboValuesSubTipoServicio = {
				value : "1:T.Importacion;2:T.Exportacion;3:T.Local"
			};
			var values = result.values;
			var comboValues2 = {
				value : result.values
			};

			jQuery("#tblTarifasServicios").jqGrid({
				url : '../../controller/mantenedores/grillaTarifasCliente-listar.php?CLIE_VRUT=' + rutCliente,
				datatype : "json",
				colNames : ['Codigo', 'Subtipo servicio', 'Monto'],
				colModel : [{
					name : 'TASI_NCORR',
					index : 'TASI_NCORR',
					editable : false,
					width : 50,
					hidden : true
				}, {
					name : 'STS_NCORR',
					index : 'STS_NCORR',
					editable : true,
					edittype : "select",
					editoptions : comboValues2,
					formatter:'select',
					editrules : {
						required: true,
					},						
					width :100
				}, {
					name : 'TASI_NMONTO',
					index : 'TASI_NMONTO',
					editable : true,					
					formatter:'currency',
					formatoptions: {prefix:'$', suffix:'', thousandsSeparator:'.', decimalPlaces:0},
					align : 'right',
					editrules: {
						number: true,
						maxValue: 9999999,
						minValue : 0,
						required: true
					},										
					width : 50
				}],
				rowNum : 20,
				rowList : [20, 30, 40],
				pager : '#pagtblTarifasServicios',
				sortname : 'TISE_VDESCRIPCION,STS_VNOMBRE,ORIGEN,DESTINO',
				caption	: 'Tarifas',
				//viewrecords : true,
				sortorder : "ASC",
				//multiselect: true,
				onSelectRow : function(id) {
					if (id && id !== lastsel2) {
						jQuery('#tblTarifasServicios').jqGrid('restoreRow', lastsel2);
						jQuery('#tblTarifasServicios').jqGrid('editRow', id, true);
						lastsel2 = id;
						//var cont = $('#tblTarifas').getCell(id, 'LUG_VSIGLA');
					}
				},
				loadComplete : function() {

				},
				editurl : '../../controller/mantenedores/editar-tarifacliente.php?CLIE_VRUT=' + rutCliente,
				autowidth : true,
				height : 200
			});

			jQuery("#tblTarifasServicios").jqGrid('navGrid', "#pagtblTarifasServicios", {
				edit : false,
				add : false,
				del : true
			});
			jQuery("#tblTarifasServicios").jqGrid('inlineNav', "#pagtblTarifasServicios");
			$('#tblTarifasServicios').setGridParam({
				url : '../../controller/mantenedores/grillaTarifasCliente-listar.php?CLIE_VRUT=' + rutCliente
			}).trigger("reloadGrid");
		}
	});
	*/
}

function muestraFichaCliente(codCliente) {
	if (codCliente==0){
		$("#txtRut").val("");
		$("#txtNombre").val("");		
		$("#txtContactoLegal").val("");
		$("#txtDireccion").val("");
		$("#txtCiudad").val("");
		$("#txtComuna").val("");
		$("#txtFono").val("");
		$("#txtGiro").val("");
		$("#txtRazonSocial").val("");
		$("#txtDiasLibres").val("");
		$("#txtActividad").val("");
		//llenaGrillaTarifasCliente(0);
	}
	$("#divFichaCliente").dialog({
		modal : true,
		width : "600px",
		height : 300,
		title : "Ficha de cliente",
		buttons : {
			"Guardar" : function() {
				if (validaAlmacenamiento()){
					/*if (codCliente==0){
						codCliente = $("#txtRut").val().split('-')[0];
					}*/
					codCliente = $("#txtRut").val().split('-')[0];
					var params;
					params = "oper=edit&txtRut="+ codCliente;
					params += "&txtNombre="+ $("#txtNombre").val();
					params += "&txtContactoLegal="+ $("#txtContactoLegal").val();
					params += "&txtDireccion="+ $("#txtDireccion").val();
					params += "&txtCiudad="+ $("#txtCiudad").val();
					params += "&txtComuna="+ $("#txtComuna").val();
					params += "&txtFono="+ $("#txtFono").val();
					params += "&txtGiro="+ $("#txtGiro").val();
					params += "&txtDiasLibres="+ $("#txtDiasLibres").val();
					params += "&txtRazonSocial="+ $("#txtRazonSocial").val();
					params += "&txtActividad="+ $("#txtActividad").val();
					
					$.ajax({
						type : "POST",
						url : "../../controller/mantenedores/editar-cliente.php?"+ params,
						dataType : "json",
						//data: objJson,
						success : function(result) {
							cargaGrillaClientes();	
						}
					});
	
					$(this).dialog("close");					
				}
			},
			"Cerrar" : function() {
				$(this).dialog("close");
			}
		}
	});
}

function validaAlmacenamiento(){
	if (validaRutObjeto($("#txtRut"))){
		if ($("#txtNombre").val()==""){
			alert("Debe ingresar el nombre");
		}else{
			if ($("#txtContactoLegal").val()==""){
				alert("Debe ingresar el contacto legal");
			}else{
				if($("#txtDireccion").val()==""){
					alert("Debe ingresar la ciudad");
				}else{
					if($("#txtComuna").val()==""){
						alert("Debe ingresar la comuna");
					}
					else{
						if($("#txtGiro").val()==""){
							alert("Debe ingresar el giro");
						}else{
							if($("#txtFono").val()==""){
								alert("Debe ingresar el fono del cliente");
							}else{
								if ($("#txtDiasLibres").val()==""){
									alert("Debe ingresar los días libres");
								}else{
									return true;	
								}							
							}						
						}						
					}
				}
			}
		}
	}
	return false;
}