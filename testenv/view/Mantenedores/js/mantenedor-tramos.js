/**
 * @author haichele
 */

		function agregarHitoTramo(){
			
		}

		function agregarNuevoTramo(){
			$("#divTramo").dialog({
				modal : true,
				width : "700px",
				height : 250,
				title : "Ficha de lugar",
				buttons : {
					"Guardar" : function() {
						$(this).dialog("close");
					},
					"Cerrar" : function() {
						$(this).dialog("close");
					}
				}
			});				
		}

		function cargaGrillaTramos(){
		    $.ajax({
		        type: "POST",
		        url: "../../controller/mantenedores/comboLugares-listar.php",
		        dataType: "json",
		        //data: objJson,
		        success: function (result) {
		        	var lastsel2;
		        	var values = result.values;
		        	var comboValues2 = {value:result.values};
					var comboValues = {value:"2:STI;15:LO HERRERA;26:Pirque - Concha y ToroTNT;27:Lo Espejo - San Pedro"};
					var lastsel2;
					//`TRA_NCORR`, `VIA_NCORR`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `TRA_KMS`, `TRA_TIEMPO`
					jQuery("#tblTramo").jqGrid({
						url : '../../controller/mantenedores/listar-grilla_tramos.php',
						datatype : "json",
						colNames : ['Codigo','Origen(*)','Origen', 'Destino(*)','Destino','Kms(*)','Minutos(*)'],
						colModel : [{
							name : 'TRA_NCORR',
							index : 'TRA_NCORR',
							editable : false,
							width : 100,
							hidden : true
						}, {
							name : 'LUG_NCORR_ORIGEN',
							index : 'LUG_NCORR_ORIGEN',
							editable : true,					
							width : 100,
							hidden : false,
							edittype: "select",
							editoptions: comboValues2,
							formatter:'select'
						}, {
							name : 'ORIGEN',
							index : 'ORIGEN',
							editable : false,
							width : 200,
							hidden : true
						}, {
							name : 'LUG_NCORR_DESTINO',
							index : 'LUG_NCORR_DESTINO',
							editable : true,
							width : 100,
							hidden: false,
							edittype: "select",
							editoptions: comboValues2,
							formatter:'select'							
						}, {
							name : 'DESTINO',
							index : 'DESTINO',
							editable : false,
							editoptions : {
								size : "20",
								maxlength : "20"
							},
							width : 200,
							hidden: true
						}, {
							name : 'TRA_KMS',
							index : 'TRA_KMS',
							editable : true,
							editoptions : {
								size : "20",
								maxlength : "5"
							},
							editrules: {
								number: true,
								maxValue: 9999,
								required: true
							},
							width : 100
						}, {
							name : 'TRA_TIEMPO',
							index : 'TRA_TIEMPO',
							editable : true,
							editoptions : {
								size : "20",
								maxlength : "4"
							},
							editrules: {
								number: true,
								maxValue: 1000,
								required: true
							},							
							width : 100
						}],
						rowNum : 20,
						rowList:[20,30,40],
						pager: '#pagTblTramo',
						sortname : 'ORIGEN,DESTINO',
						viewrecords : true,
						sortorder : "ASC",
						editurl : "../../controller/mantenedores/editar-tramo.php",
						caption : "Tramos",
						autowidth : true,
						height:400,
						onSelectRow : function(id) {
							if (id && id !== lastsel2) {
								jQuery('#tblTramo').jqGrid('restoreRow', lastsel2);
								jQuery('#tblTramo').jqGrid('editRow', id, true);
								lastsel2 = id;
		      					var cont = $('#tblTramo').getCell(id, 'TRA_NCORR');
							}
						},						
				        ondblClickRow: function (rowid) {
				        	alert(rowid);
				            var tnCodTramo = $('#tblTramo').jqGrid('getCell', rowid, 'TRA_NCORR');
				            var lsNombreOrigen = $('#tblTramo').jqGrid('getCell', rowid, 'ORIGEN');
				            var lsNombreDestino = $('#tblTramo').jqGrid('getCell', rowid, 'DESTINO');
				            MuestraFichaTramo(tnCodTramo);
				            $("#lblOrigenTramo").text(lsNombreOrigen);
				            $("#lblDestinoTramo").text(lsNombreDestino);
				        },					
					});
					
					jQuery("#tblTramo").jqGrid('navGrid',"#pagTblTramo",{edit:false,add:false,del:true}); 
					jQuery("#tblTramo").jqGrid('inlineNav',"#pagTblTramo");
					//jQuery("#tblTramo").jqGrid('filterToolbar',{stringResult: true,searchOnEnter : true});			        	
		       },		       
		    });			

		}

		function cargaGrillaHitos(codTramo){	
			var lastsel3;		  
			jQuery("#tblHitosTramo").jqGrid({
				url : '../../controller/mantenedores/grillaHitos-listar.php?codTramo='+codTramo,
				datatype : "json",
				colNames : ['Codigo','Nombre','Kms','Tiempo viaje', 'Inicial','Final'],
				colModel : [{
					name : 'HITO_NCORR',
					index : 'HITO_NCORR',
					editable : false,
					width : 100,
					hidden : true,
					editoptions:{size:"20",maxlength:"30"}
				}, {
					name : 'HITO_VNOMBRE',
					index : 'HITO_VNOMBRE',
					editable : true,					
					width : 350,
					hidden : false,
					editoptions:{size:"20",maxlength:"300"},
					editrules : {
						required: true,
					},			
				}, {
					name : 'HITO_KM',
					index : 'HITO_KM',
					editable : true,					
					width : 100,
					hidden : false,
					editrules : {
						required: true,
					},					
				}, {
					name : 'HITO_TIEMPOVIAJE',
					index : 'HITO_TIEMPOVIAJE',
					editable : true,
					width : 100,
					editoptions:{size:"20",maxlength:"4"},
					editrules : {
						required: true,
					},					
				}, {
					name : 'HITO_INICIAL',
					index : 'HITO_INICIAL',
					editable : true,
					edittype : "checkbox",
					editoptions : {value:"1:0"},
					formatter: 'checkbox',
					width : 50					
				}, {
					name : 'HITO_FINAL',
					index : 'HITO_FINAL',
					editable : true,
					edittype : "checkbox",
					formatter: 'checkbox',
					editoptions: {value:"1:0"},						
					width : 50
				}],
				onSelectRow : function(id) {
					if (id && id !== lastsel3) {
						jQuery('#tblHitosTramo').jqGrid('restoreRow', lastsel3);
						jQuery('#tblHitosTramo').jqGrid('editRow', id, true);
						lastsel3 = id;
      					var cont = $('#tblHitosTramo').getCell(id, 'HITO_NCORR');
					}
				},				
				rowNum : 20,
				rowList:[20,30,40],
				pager: '#pagtblHitosTramo',
				sortname : 'HITO_NCORR',
				viewrecords : true,
				sortorder : "ASC",
				editurl : "../../controller/mantenedores/editar-hito.php?TRA_NCORR="+codTramo,
				caption : "Hitos del tramo",
				autowidth : true,
				height:180
			});
									
			jQuery("#tblHitosTramo").jqGrid('navGrid',"#pagtblHitosTramo",{edit:false,add:false,del:true}); 
			jQuery("#tblHitosTramo").jqGrid('inlineNav',"#pagtblHitosTramo");		
  	        $('#tblHitosTramo').setGridParam({ 
  	        	url: '../../controller/mantenedores/grillaHitos-listar.php?codTramo='+codTramo 
  	        }).trigger("reloadGrid");		
		}

		function MuestraFichaTramo(codTramo){
			cargaGrillaHitos(codTramo);
			$("#divHitos").dialog({
				modal : true,
				width : "700px",
				height : 500,
				title : "Hitos del tramo",
				buttons : {
					"Guardar" : function() {
						$(this).dialog("close");
					},
					"Cerrar" : function() {
						$(this).dialog("close");
					}
				}
			});		
		}
