/*
 * Edita una guia asociada a un servicio
 */
function agregarGuia(codServicio) {
    cargaCambo(25, "", "#cboEmiteGuia", 0);
    formateaFecha("#txtFechaGuia");
    $("#txtFechaGuia").val("");
    $("#txtNumGuia").val("");
    $("#divGuiaTransporte").dialog({
        modal : true,
        title : "Crear guia transporte",
        width : "300",
        height : "200",
        buttons : {
            "Guardar" : function() {
                var fechaGuia = "'" + text2date($("#txtFechaGuia").val()) + "'";
                var empresaGuia = $("#cboEmiteGuia").val();
                var numGuia = $("#txtNumGuia").val();
                $.ajax({
                    type : "GET",
                    async : true,
                    cache : false,
                    url : "../../controller/ProgramacionTransporte/Guia-ingresar.php?codServicio=" + codServicio + "&fechaGuia=" + fechaGuia + "&empresaGuia=" + empresaGuia + "&numGuia=" + numGuia,
                    error : function(xhr, status, error) {
                        // you may need to handle me if the json is invalid
                        // this is the ajax object
                    },
                    success : function(data) {
                        cargaGrillaInventario();
                    }
                });
                $(this).dialog("close");
            },
            "Cerrar" : function() {
                $(this).dialog("close");
            }
        }
    });
}

/*
 * Edita una guia asociada a un servicio
 */
function editarGuia(codServicio, fecha, codGuia, codEmpresa, numGuia) {
    cargaCambo(25, "", "#cboEmiteGuia", codEmpresa);
    formateaFecha("#txtFechaGuia");
    $("#txtNumGuia").val(numGuia);
    $("#txtFechaGuia").val(fecha.split(' ')[0]);
    $("#cboEmiteGuia").val(codEmpresa);
    $("#divGuiaTransporte").dialog({
        modal : true,
        title : "Editar guia transporte",
        width : "300",
        height : "200",
        buttons : {
            "Guardar" : function() {
                codEmpresa = $("#cboEmiteGuia").val();
                fecha = "'" + text2date($("#txtFechaGuia").val()) + "'";
                numGuia = $("#txtNumGuia");
                $("#divGuiaTransporte").dialog({
                    modal : true,
                    title : "Crear guia transporte",
                    width : "300",
                    height : "200",
                    buttons : {
                        "Guardar" : function() {
                            var fechaGuia = "'" + text2date($("#txtFechaGuia").val()) + "'";
                            var empresaGuia = $("#cboEmiteGuia").val();
                            var numGuia = $("#txtNumGuia").val();
                            $.ajax({
                                type : "GET",
                                async : false,
                                cache : false,
                                url : "../../controller/ProgramacionTransporte/Guia-editar.php?codGuia=" + codGuia + "& codServicio=" + codServicio + "&fechaGuia=" + fechaGuia + "&empresaGuia=" + empresaGuia + "&numGuia=" + numGuia,
                                error : function(xhr, status, error) {
                                    // you may need to handle me if the json is invalid
                                    // this is the ajax object
                                },
                                success : function(data) {
                                       cargaGrillaInventario();
                                       
                                }
                            });    
                            $(this).dialog("close");                            
                        },
                        "Cerrar" : function() {
                            $(this).dialog("close");
                        }
                    }
                });

            },
            "Cerrar" : function() {
                $(this).dialog("close");
            }
        }
    });
}

/*
 * Carga la grilla de inventario
 */
