/*
 * Atributos
 */
var comboValues2;
var comboTramos;

/*
 * Carga las grillas de la pantalla
 */
function cargarGrillas(){
	cargaGrillaServicios();
}

/*
 * Carga grilla de servicios
 */
function cargaGrillaServicios(){
	var lastsel2;
	var rutCliente 		= $("#cboCliente").val();
	var	codtipoServicio	= $("#cboTipoServicio").val();

	jQuery("#tblServicios").jqGrid({
		url : '../../controller/mantenedores/grillaServicios-listar.php?rutCliente='+rutCliente+'&codtipoServicio='+codtipoServicio,
		datatype : "json",
		height:200,
		colNames : ['Codigo','Servicio','Tipo','Origen','Destino','Rut','Monto'],
		colModel : [{
			name : 'sts_ncorr',
			index : 'sts_ncorr',
			editable : false,
			width : 50,
			hidden : true
		}, {
			name : 'sts_vnombre',
			index : 'sts_vnombre',
			editable : true,					
			width : 200,
			hidden : false,
			editrules: {
				maxlength : "50",
				required: true
			}			
		}, {
			name : 'tise_ncorr',
			index : 'tise_ncorr',
			editable : true,					
			width : 50,
			hidden : true
		}, {
			name : 'lug_ncorr_origen',
			index : 'lug_ncorr_origen',
			editable : true,					
			width : 150,
			hidden : false,
			edittype: "select",
			editoptions: comboValues2,
			formatter:'select'					
		}, {
			name : 'lug_ncorr_destino',
			index : 'lug_ncorr_destino',
			editable : true,					
			width : 150,
			hidden : false,
			edittype: "select",
			editoptions: comboValues2,
			formatter:'select'
		}, {
			name : 'clie_vrut',
			index : 'clie_vrut',
			editable : true,					
			width : 50,
			hidden : true
		}, {
			name : 'sts_nmonto',
			index : 'sts_nmonto',
			editable : true,					
			width : 100,
			hidden : false,
			formatter:'currency',
			formatoptions: {prefix:'$', suffix:'', thousandsSeparator:'.', decimalPlaces:0},
			editrules: {
				number: true,
				maxValue: 9999999,
				required: true
			}			
		}],
		rowNum : 10,
		rowList:[10,20],
		pager: '#pagTblServicios',
		sortname : 'sts_ncorr',
		viewrecords : true,
		sortorder : "ASC",
		multiselect:false,
		pgtext: "Pag. {0}/{1}",
		//subgrid : true,
		editurl : "../../controller/mantenedores/editar-servicio.php?rutCliente=" + rutCliente + "&codtipoServicio=" + codtipoServicio,
		caption : "Servicios",
		autowidth : true,			
        ondblClickRow: function (rowid) {
        },
        afterInsertRow : function(ids){
        	cargaGrillaTramos(0);
        },
		onSelectRow : function(id) {
			if (id && id !== lastsel2) {
				var cont = $('#tblServicios').getCell(id, 'sts_ncorr');
				cargaGrillaTramos(cont);        	
				
				
				jQuery('#tblServicios').jqGrid('restoreRow', lastsel2);
				jQuery('#tblServicios').jqGrid('editRow', id, true);
				lastsel2 = id;

			}
		}						
        		        				
	});
	$('#tblServicios').setGridParam({url: '../../controller/mantenedores/grillaServicios-listar.php?rutCliente='+rutCliente+'&codtipoServicio='+codtipoServicio}).trigger("reloadGrid");
	jQuery("#tblServicios").jqGrid('navGrid',"#pagTblServicios",{edit:false,add:false,del:true}); 
	jQuery("#tblServicios").jqGrid('inlineNav',"#pagTblServicios");
}

/*
 * Carga la grilla de tramos asociados al servicio
 */
function cargaGrillaTramos(codServicio){
	var lastsel2;

	jQuery("#tblTramosServicio").jqGrid({		
		url : '../../controller/mantenedores/grillaTramosServicios-listar.php?codServicio='+codServicio,
		datatype : "json",
		height:200,
		colNames : ['tss_ncorr','Tramo','Nombre'],
		colModel : [{
			name : 'tss_ncorr',
			index : 'tss_ncorr',
			editable : false,
			width : 50,
			hidden : true
		}, {
			name : 'tra_ncorr',
			index : 'tra_ncorr',
			editable : true,					
			width : 200,
			hidden : false,
			edittype: "select",
			editoptions: comboTramos,
			formatter:'select'	
		}, {
			name : 'nombre',
			index : 'nombre',
			editable : true,					
			width : 50,
			hidden : true
		}],
		rowNum : 50,
		rowList: [],
		pgbuttons: false, 
		pgtext: null,
		//rowList:[10,20],
		pager: '#pagTblTramosServicio',
		sortname : 'nombre',
		viewrecords : true,
		sortorder : "ASC",
		multiselect:false,
		//subgrid : true,
		editurl : '../../controller/mantenedores/TramoServicio-ingresar.php?codServicio='+codServicio,
		caption : "Tramos del servicio",
		autowidth : true,			
        ondblClickRow: function (rowid) {
        },
		onSelectRow : function(id) {
			/*
			if (id && id !== lastsel2) {
				var cont = $('#tblServicios').getCell(id, 'sts_ncorr');
				cargaGrillaTramos(cont);        	
				
				
				jQuery('#tblServicios').jqGrid('restoreRow', lastsel2);
				jQuery('#tblServicios').jqGrid('editRow', id, true);
				lastsel2 = id;

			}
			*/
		}						
        		        				
	});

	$('#tblTramosServicio').setGridParam({
		url : '../../controller/mantenedores/grillaTramosServicios-listar.php?codServicio='+codServicio,
		editurl : '../../controller/mantenedores/TramoServicio-ingresar.php?codServicio='+codServicio
	}).trigger("reloadGrid");
	jQuery("#tblTramosServicio").jqGrid('navGrid',"#pagTblTramosServicio",{edit:false,add:false,del:true}); 
	jQuery("#tblTramosServicio").jqGrid('inlineNav',"#pagTblTramosServicio");
}

/*
 * Carga combo de tipos de servicios
 */
function cargaTiposServicio(){
	var codTipoNegocio = $("#cboTipoNegocio").val();
	cargaCambo(19,codTipoNegocio,"#cboTipoServicio",0);
}

/*
 * Llena los combos al inicio de la pantalla
 */
function llenaCombos(){
	cargaCambo(1,"","#cboCliente",0);
	cargaCambo(18,"","#cboTipoNegocio",0);
	
    $.ajax({
        type: "POST",
        url: "../../controller/mantenedores/comboLugares-listar.php",
        dataType: "json",
        //data: objJson,
        success: function (result) {
        	//var values = result.values;
        	comboValues2 = {value:result.values};

		    $.ajax({
		        type: "POST",
		        url: "../../controller/mantenedores/comboTramos-listar.php",
		        dataType: "json",
		        //data: objJson,
		        success: function (result2) {
		        	comboTramos = {value:result2.values};
		       },		       
		    });	        	
       },		       
    });	
			
}