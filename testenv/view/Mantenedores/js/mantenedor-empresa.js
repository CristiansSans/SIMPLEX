var comboTramos;

function validarRutEmpresa() {
    /*var textoRut = $("#txtRutEmpresa").val();
     console.log(textoRut);
     return Rut(textoRut);*/
    return true;
}

function muestraFicha(codEmpresa) {
    $("#tabs").tabs();
    if (codEmpresa == 0) {
        $("#txtCodEmpresa").val("");
        $("#txtNombreEmpresa").val("");
        $("#txtRutEmpresa").val("");
        $("#txtDireccion").val("");
        $("#txtGiro").val("");
        $("#txtContacto").val("");
        $("#txtFono").val("");
        $("#txtMail").val("");
        $("#txtRazonSocial").val("");
        $("#txtActividad").val("");
    }

    cargaGrillaTarifas(codEmpresa);
    /*cargaGrillaCamiones();
     cargaGrillaChasis();
     cargaGrillaChoferes();*/

    $("#divFichaEmpresa").dialog({
        modal : true,
        width : "900px",
        height : 600,
        title : "Ficha de empresa",
        buttons : {
            "Guardar" : function() {
                if (validaAlmacenamiento()) {
                    var codRut = $("#txtRutEmpresa").val();
                    var codEmpresa = $("#txtCodEmpresa").val();
                    var oper;
                    var urlController;
                    if (codEmpresa == "") {
                        oper = "add";
                    } else {
                        oper = "edit";
                    }
                    var generaGuia = $("#chkGeneraGuia").prop("checked") ? 1 : 0;

                    urlController = "../../controller/mantenedores/editar-empresa.php?oper=" + oper;
                    urlController += "&CodEmpresa=" + codEmpresa;
                    urlController += "&NombreEmpresa=" + $("#txtNombreEmpresa").val();
                    urlController += "&RutEmpresa=" + $("#txtRutEmpresa").val();
                    urlController += "&Direccion=" + $("#txtDireccion").val();
                    urlController += "&Giro=" + $("#txtGiro").val();
                    urlController += "&Actividad=" + $("#txtActividad").val();
                    urlController += "&Contacto=" + $("#txtContacto").val();
                    urlController += "&Fono=" + $("#txtFono").val();
                    urlController += "&Mail=" + $("#txtMail").val();
                    urlController += "&RazonSocial=" + $("#txtRazonSocial").val();
                    urlController += "&Guia=" + generaGuia;

                    $.ajax({
                        type : "GET",
                        url : urlController,
                        dataType : "json",
                        async : false,
                        //data: objJson,
                        success : function(result) {
                            
                            alert(result.data);
                        }
                    });
                    cargarGrillaEmpresas();
                    $(this).dialog("close");
                }
            },
            "Cerrar" : function() {
                $(this).dialog("close");
            }
        }
    });
}

function validaAlmacenamiento() {
    if (validaRutObjeto($("#txtRutEmpresa"))) {

        if ($("#txtNombreEmpresa").val() == "") {
            alert("Debe ingresar el nombre de la empresa");
        } else {
            return true;
        }

    }
    return false;
}

function agregarEmpresa() {
    muestraFicha(0);
}

function cargaGrillaChoferes() {
    var lastsel2;
    codEmpresa = $("#txtCodEmpresa").val();

    jQuery("#tblChofer").jqGrid({
        url : '../../controller/mantenedores/grillaChoferes-listar.php?codEmpresa=' + codEmpresa,
        datatype : "json",
        colNames : ['Codigo', 'Rut', 'Nombre', 'Patente', 'Fono'],
        colModel : [{
            name : 'CHOF_NCORR',
            index : 'CHOF_NCORR',
            editable : false,
            width : 50,
            hidden : true
        }, {
            name : 'CHOF_VRUT',
            index : 'CHOF_VRUT',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 150
        }, {
            name : 'CHOF_VNOMBRE',
            index : 'CHOF_VNOMBRE',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 150
        }, {
            name : 'CAM_VPATENTE',
            index : 'CAM_VPATENTE',
            editable : false,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 150
        }, {
            name : 'CHOF_VFONO',
            index : 'CHOF_VFONO',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "20"
            },
            width : 100
        }],
        rowNum : 20,
        rowList : [20, 30, 40],
        pager : '#pagtblChofer',
        sortname : 'CHOF_VNOMBRE',
        viewrecords : true,
        sortorder : "ASC",
        onSelectRow : function(id) {
            if (id && id !== lastsel2) {
                jQuery('#tblChofer').jqGrid('restoreRow', lastsel2);
                jQuery('#tblChofer').jqGrid('editRow', id, true);
                lastsel2 = id;
            }
        },
        loadComplete : function() {
            //cargaGrillaTarifas();
        },
        editurl : "../../controller/mantenedores/editar-chofer.php?EMP_NCORR=" + $("#txtCodEmpresa").val(),
        //caption : "Tarifas",
        autowidth : true,
        height : 200
    });

    $('#tblChofer').setGridParam({
        url : '../../controller/mantenedores/grillaChoferes-listar.php?codEmpresa=' + codEmpresa
    }).trigger("reloadGrid");
    jQuery("#tblChofer").jqGrid('navGrid', "#pagtblChofer", {
        edit : false,
        add : false,
        del : true
    });
    jQuery("#tblChofer").jqGrid('inlineNav', "#pagtblChofer");

}

