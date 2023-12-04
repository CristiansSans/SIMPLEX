function inicializar(){
	$("input, a.button, button, textarea").uniform();
	formateaFecha("#txtFecha");	
	cargaCambo(1,"","#cboCliente",0);
	cargaCambo(14,"","#cboEmpresa",0);	
	$("#txtFecha").val(getFecha());
	cargaGrillaSeguimiento();	
}

function muestraSeguimiento(){
	var alto 		= $( document ).height();
	var ancho 		= $( document ).width();	
	var opciones="toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=yes, width="+ (ancho - 100) +", height=" + (alto - 100) + ", top=50, left=50";
	window.open("VerSeguimiento.htm","",opciones);	
}

function cargaGrillaSeguimiento(){
	var alto 		= $( document ).height() - 150;
	var ancho 		= $( document ).width() - 330;
	
	cargaGrillaSeguimiento1("#tblSeguimiento", '#pagSeguimiento', alto, ancho);
}

function cargaGrillaSeguimiento2(){
	var alto 		= $( document ).height() - 10;
	var ancho 		= $( document ).width() - 10;
	
	cargaGrillaSeguimiento1("#tblSeguimiento", '#pagSeguimiento', alto, ancho);
}

function cargaGrillaSeguimiento1(tabla, paginador, alto, ancho) {
	var urlGrilla	= '../../controller/SeguimientoTransporte/seguimiento_listar.php';	
	jQuery(tabla).jqGrid({
		datatype 	: "json",
		url 		: urlGrilla,
		height 		: alto,
		width 		: ancho,
		shrinkToFit	: false,
		pager		: paginador,
		viewrecords : true,
		sortorder 	: "desc",
		sortname 	: "uavance",
		colNames : ['id', 'Ult.Avance','Estado','Empresa','Tipo servicio','Camion','Chofer','Tipo carga','Contenedor','Fono','Origen','Destino','Plan','Real','Plan','Real','Total','-','-','-','-'],
		colModel : [{
			name 	: 'serv_ncorr',
			index 	: 'serv_ncorr',
			width 	: 50,
			sortable: false,
			frozen	: true
		},{
			name 	: 'uavance',
			index 	: 'uavance',
			width 	: 100,
			frozen	: true,
			align	: 'center'//,
			//sorttype : 'date'
		},{
			name	:'act',
			index	:'act', 
			width	:180,
			sortable:false,
			frozen	: true
		},{
			name 	: 'nombreempresa',
			index 	: 'nombreempresa',
			width 	: 180
		},{
			name 	: 'tiposervicio',
			index 	: 'tiposervicio',
			width 	: 100	
		},{
			name 	: 'camion',
			index 	: 'camion',
			width 	: 80	
		},{
			name 	: 'chofer',
			index 	: 'chofer',
			width 	: 120	
		},{
			name	: 'tica_vdescripcion',
			index	: 'tica_vdescripcion',
			width	: 120
		},{
			name 	: 'numcontenedor',
			index	: 'numcontenedor',
			width	: 120			
		},{
			name 	: 'fono',
			index	: 'fono',
			width	: 80			
		},{
			name 	: 'origen',
			index 	: 'origen',
			width 	: 120			
		},{
			name 	: 'destino',
			index 	: 'destino',
			width 	: 120			
		},{
			name 	: 'inicioplan',
			index 	: 'inicioplan',
			width 	: 130,	
			align 	: 'center'		
		},{
			name 	: 'inicioreal',
			index 	: 'inicioreal',
			width 	: 130,
			align 	: 'center'			
		},{
			name 	: 'finplan',
			index 	: 'finplan',
			width 	: 130,
			align 	: 'center'			
		},{
			name 	: 'finreal',
			index 	: 'finreal',
			width 	: 130,
			align 	: 'center'			
		},{
			name 	: 'total',
			index 	: 'total',
			width 	: 70,
			align 	: 'center',
			hidden  : true			
		},{
		    name    : 'atrasoinicio',
		    index   : 'atrasoinicio',
		    hidden  : true
		},{
		    name    : 'atrasoavance',
		    index   : 'atrasoavance',
		    hidden  : true
		},{
		    name    : 'avance',
		    index   : 'avance',
		    hidden  : true
		},{
		    name    : 'totaltiempo',
		    index   : 'totaltiempo',
		    hidden  : true
		}],
		caption 	: "Seguimiento de transporte",
		sortname	: 'uavance',
		sortorder	: 'asc',
	   	viewrecords	: false,
	   	ondblClickRow : function(rowid){
	   		editarSeguimiento(rowid);	
	   	},
	   	gridComplete : function(){
	   	    var rows= jQuery("#tblSeguimiento").jqGrid('getRowData');
	   	    for(var i=0;i<rows.length;i++){
	   	        var row = rows[i];
	   	        var idServicio = row['serv_ncorr'];
	   	        var atrasoInicio = row['atrasoinicio'];
	   	        var atrasoAvance = row['atrasoavance'];
	   	        var avance       = row['avance'];
	   	        var totalTiempo  = row['totaltiempo'];
	   	        
	   	    };
	   	}	   		   	
	});
			
	jQuery(tabla).jqGrid('navGrid',paginador,{add:false,edit:false,del:false,search:false,refresh:true});
	jQuery(tabla).jqGrid('sortableRows');
	
	jQuery(tabla).jqGrid('navButtonAdd',paginador,{
	    caption: "Columnas",
	    title: "Seleccionar columnas",
	    onClickButton : function (){
	        jQuery("#tblSeguimiento").jqGrid('columnChooser');
	    }
	});

	jQuery(tabla).jqGrid('setGroupHeaders', {
	  useColSpanStyle: false, 
	  groupHeaders:[
	  	{startColumnName: 'serv_ncorr'	, numberOfColumns: 3, titleText:'Servicio'},
		{startColumnName: 'origen'		, numberOfColumns: 2, titleText: 'Tramo'},
		{startColumnName: 'inicioplan'	, numberOfColumns: 2, titleText: 'Inicio'},
		{startColumnName: 'finplan'		, numberOfColumns: 2, titleText: 'Termino'}		
	  ]	
	});	
	jQuery(tabla).jqGrid('setFrozenColumns');
}