function cargaGrillaInventario() {

    var alto = $(document).height() - 150;
    var ancho = $(document).width() - 330;
    var urlGrilla = '../../controller/Inventario/inventario_listar.php';

    jQuery("#tblInventario").jqGrid({
        datatype : "json",
        url : urlGrilla,
        height : alto,
        autowidth : true,
        colNames : ['Id', 'Ubicacion', 'Estado', 'Cliente', 'Contenedor', 'Peso', 'Contenido', 'Observaciones', 'Ingreso', 'D.Cust', 'D.Stop','Demurrage','Guia'],
        colModel : [{
            name : 'car_ncorr',
            index : 'car_ncorr',
            width : 50,
            sorttype : "int"
        }, {
            name : 'ubicacion',
            index : 'ubicacion',
            width : 90
        }, {
            name : 'esca_vdescripcion',
            index : 'esca_vdescripcion',
            width : 100
        }, {
            name : 'clie_vnombre',
            index : 'clie_vnombre',
            width : 100,
            align : 100,
        }, {
            name : 'cont_vnumcontenedor',
            index : 'cont_vnumcontenedor',
            width : 100,
            align : "left",
            sorttype : "float"
        }, {
            name : 'cont_npeso',
            index : 'cont_npeso',
            width : 70,
            align : "right",
            sorttype : "float",
            formatter : 'currency',
            formatoptions : {
                prefix : '',
                suffix : ' Kg',
                thousandsSeparator : '.',
                decimalPlaces : 0
            },
        }, {
            name    : 'cont_vcontenido',
            index   : 'cont_vcontenido',
            width   : 100,
            align   : "left"
        }, {
            name    : 'car_vobservaciones',
            index   : 'car_vobservaciones',
            width   : 100,
            sortable : false
        }, {
            name    : 'termino',
            index   : 'termino',
            width   : 120,
            sortable : false
        }, {
            name    : 'diasbodega',
            index   : 'diasbodega',
            width   : 50
        }, {
            name    : 'diascustodia',
            index   : 'diascustodia',
            width   : 50
        },{
            name    : 'demurrage',
            index   : 'demurrage',
            width   : 80,
            align   : 'center'
        },{
            name    : 'guia',
            index   : 'guia',
            width   : 80,
            align   : 'left'
        }],
        //multiselect : true,
        caption : "Inventario de contenedores ",
        //grouping:true,
        viewrecords : false,
        sortname : 'esca_vdescripcion',
        pager : '#pagTblInventario',
        grouping : true,
        groupingView : {
            groupField : ['esca_vdescripcion'],
            groupColumnShow : [true],
            groupText : ['<b>{0} - {1} Carga(s)</b>'],
            groupCollapse : true,
            groupOrder : ['asc'],
            groupSummary : [false],
            groupDataSorted : true
        }
    });

    jQuery("#chngroup").change(function() {
        var vl = $(this).val();
        if (vl) {
            if (vl == "clear") {
                jQuery("#tblInventario").jqGrid('groupingRemove', true);
            } else {
                jQuery("#tblInventario").jqGrid('groupingGroupBy', vl);
            }
        }
    });

    jQuery("#tblInventario").jqGrid('navGrid', "#pagTblInventario", {
        add : false,
        edit : false,
        del : false,
        search : false,
        refresh : true
    });
    
    $('#tblInventario').setGridParam({url: urlGrilla}).trigger("reloadGrid");
}

/*
 * Registra la devolución de un container
 */
function registrarDevolucion(idCarga) {
    var codLugar;
    var fechaDevolucion;
    formateaFecha("#txtFechaEntrega");
    cargaCambo(9,"","#cboLugarDevolucion",0);
    $("#divDevolucion").dialog({
        modal : true,
        title : "Retornar container",
        width : "300",
        height : "200",
        buttons : {
            "Finalizar" : function() {
                codLugar        = $("#cboLugarDevolucion").val();
                fechaDevolucion = text2date($("#txtFechaEntrega").val()).split(' ')[0]; 
                $.ajax({
                    type : "GET",
                    url : "../../controller/Inventario/carga_devolver.php?idCarga="+idCarga+"&codLugar="+codLugar+"&fecha="+fechaDevolucion,
                    dataType : "json",
                    success : function(result) {
                        cargaGrillaInventario();
                        $(this).dialog("close");
                    },
                });

            },
            "Cerrar" : function() {
                $(this).dialog("close");
            }
        }
    });

}
