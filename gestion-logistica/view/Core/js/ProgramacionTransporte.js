var _HAYEMPRESAS;
var _DIFERENCIAMINIMA = 20;

/*
 * Carga la grilla de programación de transporte
 */
function cargaGrillaProgramacionTransporte() {
    var alto = $(document).height() - 100;
    jQuery("#tblOrdenes").jqGrid({
        datatype : "json",
        url : '../../controller/ProgramacionTransporte/Programacion-listar.php',
        height : alto,
        autowidth : true,
        colNames : ['Id.Carga', 'Cliente', 'Servicio', 'Inicio', 'Origen', 'Termino', 'Destino', 'Transportista', 'Patente', 'N°Guia', 'IdOrigen', 'IdDestino', 'IdEmpresa', '', '', '', '', '','',''],
        colModel : [{
            name : 'car_ncorr',
            index : 'car_ncorr',
            width : 50,
            sorttype : "float"
        }, {
            name : 'clie_vnombre',
            index : 'clie_vnombre',
            width : 100,
            align : "left"
        }, {
            name : 'tise_vdescripcion',
            index : 'tise_vdescripcion',
            width : 100,
            align : "left"
        }, {
            name : 'serv_dinicio',
            index : 'serv_dinicio',
            width : 100,
            align : "center"
        }, {
            name : 'descripcionlugarorigen',
            index : 'descripcionlugarorigen',
            width : 100,
            align : "Left"
        }, {
            name : 'serv_dtermino',
            index : 'serv_dtermino',
            width : 100,
            sortable : false,
            align : "center"
        }, {
            name : 'descripcionlugardestino',
            index : 'descripcionlugardestino',
            width : 150,
            sortable : false,
            align : "Left"
        }, {
            name : 'emp_vnombre',
            index : 'emp_vnombre',
            width : 150,
            sortable : false,
            align : "left"
        }, {
            name : 'cam_vpatente',
            index : 'cam_vpatente',
            width : 80,
            sortable : false,
            align : "left"
        }, {
            name : 'guia_numero',
            index : 'guia_numero',
            width : 100,
            sortable : false,
            align : "right"
        }, {
            name : 'idlugarorigen',
            index : 'idlugarorigen',
            hidden : true
        }, {
            name : 'idlugardestino',
            index : 'idlugardestino',
            hidden : true
        }, {
            name : 'emp_ncorr',
            index : 'emp_ncorr',
            hidden : true
        }, {
            name : 'cam_ncorr',
            index : 'cam_ncorr',
            hidden : true
        }, {
            name : 'cha_ncorr',
            index : 'cha_ncorr',
            hidden : true
        }, {
            name : 'chof_ncorr',
            index : 'chof_ncorr',
            hidden : true
        }, {
            name : 'serv_vcelular',
            index : 'serv_vcelular',
            hidden : true
        }, {
            name : 'sts_ncorr',
            index : 'sts_ncorr',
            hidden : true
        },{
            name    : 'tine_ncorr',
            index   : 'tine_ncorr',
            hidden  : true
        },{
            name    : 'car_fechaeta',
            index   : 'car_fechaeta',
            hidden  : true
        }],
        multiselect : false,
        rownum  : 200,
        caption : "Carga programada",
        ondblClickRow : function(rowid) {
            programarTransporte(rowid);
        }
    });

    $('#tblOrdenes').setGridParam({
        url : '../../controller/ProgramacionTransporte/Programacion-listar.php'
    }).trigger("reloadGrid");
}

function cargaFonoChofer(){
    var idChofer = $("#cboConductor").val();
    $.ajax({
        type : "GET",
        async : false,
        cache : false,
        url : "../../controller/ProgramacionTransporte/FonoChofer-obtener.php?chofer=" + idChofer,
        error : function(xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success : function(data) {
            var texto = data;
            $("#txtCelular").val(texto);
        }
    });    
}

/*
 * Refresca los combos al cambiar el transportista seleccionado
 */
function refrescaCombos() {
    var codTransportista = $("#cboTransportista").val();
    cargaCambo(15, codTransportista, "#cboPatenteCamion", 0);
    cargaCambo(16, codTransportista, "#cboPatenteChasis", 0);
    cargaCambo(17, codTransportista, "#cboConductor", 0);
}

function cargaCombos() {
    cargaCambo(9, "", "#cboDestino", 0);
    //cargaCambo(14,"","#cboTransportista",0);
}

function cargaComboEmpresas2(tsNombreCombo, codUbicacion, codDestino) {
    var cuenta;
    cuenta = 0;
    $.ajax({
        type : "GET",
        async : false,
        cache : false,
        url : "../../controller/CoordinacionTransporte/comboEmpresas-listar.php?codUbicacion=" + codUbicacion + "&codDestino=" + codDestino,
        error : function(xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success : function(data) {
            var array = data.split("|");
            var registros = data.split("|").length;
            console.log(registros);
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));

            for ( i = 0; i < registros; i++) {
                if (array[i] != "" && array[i].length > 1) {
                    var valor = array[i].split(":")[0];
                    var texto = array[i].split(":")[1];
                    $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
                    cuenta++;
                    _HAYEMPRESAS = true;
                }
            }

            if (cuenta == 0) {
                showMessage("Error", "No hay empresas asociadas a este tramo");
                return [false];
            } else {
                return [true];
            }
        }
    });
}