function editarSeguimiento(rowid){
	var tramo;
	var codServicio = $('#tblSeguimiento').jqGrid('getCell', rowid, 'serv_ncorr'); 
	
	$("#lblServicio").text($('#tblSeguimiento').jqGrid('getCell', rowid, 'tiposervicio'));
	$("#lblPatente").text($('#tblSeguimiento').jqGrid('getCell', rowid, 'camion'));
	$("#lblChofer").text($('#tblSeguimiento').jqGrid('getCell', rowid, 'chofer'));
	
	tramo = $('#tblSeguimiento').jqGrid('getCell', rowid, 'origen');
	tramo += " -> ";
	tramo += $('#tblSeguimiento').jqGrid('getCell', rowid, 'destino');
	
	$("#lblTramo").text(tramo);
	
	cargaHitosSeguimiento(codServicio);
	$("#divSeguimiento").dialog({
		modal:true,
		title:"Seguimiento de transporte",
		width:"600",
		height:"300",
		buttons:{
			"Cerrar":function(){			    
				$( this ).dialog( "close" );	
			}
		}
	});		
}

function validHourEntry(value, colname) {
	//!value .match(/^\d+:\d{2}:\d{2}$/
	if(!value .match(/^\d+:\d{2}$/)){
		return [false, "Error de formato de fecha<br/>Por favor ingresar con formato <b>hh:mm</b>"];
	}
	else{
		return [true, ""];
	}	
}

function cargaHitosSeguimiento(codServicio){	

	var urlGrilla	= '../../controller/SeguimientoTransporte/hitoServicio_listar.php?codServicio='+ codServicio;
	var lastsel2;	
	jQuery("#tblTramosSeguimiento").jqGrid({
		datatype: "json",
		url		: urlGrilla,
		height	: 100,
		autowidth : true,
	   	colNames:['Id','Num','Hito', 'Km', 'Hr Prog','Hr real'],
	   	colModel:[
	   		{name:'numhito',index:'numhito', width:40, sorttype:"int", align:"center", hidden:true},
	   		{name:'num',index:'num', width:40, sorttype:"int", align:"center", hidden:false},
	   		{name:'nombrehito',index:'nombrehito', width:200, sorttype:"int", align:"left"},
	   		{name:'km',index:'km', width:50, align:"right"},
	   		{name:'horaprogramada',index:'horaprogramada', width:120, align:"right"},
	   		{
	   			name			:'horareal',
	   			index			:'horareal', 
	   			width			:120, 
	   			align			:"right",
	   			sorttype		:"date",
				editable 		: true,
				//formatter		: "date",
				editoptions : {
					size : "20",
					maxlength : "16"
				}//,
				//editrules: { custom: true, custom_func: validHourEntry } 			
	   		}
	   	],
	   	multiselect: false,
	   	caption: "Hitos de seguimiento",
	   	editurl : "../../controller/SeguimientoTransporte/hitoServicio_ingresar.php?codservicio=" + codServicio,
		onSelectRow : function(id) {
			if (id && id !== lastsel2) {
				jQuery('#tblTramosSeguimiento').jqGrid('restoreRow', lastsel2);
				jQuery('#tblTramosSeguimiento').jqGrid('editRow', id, true);
				lastsel2 = id;
			}
		}	   	
	});
	
    $('#tblTramosSeguimiento').setGridParam({ 
    	url		: urlGrilla,
    	editurl	: "../../controller/SeguimientoTransporte/hitoServicio_ingresar.php?codservicio=" + codServicio
    }).trigger("reloadGrid");	
}
