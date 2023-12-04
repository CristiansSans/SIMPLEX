function inicializar(){
    formateaFecha("#txtFechaInicio");
    formateaFecha("#txtFechaTermino");
    cargaCambo(1,"","#cboCliente",0);
}

function obtenerExportacion(){
    var cliente = $("#cboCliente").val();
    var inicio  = $("#txtFechaInicio").val()!=""?text2date($("#txtFechaInicio").val()):"";
    var termino  = $("#txtFechaTermino").val()!=""?text2date($("#txtFechaTermino").val()):"";    
       
    var url = "../../controller/reportes/reporteinventario-obtener.php?cliente="+cliente+"&inicio="+inicio+"&termino="+termino;
    if (validaConsulta()){
        window.location = url;    
    }    
}

function validaConsulta(){
    if ($("#txtFechaInicio").val()==""){
        alert("Debe seleccionar la fecha de inicio");
    }else{
        if ($("#txtFechaTermino").val()==""){
            alert("Debe seleccionar la fecha de termino");
        }else{
            return true;
        }
    }
    return false;
}