function cargaGrillaChasis(codEmpresa) {
    var codEmpresa2 = $("#txtCodEmpresa").val();
    var lastsel2;

    jQuery("#tblChasis").jqGrid({
        url : '../../controller/mantenedores/grillaChasis-listar.php?codEmpresa=' + codEmpresa,
        datatype : "json",
        colNames : ['Codigo', 'Patente'],
        colModel : [{
            name : 'CHA_NCORR',
            index : 'CHA_NCORR',
            editable : false,
            width : 50,
            hidden : true
        }, {
            name : 'CHA_VPATENTE',
            index : 'CHA_VPATENTE',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 600
        }],
        rowNum : 20,
        rowList : [20, 30, 40],
        pager : '#pagtblChasis',
        sortname : 'CHA_VPATENTE',
        //viewrecords : true,
        sortorder : "ASC",
        onSelectRow : function(id) {
            if (id && id !== lastsel2) {
                jQuery('#tblChasis').jqGrid('restoreRow', lastsel2);
                jQuery('#tblChasis').jqGrid('editRow', id, true);
                lastsel2 = id;
            }
        },
        loadComplete : function() {
            cargaGrillaChoferes();
        },
        editurl : "../../controller/mantenedores/editar-chasisempresa.php?EMP_NCORR=" + $("#txtCodEmpresa").val(),
        autowidth : true,
        height : 200
    });

    jQuery("#tblChasis").jqGrid('navGrid', "#pagtblChasis", {
        edit : false,
        add : false,
        del : false
    });
    jQuery("#tblChasis").jqGrid('inlineNav', "#pagtblChasis");

    $('#tblChasis').setGridParam({
        //url : '../../controller/mantenedores/grillaChasis-listar.php?codEmpresa=' + codEmpresa
        url : '../../controller/mantenedores/grillaChasis-listar.php?codEmpresa=' + $("#txtCodEmpresa").val() + "&nd=" + new Date().getTime()
    }).trigger("reloadGrid");
}

function cargaGrillaCamiones(codempresa) {
    //codempresa = $("#txtCodEmpresa").val();
    var lastsel2;
    jQuery("#tblCamiones").jqGrid({
        url : '../../controller/mantenedores/grillaCamiones-listar.php?codEmpresa=' + codempresa,
        datatype : "json",
        colNames : ['Codigo', 'Patente', 'Marca', 'Modelo'],
        colModel : [{
            name : 'CAM_NCORR',
            index : 'CAM_NCORR',
            editable : false,
            width : 50,
            hidden : true
        }, {
            name : 'CAM_VPATENTE',
            index : 'CAM_VPATENTE',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 150
        }, {
            name : 'CAM_VMARCA',
            index : 'CAM_VMARCA',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 200
        }, {
            name : 'CAM_VMODELO',
            index : 'CAM_VMODELO',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "50"
            },
            width : 300
        }],
        rowNum : 20,
        rowList : [20, 30, 40],
        pager : '#pagtblCamiones',
        sortname : 'CAM_VPATENTE',
        //viewrecords : true,
        sortorder : "ASC",
        loadonce : false,
        onSelectRow : function(id) {
            if (id && id !== lastsel2) {
                jQuery('#tblCamiones').jqGrid('restoreRow', lastsel2);
                jQuery('#tblCamiones').jqGrid('editRow', id, true);
                lastsel2 = id;
                //var cont = $('#tblTarifas').getCell(id, 'LUG_VSIGLA');
            }
        },
        loadComplete : function() {
            cargaGrillaChasis(codempresa);
        },
        editurl : "../../controller/mantenedores/editar-camionempresa.php?EMP_NCORR=" + $("#txtCodEmpresa").val(),
        //caption : "Tarifas",
        autowidth : true,
        height : 200
    });

    jQuery("#tblCamiones").jqGrid('navGrid', "#pagtblCamiones", {
        edit : false,
        add : false,
        del : true
    });
    jQuery("#tblCamiones").jqGrid('inlineNav', "#pagtblCamiones");

    $('#tblCamiones').setGridParam({
        //url : '../../controller/mantenedores/grillaCamiones-listar.php?codEmpresa=' + codempresa
        url : '../../controller/mantenedores/grillaCamiones-listar.php?codEmpresa=' + $("#txtCodEmpresa").val() + "&nd=" + new Date().getTime()
    }).trigger("reloadGrid");
}

