function cargaGrillaClientes() {

}

function cargaGrillaClientes() {

}

function exportExcel($id) {
    var keys = [], ii = 0, rows = "";
    var ids = $id.getDataIDs();
    // Get All IDs
    var row = $id.getRowData(ids[0]);
    // Get First row to get the labels
    for (var k in row) {
        keys[ii++] = k;
        // capture col names
        rows = rows + k + "\t";
        // output each Column as tab delimited
    }
    rows = rows + "\n";
    // Output header with end of line
    for ( i = 0; i < ids.length; i++) {
        row = $id.getRowData(ids[i]);
        // get each row
        for ( j = 0; j < keys.length; j++)
            rows = rows + row[keys[j]] + "\t";
        // output each Row as tab delimited
        rows = rows + "\n";
        // output each row with end of line
    }
    rows = rows + "\n";
    // end of line at the end
    var form = "<form name='csvexportform' action='" + php_path + "csvexport.php' method='post'>";
    form = form + "<input type='hidden' name='csvBuffer' value='" + rows + "'>";
    form = form + "</form><script>document.csvexportform.submit();</sc" + "ript>";
    OpenWindow = window.open('', '');
    OpenWindow.document.write(form);
    OpenWindow.document.close();
}

function cargarGrillaLugares() {
    console.log("Desarrollo 2");
    var lastsel2;

    $.ajax({
        type : "POST",
        url : "../../controller/mantenedores/comboLugares-listar.php",
        dataType : "json",
        success : function(result) {
            var comboValues2 = {
                value : result.values
            };
            var comboValues = {
                value : "1:Puerto;2:Deposito;3:Deposito puerto;4:Cliente;5:Ciudad"
            };
            jQuery("#tblLugares").jqGrid({
                url : '../../controller/mantenedores/listar-grilla_lugares.php',
                datatype : "json",
                colNames : ['Codigo', 'Sigla(*)', 'Nombre(*)', 'Direccion', 'Ciudad(*)', 'Lugar padre', 'Tipo(*)', 'Retiro', 'Carguio', 'Destino'],
                colModel : [{
                    name : 'LUG_NCORR',
                    index : 'LUG_NCORR',
                    editable : false,
                    width : 80
                }, {
                    name : 'LUG_VSIGLA',
                    index : 'LUG_VSIGLA',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "5"
                    },
                    width : 80
                }, {
                    name : 'LUG_VNOMBRE',
                    index : 'LUG_VNOMBRE',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "200"
                    },
                    editrules : {
                        required : true,
                    },
                    width : 300
                }, {
                    name : 'LUG_VDIRECCION',
                    index : 'LUG_VDIRECCION',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "300"
                    },
                    width : 300
                }, {
                    name : 'LUG_VCIUDAD',
                    index : 'LUG_VCIUDAD',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "45"
                    },
                    editrules : {
                        required : true,
                    },
                    width : 300
                }, {
                    name : 'LUG_NCORR_PADRE',
                    index : 'LUG_NCORR_PADRE',
                    editable : true,
                    width : 150,
                    edittype : "select",
                    editoptions : comboValues2,
                    formatter : 'select'
                }, {
                    name : 'LUG_NCATEGORIA',
                    index : 'LUG_NCATEGORIA',
                    editable : true,
                    edittype : "select",
                    editoptions : comboValues,
                    swidth : 200,
                    formatter : 'select',
                    editrules : {
                        required : true,
                    }
                }, {
                    name : 'LUG_NRETIRO',
                    index : 'LUG_NRETIRO',
                    editable : true,
                    edittype : 'checkbox',
                    formatter : 'checkbox',
                    editoptions : {
                        value : "1:0"
                    },
                    width : 80,
                    align : "center"
                }, {
                    name : 'LUG_NCARGUIO',
                    index : 'LUG_NCARGUIO',
                    editable : true,
                    edittype : 'checkbox',
                    formatter : 'checkbox',
                    editoptions : {
                        value : "1:0"
                    },
                    width : 80,
                    align : "center"
                }, {
                    name : 'LUG_NDESTINO',
                    index : 'LUG_NDESTINO',
                    //align: center,
                    editable : true,
                    edittype : 'checkbox',
                    formatter : 'checkbox',
                    editoptions : {
                        value : "1:0"
                    },
                    width : 80,
                    align : "center"
                }],
                rowNum : 20,
                rowList : [20, 30, 40],
                pager : '#pagTblLugares',
                sortname : 'LUG_VNOMBRE',
                viewrecords : true,
                sortorder : "ASC",
                editurl : "../../controller/mantenedores/editar-lugar.php",
                onSelectRow : function(id) {
                    if (id && id !== lastsel2) {
                        jQuery('#tblLugares').jqGrid('restoreRow', lastsel2);
                        jQuery('#tblLugares').jqGrid('editRow', id, true);
                        lastsel2 = id;
                        var cont = $('#tblLugares').getCell(id, 'LUG_VSIGLA');
                    }
                },

                caption : "Lugares",
                autowidth : true,
                height : 400
            });

            $('#tblLugares').setGridParam({
                url : '../../controller/mantenedores/listar-grilla_lugares.php'
            }).trigger("reloadGrid");

            jQuery("#tblLugares").jqGrid('navGrid', "#pagTblLugares", {
                edit    : false,
                add     : false,
                del     : true,
                search  : false
            });

            jQuery("#tblLugares").jqGrid('inlineNav', "#pagTblLugares");

        }
    });
}

