
function llenaCombo(objeto,texto){
	$(objeto).empty();
	$(objeto).append($("<option></option>").attr("value", 0).text(""));
	var array = texto.split("|");
	var registros = texto.split("|").length;
	for (i=0; i<registros;i++){
		if (array[i]!=""){
			var valor = array[i].split(":")[0];
			var texto = array[i].split(":")[1];
			$(objeto).append($("<option></option>").attr("value", valor).text(texto));
		}
	}
}

function combosReportePoblar(){
	$.ajax({
        type: "POST",
        url: "../../controller/mantenedores/datosCombo-listar.php",
        dataType: "json",
        //data: objJson,
        success: function (result) {
        	llenaCombo("#cboOrigen",result.lugares);
        	llenaCombo("#cboDestino",result.lugares);
        	llenaCombo("#cboCliente",result.clientes);
        	llenaCombo("#cboEmpresa",result.empresas);
		        	
		    $( "#txtFechaOrdenDesde" ).datepicker({
		      showOn: "button",
		      buttonImage: "../Mantenedores/img/ico_calendar.png",
		      buttonImageOnly: true
		    });     
		    $( "#txtFechaOrdenHasta" ).datepicker({
		      showOn: "button",
		      buttonImage: "../Mantenedores/img/ico_calendar.png",
		      buttonImageOnly: true
		    });  		       	
        }
	});	
}

function exportaInventario(){
	window.location.href = "../../controller/reportes/reporteinventarioxls-obtener.php?";
}

function generaReporte(){
	var rutCliente = $("#cboCliente").val();
	var codOrigen = $("#cboOrigen").val();
	var codDestino = $("#cboDestino").val();
	var codEmpresa = $("#cboEmpresa").val();
	window.location.href = "../../controller/reportes/reportedatosxls-obtener.php?CLIE_NRUT="+rutCliente+"&LUG_NCORR_ORIGEN="+codOrigen+"&LUG_NCORR_DESTINO="+codDestino+"&EMP_NCORR="+codEmpresa;
}