function cargaGrillaTarifas(codEmpresa) {
    var lastsel2;
    $.ajax({
        type : "POST",
        url : "../../controller/mantenedores/comboLugares-listar.php",
        dataType : "json",
        //data: objJson,
        success : function(result) {
            jQuery("#tblTarifas").jqGrid({
                url : '../../controller/mantenedores/grillaTarifas-listar.php?codEmpresa=' + $("#txtCodEmpresa").val() + "&nd=" + new Date().getTime(),
                datatype : "json",
                colNames : ['Codigo', 'Tramo', 'Monto'],
                colModel : [{
                    name : 'TAR_NCORR',
                    index : 'TAR_NCORR',
                    editable : true,
                    width : 50,
                    hidden : true
                }, {
                    name : 'TRA_NCORR',
                    index : 'TRA_NCORR',
                    editable : true,
                    hidden : false,
                    edittype : "select",
                    editoptions : comboTramos,
                    formatter : 'select',
                    editrules : {
                        required : true,
                    }
                }, {
                    name : 'TAR_NMONTO',
                    index : 'TAR_NMONTO',
                    editable : true,
                    formatter : 'currency',
                    formatoptions : {
                        prefix : '$',
                        suffix : '',
                        thousandsSeparator : '.',
                        decimalPlaces : 0
                    },
                    editoptions : {
                        size : "20",
                        maxlength : "20"
                    },
                    editrules : {
                        required : true,
                        number : true,
                        maxValue : 10000000,
                        minValue : 0
                    },
                    width : 100
                }],
                rowNum : 20,
                rowList : [20, 30, 40],
                pager : '#pagtblTarifas',
                sortname : 'TAR_NCORR',
                sortorder : "ASC",
                editurl : '../../controller/mantenedores/editar-tarifa.php?codEmpresa=' + $("#txtCodEmpresa").val() + "&nd=" + new Date().getTime(),
                caption : "Tarifas",
                autowidth : true,
                height : 200,
                loadonce : false,
                emptyrecords : "No se han encontrado registros",
                onSelectRow : function(id) {
                    if (id && id !== lastsel2) {
                        jQuery('#tblTarifas').jqGrid('restoreRow', lastsel2);
                        jQuery('#tblTarifas').jqGrid('editRow', id, true);
                        lastsel2 = id;
                    }
                },
                loadComplete : function() {
                    cargaGrillaCamiones(codEmpresa);
                }
            });
            $('#tblTarifas').setGridParam({
                url : '../../controller/mantenedores/grillaTarifas-listar.php?codEmpresa=' + $("#txtCodEmpresa").val() + "&nd=" + new Date().getTime(),
                editurl : '../../controller/mantenedores/editar-tarifa.php?codEmpresa=' + $("#txtCodEmpresa").val() + "&nd=" + new Date().getTime(),
            }).trigger("reloadGrid");

            jQuery("#tblTarifas").jqGrid('navGrid', "#pagtblTarifas", {
                edit : false,
                add : false,
                del : true
            });
            jQuery("#tblTarifas").jqGrid('inlineNav', "#pagtblTarifas");
        }
    });
}