function cargarGrillaLugares2() {
    console.log("Prueba");
    var lastsel2;

    $.ajax({
        type : "POST",
        url : "../../controller/mantenedores/comboLugares-listar.php",
        dataType : "json",
        //data: objJson,
        success : function(result) {
            var comboValues2 = {
                value : result.values
            };
            var comboValues = {
                value : "1:Puerto;2:Deposito;3:Deposito puerto;4:Cliente;5:Ciudad"
            };
            jQuery("#tblLugares").jqGrid({
                url : '../../controller/mantenedores/listar-grilla_lugares.php',
                datatype : "json",
                colNames : ['Codigo', 'Sigla(*)', 'Nombre(*)', 'Direccion', 'Ciudad(*)', 'Lugar padre', 'Tipo(*)', 'Retiro', 'Carguio', 'Destino'],
                colModel : [{
                    name : 'LUG_NCORR',
                    index : 'LUG_NCORR',
                    editable : false,
                    width : 80
                }, {
                    name : 'LUG_VSIGLA',
                    index : 'LUG_VSIGLA',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "5"
                    },
                    width : 80
                }, {
                    name : 'LUG_VNOMBRE',
                    index : 'LUG_VNOMBRE',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "200"
                    },
                    editrules : {
                        required : true,
                    },
                    width : 300
                }, {
                    name : 'LUG_VDIRECCION',
                    index : 'LUG_VDIRECCION',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "300"
                    },
                    width : 300
                }, {
                    name : 'LUG_VCIUDAD',
                    index : 'LUG_VCIUDAD',
                    editable : true,
                    editoptions : {
                        size : "20",
                        maxlength : "45"
                    },
                    editrules : {
                        required : true,
                    },
                    width : 300
                }, {
                    name : 'LUG_NCORR_PADRE',
                    index : 'LUG_NCORR_PADRE',
                    editable : true,
                    width : 150,
                    edittype : "select",
                    editoptions : comboValues2,
                    formatter : 'select'
                }, {
                    name : 'LUG_NCATEGORIA',
                    index : 'LUG_NCATEGORIA',
                    editable : true,
                    edittype : "select",
                    editoptions : comboValues,
                    swidth : 200,
                    formatter : 'select',
                    editrules : {
                        required : true,
                    }
                }, {
                    name : 'LUG_NRETIRO',
                    index : 'LUG_NRETIRO',
                    editable : true,
                    edittype : 'checkbox',
                    formatter : 'checkbox',
                    editoptions : {
                        value : "1:0"
                    },
                    width : 80,
                    align : "center"
                }, {
                    name : 'LUG_NCARGUIO',
                    index : 'LUG_NCARGUIO',
                    editable : true,
                    edittype : 'checkbox',
                    formatter : 'checkbox',
                    editoptions : {
                        value : "1:0"
                    },
                    width : 80,
                    align : "center"
                }, {
                    name : 'LUG_NDESTINO',
                    index : 'LUG_NDESTINO',
                    //align: center,
                    editable : true,
                    edittype : 'checkbox',
                    formatter : 'checkbox',
                    editoptions : {
                        value : "1:0"
                    },
                    width : 80,
                    align : "center"
                }],
                rowNum : 20,
                rowList : [20, 30, 40],
                pager : '#pagTblLugares',
                sortname : 'LUG_VNOMBRE',
                viewrecords : true,
                sortorder : "ASC",
                editurl : "../../controller/mantenedores/editar-lugar.php",
                onSelectRow : function(id) {
                    if (id && id !== lastsel2) {
                        jQuery('#tblLugares').jqGrid('restoreRow', lastsel2);
                        jQuery('#tblLugares').jqGrid('editRow', id, true);
                        lastsel2 = id;
                        var cont = $('#tblLugares').getCell(id, 'LUG_VSIGLA');
                    }
                },

                caption : "Lugares",
                autowidth : true,
                height : 400
            });
        }
    });

    /*
     jQuery("#tblLugares").jqGrid('navGrid', "#pagTblLugares", {
     edit : false,
     add : true,
     del : true,
     excel : true
     }).navButtonAdd('#pager', {
     caption : "Export to Excel",
     buttonicon : "ui-icon-save",
     onClickButton : function() {
     exportExcel("#tblLugares");
     },
     position : "last"
     });
     */

    $('#tblLugares').setGridParam({
        url : '../../controller/mantenedores/listar-grilla_lugares.php'
    }).trigger("reloadGrid");

    jQuery("#tblLugares").jqGrid('navGrid', "#pagTblLugares", {
        edit : true,
        add : true,
        del : true
    });

    jQuery("#tblLugares").jqGrid('inlineNav', "#pagTblLugares");

    /*
     $("#btnBorrar").click(function() {
     var gr = jQuery("#tblLugares").jqGrid('getGridParam', 'selrow');
     if (gr != null)
     jQuery("#tblLugares").jqGrid('delGridRow', gr, {
     reloadAfterSubmit : false
     });
     else
     alert("Debe seleccionar el registro a eliminar");
     });
     */
}

/*
 function gridcsvexport(id) {
 $('#'+id).jqGrid('navButtonAdd','#pagTblLugares',{
 caption:'',
 title:'export',
 buttonicon:'ui-icon-newwin',
 position:'last',
 onClickButton:function (){
 exportExcel($(this));
 }
 });
 }*/

function comboTipoLugarCargar(codTipo) {

}

function comboCategoriaCargar(cod) {

}

function comboLugarCargar(cod) {

}

function muestraFichaLigar(codLugar) {
    $("#divFichaLugar").dialog({
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