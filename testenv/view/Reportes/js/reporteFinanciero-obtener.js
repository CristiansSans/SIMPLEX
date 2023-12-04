function inicializar(){
    formateaFecha("#txtFechaInicio");
    formateaFecha("#txtFechaTermino");
    cargaCambo(1,"","#cboCliente",0);
}

function obtenerExportacion(){
    var cliente = $("#cboCliente").val();
    var inicio  = $("#txtFechaInicio").val()!=""?text2date($("#txtFechaInicio").val()):"";
    var termino  = $("#txtFechaTermino").val()!=""?text2date($("#txtFechaTermino").val()):"";
    var url = "../../controller/reportes/reportedatos-obtener.php?cliente="+cliente+"&inicio="+inicio+"&termino="+termino;
    
    /*
    $.ajax({
        type : "GET",
        url : url,
        dataType : "json",
        //data: objJson,
        success : function(result) {
              
        }
    });
    */
   
    window.location = url;
}