/*
 * Carga el combo de lugares de destino dependiendo del servicio y ubicación actual
 */
function cargaComboLugares(codServicio, codUbicacion, tsNombreCombo, tnValorPreseleccionado) {
    var cuenta;
    cuenta = 0;
    $.ajax({
        type : "GET",
        async : false,
        cache : false,
        url : "../../controller/CoordinacionTransporte/comboDestinos-listar.php?codServicio=" + codServicio + "&codLugar=" + codUbicacion,
        error : function(xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success : function(data) {
            var array = data.split("|");
            var registros = data.split("|").length;
            console.log(registros);
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));

            for ( i = 0; i < registros; i++) {
                if (array[i] != "" && array[i].length > 1) {
                    var valor = array[i].split(":")[0];
                    var texto = array[i].split(":")[1];

                    if (tnValorPreseleccionado == valor) {
                        $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto).attr("selected", "selected"));
                    } else {
                        $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
                    }

                    //$(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
                    cuenta++;
                }
            }

            if (cuenta == 0) {
                showMessage("Error", "No hay tramos configurados para el servicio asociado a esta carga");
            }
        }
    });
}

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
                        cargaGrillaProgramacionTransporte();
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
                                async : true,
                                cache : false,
                                url : "../../controller/ProgramacionTransporte/Guia-editar.php?codGuia=" + codGuia + "& codServicio=" + codServicio + "&fechaGuia=" + fechaGuia + "&empresaGuia=" + empresaGuia + "&numGuia=" + numGuia,
                                error : function(xhr, status, error) {
                                    // you may need to handle me if the json is invalid
                                    // this is the ajax object
                                },
                                success : function(data) {
                                    cargaGrillaProgramacionTransporte();
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
 * Guarda los datos de la programación de transporte
 */
function guardarProgramacion() {

    if (validarIngresoProgramacionTransporte()) {
        var p0 = $("#lblIdCarga").text();
        var p1 = $("#cboDestino").val();
        var p2 = $("#txtCodLugarOrigen").val();
        var p3 = text2dateTime($("#txtFechaInicio").val()) + ":00";
        var p4 = text2dateTime($("#txtFechaTermino").val()) + ":00";
        var p5 = $("#cboTransportista").val();
        var p6 = $("#cboPatenteCamion").val();
        var p7 = $("#cboPatenteChasis").val();
        var p8 = $("#cboConductor").val();
        var p9 = $("#txtCelular").val();
        var p10 = $("#hdnTipoNegocio").val();
        var p11 = p10==5? text2date($("#txtFechaETA").val()):$("#txtFechaETA").val();        

        $.ajax({
            type : "GET",
            async : true,
            cache : false,
            url : "../../controller/ProgramacionTransporte/Programacion-ingresar.php?p0=" + p0 + "&p1=" + p1 + "&p2=" + p2 + "&p3=" + p3 + "&p4=" + p4 + "&p5=" + p5 + "&p6=" + p6 + "&p7=" + p7 + "&p8=" + p8 + "&p9=" + p9 + "&p10=" + p10 + "&p11=" + p11,
            error : function(xhr, status, error) {

            },
            success : function(data) {
                $("#divProgramacionTransporte").dialog("close");
                showMessageAuxiliar("Carga programada exitosamente");
                cargaGrillaProgramacionTransporte();
            }
        });
    }
}

/*
 * Valida el ingreso de la programacion de transporte
 */
function validarIngresoProgramacionTransporte() {
    var texto = "";
    if ($("#txtFechaInicio").val() == "") {
        texto = "- Fecha inicio\n";
    };

    if ($("#cboDestino").val() == 0) {
        texto += "- Destino\n";
    };

    if ($("#txtFechaTermino").val() == "") {
        texto += "- Fecha de termino\n";
    };

    if ($("#cboTransportista").val() == 0) {
        texto += "- Transportista\n";
    };

    if ($("#cboPatenteCamion").val() == 0) {
        texto += "- Patente camion\n";
    };

    if ($("#cboPatenteChasis").val() == 0) {
        texto += "- Patente chasis\n";
    };

    if ($("#cboConductor").val() == 0) {
        texto += "- Conductor\n";
    };

    if ($("#txtCelular").val() == "") {
        texto += "- Celular\n";
    };
    
    if (diferenciaHoras($("#txtFechaInicio").val(),$("#txtFechaTermino").val())<_DIFERENCIAMINIMA){
        texto += "- La diferencia de tiempo no puede ser inferior a "+_DIFERENCIAMINIMA +" minutos\n";
    }
    
    if ($("#hdnTipoNegocio").val()==5 && $("#txtFechaETA").val()==""){
        texto += "- ETA\n";
    }

    if (texto == "") {
        return true;
    } else {
        showMessage("Error", "Falta ingesar los siguientes datos :\n" + texto);
        return false;
    }
}

/*
 * Carga el combo de empresas
 */
function cargaComboEmpresas() {
    var codOrigen = $("#txtCodLugarOrigen").val();
    var codDestino = $("#cboDestino").val();
    cargaComboEmpresas2("#cboTransportista", codOrigen, codDestino);
}

/*
 * Levanta formulario de programacion de transporte
 */
function programarTransporte(rowid) {
    var alto;
    $("#lblIdCarga").text($('#tblOrdenes').jqGrid('getCell', rowid, 'car_ncorr'));
    $("#lblTipoServicio").text($('#tblOrdenes').jqGrid('getCell', rowid, 'tise_vdescripcion'));
    $("#lblOrigen").text($('#tblOrdenes').jqGrid('getCell', rowid, 'descripcionlugarorigen'));
    $("#txtFechaInicio").val($('#tblOrdenes').jqGrid('getCell', rowid, 'serv_dinicio'));
    $("#txtCodLugarOrigen").val($('#tblOrdenes').jqGrid('getCell', rowid, 'idlugarorigen'));
    $("#txtFechaTermino").val($('#tblOrdenes').jqGrid('getCell', rowid, 'serv_dtermino'));
    $("#txtCelular").val($('#tblOrdenes').jqGrid('getCell', rowid, 'serv_vcelular'));
    $("#txtCodServicio").val($('#tblOrdenes').jqGrid('getCell', rowid, 'sts_ncorr'));
    $("#hdnTipoNegocio").val($('#tblOrdenes').jqGrid('getCell', rowid, 'tine_ncorr'));    
    $("#txtFechaETA").val($('#tblOrdenes').jqGrid('getCell', rowid, 'car_fechaeta'));
    
    if ($("#hdnTipoNegocio").val()==5){
        $("#txtFechaETA").attr("style","display:inline");
        $("#lblETA").attr("style","display:inline");
        formateaFecha("#txtFechaETA");
        alto = "430";
    }else{
        $("#txtFechaETA").attr("style","display:none");
        $("#lblETA").attr("style","display:none");
        desformateaFecha("#txtFechaETA");
        alto = "400"; 
    }

    var codTransportista = $('#tblOrdenes').jqGrid('getCell', rowid, 'emp_ncorr');
    var codCamion = $('#tblOrdenes').jqGrid('getCell', rowid, 'cam_ncorr');
    var codChasis = $('#tblOrdenes').jqGrid('getCell', rowid, 'cha_ncorr');
    var codChofer = $('#tblOrdenes').jqGrid('getCell', rowid, 'chof_ncorr');
    var codDestino = $('#tblOrdenes').jqGrid('getCell', rowid, 'idlugardestino');
    var codOrigen = $('#tblOrdenes').jqGrid('getCell', rowid, 'idlugarorigen');

    _HAYEMPRESAS = false;
    cargaComboEmpresas2("#cboTransportista", codOrigen, codDestino);
    if (_HAYEMPRESAS) {
        $("#cboTransportista").val(codTransportista);
        cargaCambo(15, codTransportista, "#cboPatenteCamion", codCamion);
        cargaCambo(16, codTransportista, "#cboPatenteChasis", codChasis);
        cargaCambo(17, codTransportista, "#cboConductor", codChofer);
        cargaComboLugares($("#txtCodServicio").val(), $("#txtCodLugarOrigen").val(), "#cboDestino", codDestino);

        $("#divProgramacionTransporte").dialog({
            modal : true,
            title : "Programar transporte",
            width : "450",
            height : alto,
            buttons : {
                "Guardar" : function() {
                    if (guardarProgramacion()) {
                        $(this).dialog("close");
                    }
                },
                "Cerrar" : function() {
                    $(this).dialog("close");
                }
            }
        });
    }
}