function cargarGrillaEmpresas() {
    var lastsel2;
    jQuery("#tblListadoEmpresas").jqGrid({
        url : '../../controller/mantenedores/listar-grilla_empresas.php',
        datatype : "json",
        colNames : ['EMP_NCORR', 'Rut', 'Nombre', 'Razon Social', 'Direccion', 'Giro', 'Contacto', 'Fono', 'Mail', 'Actividad','Guia'],
        colModel : [{
            name : 'EMP_NCORR',
            index : 'EMP_NCORR',
            editable : false,
            width : 50,
            hidden : true
        }, {
            name : 'EMP_VRUT',
            index : 'EMP_VRUT',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "20"
            },
            width : 60
        }, {
            name : 'EMP_VNOMBRE',
            index : 'EMP_VNOMBRE',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "200"
            },
            width : 120
        }, {
            name : 'EMP_VRAZONSOCIAL',
            index : 'EMP_VRAZONSOCIAL',
            editable : true,
            width : 100
        }, {
            name : 'EMP_VDIRECCION',
            index : 'EMP_VDIRECCION',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "300"
            },
            width : 100
        }, {
            name : 'EMP_VGIRO',
            index : 'EMP_VGIRO',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "45"
            },
            width : 50
        }, {
            name : 'EMP_VCONTACTO',
            index : 'EMP_VCONTACTO',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "45"
            },
            width : 50
        }, {
            name : 'EMP_VFONO',
            index : 'EMP_VFONO',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "45"
            },
            width : 50
        }, {
            name : 'EMP_VMAIL',
            index : 'EMP_VMAIL',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "45"
            },
            width : 50
        }, {
            name : 'EMP_VACTIVIDAD',
            index : 'EMP_VACTIVIDAD',
            editable : true,
            editoptions : {
                size : "20",
                maxlength : "45"
            },
            width : 50
        }, {
            name : 'EMP_NGENERAGUIA',
            index : 'EMP_NGENERAGUIA',
            editable : true,
            edittype : 'checkbox',
            formatter : 'checkbox',
            editoptions : {
                value : "1:0"
            },
            width : 30,
            align : "center"
        }],
        rowNum : 20,
        rowList : [20, 30, 40],
        pager : '#pagTblLugares',
        sortname : 'EMP_VNOMBRE',
        viewrecords : true,
        sortorder : "ASC",
        emptyrecords : "No se han encontrado registros",
        ondblClickRow : function(rowid) {
            var codEmpresa = $('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_NCORR');
            if (codEmpresa != "0") {

                $("#txtCodEmpresa").val(codEmpresa);
                $("#txtNombreEmpresa").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VNOMBRE'));
                $("#txtRutEmpresa").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VRUT'));
                $("#txtDireccion").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VDIRECCION'));
                $("#txtGiro").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VGIRO'));
                $("#txtActividad").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VACTIVIDAD'));
                $("#txtContacto").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VCONTACTO'));
                $("#txtFono").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VFONO'));
                $("#txtMail").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VMAIL'));
                $("#txtRazonSocial").val($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_VRAZONSOCIAL'));
                
                if ($('#tblListadoEmpresas').jqGrid('getCell', rowid, 'EMP_NGENERAGUIA')==1){
                    $("#chkGeneraGuia").prop("checked", "checked");    
                }else{
                    $("#chkGeneraGuia").prop("checked", "");
                }
                
                
                
                
                
                muestraFicha(codEmpresa);
            }
        },
        editurl : "../../controller/mantenedores/eliminar-empresa.php",
        caption : "Proveedores",
        autowidth : true,
        height : 400
    });

    jQuery("#tblListadoEmpresas").jqGrid('navGrid', "#pagTblLugares", {
        edit : false,
        add : false,
        del : true
    });
    jQuery("#tblListadoEmpresas").jqGrid('inlineNav', "#pagTblLugares");

    $('#tblLugares').setGridParam({
     url : '../../controller/mantenedores/listar-grilla_empresas.php'
     }).trigger("reloadGrid");
}

function cargaComboTramos() {
    $.ajax({
        type : "POST",
        url : "../../controller/mantenedores/comboLugares-listar.php",
        dataType : "json",
        //data: objJson,
        success : function(result) {
            //var values = result.values;
            comboValues2 = {
                value : result.values
            };

            $.ajax({
                type : "POST",
                url : "../../controller/mantenedores/comboTramos-listar.php",
                dataType : "json",
                //data: objJson,
                success : function(result2) {
                    comboTramos = {
                        value : result2.values
                    };
                },
            });
        },
    });
}
