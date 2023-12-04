var _SHOWLOG 	= false;
var _ASYNCCOMBO = true;
var _MUESTRALOG = true;

function showlog(texto){
    if (_MUESTRALOG){
        console.log(texto);
    }
}

/*
 *Obtiene la diferencia de horas entre la fecha 1 y la fecha 2, donde la fecha 2 debiera ser mayor a la fecha 1 
 */
function diferenciaHoras(fecha1,fecha2){
    var auxFecha1;
    var auxfecha2;
    var salida;
    
    auxFecha1 = fecha1.split(" ")[0].split("/")[2];
    auxFecha1 += fecha1.split(" ")[0].split("/")[1];
    auxFecha1 += fecha1.split(" ")[0].split("/")[0];
    auxFecha1 += fecha1.split(" ")[1].split(":")[0];
    auxFecha1 += fecha1.split(" ")[1].split(":")[1];
    
    auxFecha2 = fecha2.split(" ")[0].split("/")[2];
    auxFecha2 += fecha2.split(" ")[0].split("/")[1];
    auxFecha2 += fecha2.split(" ")[0].split("/")[0];
    auxFecha2 += fecha2.split(" ")[1].split(":")[0];
    auxFecha2 += fecha2.split(" ")[1].split(":")[1];    
    
    salida = auxFecha2 - auxFecha1;
    return salida;
}

function text2date(fecha){
	var nFecha = "";
	nFecha = fecha.split("/")[2];
	nFecha += "/"+ fecha.split("/")[1];
	nFecha += "/"+ fecha.split("/")[0];
	nFecha += " 00:00:00";
	return nFecha;
}

function text2dateJS(fecha){
    var nFecha = "";
    nFecha = fecha.split("/")[2];
    nFecha += "/"+ fecha.split("/")[1];
    nFecha += "/"+ fecha.split("/")[0];
    return nFecha;
    
}
/*
 * Transforma un texto con formado DD/MM/YYYY HH:MM en formato reconocido por MySql
 * 
 */
function text2dateTime(fecha){
	var lsFecha = fecha.split(' ')[0];
	var lsHora 	= fecha.split(' ')[1];
	var nFecha = "";
	nFecha = lsFecha.split("/")[2];
	nFecha += "/"+ lsFecha.split("/")[1];
	nFecha += "/"+ lsFecha.split("/")[0];	
	nFecha += " " + lsHora;
	return nFecha;
}

function showMessageAuxiliar(Mensaje){
	$.sticky(Mensaje);
}

function showMessage(Titulo,Mensaje){	
	//jAlert(Mensaje, Titulo);	
	alert(Mensaje);
}

function recuperaIdsSeleccionados(objeto){
	var s; 
	s = jQuery(objeto).jqGrid('getGridParam','selarrrow'); 
	return s;	
}

//
// Validador de Rut
// Descargado desde http://www.juque.cl/
//
function revisarDigito( dvr, objeto )
{	
	dv = dvr + "";	
	if ( dv != '0' && dv != '1' && dv != '2' && dv != '3' && dv != '4' && dv != '5' && dv != '6' && dv != '7' && dv != '8' && dv != '9' && dv != 'k'  && dv != 'K')	
	{		
		alert("Debe ingresar un digito verificador valido");		
		/*window.document.form1.rut.focus();		
		window.document.form1.rut.select();*/
		objeto.focus();		
		return false;	
	}	
	return true;
}

function revisarDigito2( crut, objeto )
{	
	largo = crut.length;	
	if ( largo < 2 )	
	{		
		alert("Debe ingresar el rut completo");		
		objeto.focus();		
		return false;	
	}	
	if ( largo > 2 )		
		rut = crut.substring(0, largo - 1);	
	else		
		rut = crut.charAt(0);	
	dv = crut.charAt(largo-1);	
	revisarDigito( dv , objeto);	

	if ( rut == null || dv == null )
		return 0;	

	var dvr = '0';	
	suma = 0;	
	mul  = 2;	

	for (i= rut.length -1 ; i >= 0; i--)	
	{	
		suma = suma + rut.charAt(i) * mul;		
		if (mul == 7)			
			mul = 2;		
		else    			
			mul++;	
	}	
	res = suma % 11;	
	if (res==1)		
		dvr = 'k';	
	else if (res==0)		
		dvr = '0';	
	else	
	{		
		dvi = 11-res;		
		dvr = dvi + "";	
	}
	if ( dvr != dv.toLowerCase() )	
	{		
		alert("EL rut es incorrecto");		
		objeto.focus();		
		return false;	
	}

	return true;
}

function validaCaracteresRUT(e) {
    var charCode;
    if (navigator.appName == "Netscape"){
		charCode = e.which;
	}
	else{
		charCode = e.keyCode;
	}
	if (charCode>=48 && charCode<=57){
		return true;
	}else{
		switch (charCode) {
			case 0:
				return true;			
			case 8:
				return true;	
			case 45:
				return true;
			case 107:
				return true;
			case 75:
				return true;
			default:
				return false;
		}
	}
}

function validaRutObjeto(objeto)
{	
	var texto = objeto.val();
	
	var tmpstr = "";	
	for ( i=0; i < texto.length ; i++ )		
		if ( texto.charAt(i) != ' ' && texto.charAt(i) != '.' && texto.charAt(i) != '-' )
			tmpstr = tmpstr + texto.charAt(i);	
	texto = tmpstr;	
	largo = texto.length;	

	if ( largo < 2 )	
	{		
		alert("Debe ingresar el rut completo");		
		/*window.document.form1.rut.focus();		
		window.document.form1.rut.select();*/
		objeto.focus();	
		return false;	
	}	

	for (i=0; i < largo ; i++ )	
	{			
		if ( texto.charAt(i) !="0" && texto.charAt(i) != "1" && texto.charAt(i) !="2" && texto.charAt(i) != "3" && texto.charAt(i) != "4" && texto.charAt(i) !="5" && texto.charAt(i) != "6" && texto.charAt(i) != "7" && texto.charAt(i) !="8" && texto.charAt(i) != "9" && texto.charAt(i) !="k" && texto.charAt(i) != "K" )
 		{			
			alert("El valor ingresado no corresponde a un R.U.T valido");			
			/*window.document.form1.rut.focus();			
			window.document.form1.rut.select();*/
			objeto.focus();		
			return false;		
		}	
	}	
	
	var invertido = "";	
	for ( i=(largo-1),j=0; i>=0; i--,j++ )		
		invertido = invertido + texto.charAt(i);	
	var dtexto = "";	
	dtexto = dtexto + invertido.charAt(0);	
	dtexto = dtexto + '-';	
	cnt = 0;	

	for ( i=1,j=2; i<largo; i++,j++ )	
	{		
		//alert("i=[" + i + "] j=[" + j +"]" );		
		if ( cnt == 3 )		
		{			
			dtexto = dtexto + '.';			
			j++;			
			dtexto = dtexto + invertido.charAt(i);			
			cnt = 1;		
		}		
		else		
		{				
			dtexto = dtexto + invertido.charAt(i);			
			cnt++;		
		}	
	}	
	
	
	invertido = "";	
	for ( i=(dtexto.length-1),j=0; i>=0; i--,j++ )		
		invertido = invertido + dtexto.charAt(i);	

	
	//window.document.form1.rut.value = invertido.toUpperCase()		

	if ( revisarDigito2(texto,objeto) )		
		return true;	

	return false;
}

function obtenerDV(rut){
	var suma;
	var mul;
	var dvr;
	dvr = '0';	
	suma = 0;	
	mul  = 2;	

	for (i= rut.length -1 ; i >= 0; i--)	
	{	
		suma = suma + rut.charAt(i) * mul;		
		if (mul == 7)			
			mul = 2;		
		else    			
			mul++;	
	}	
	res = suma % 11;	
	if (res==1)		
		dvr = 'k';	
	else if (res==0)		
		dvr = '0';	
	else	
	{		
		dvi = 11-res;		
		dvr = dvi + "";	
	}	
	
	return dvr; 
}

function cargaComboSincrono(tipo,parametro,tsNombreCombo,tnValorPreseleccionado){
    if (_SHOWLOG==true){
        console.log("CARGA COMBO==========");
        console.log("Tipo :" + tipo);
        console.log("Parametro :" + parametro);
        console.log("Nombre Combo :" + tsNombreCombo);
        console.log("Valor preseleccionado :" + tnValorPreseleccionado);
    }
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/OrdenServicio/combo-listar.php?tipo="+tipo+"&param="+parametro,        
        error: function (xhr, status, error) {
        },
        success: function (data) {
            var array = data.split("|");
            var registros = data.split("|").length;
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));      
            
            for (i=0; i<registros;i++){
                if (array[i]!="" && array[i].length>1){
                    var valor = array[i].split(":")[0];
                    var texto = array[i].split(":")[1];
                    
                    if (tnValorPreseleccionado == valor){
                        $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto.toUpperCase()).attr("selected", "selected"));
                    }else{
                        $(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto.toUpperCase()));
                    }
                    
                }
            }           
        }
    });     
}

function barraCarga(objeto){
    
}

function cargaCambo(tipo,parametro,tsNombreCombo,tnValorPreseleccionado){
	if (_SHOWLOG==true){
		console.log("CARGA COMBO==========");
		console.log("Tipo :" + tipo);
		console.log("Parametro :" + parametro);
		console.log("Nombre Combo :" + tsNombreCombo);
		console.log("Valor preseleccionado :" + tnValorPreseleccionado);
	}
    $.ajax({
        type: "GET",
        async:_ASYNCCOMBO,
        cache:false, 
        url: "../../controller/OrdenServicio/combo-listar.php?tipo="+tipo+"&param="+parametro,        
        error: function (xhr, status, error) {
        },
        success: function (data) {
        	var array = data.split("|");
        	var registros = data.split("|").length;
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));      
            
			for (i=0; i<registros;i++){
				if (array[i]!="" && array[i].length>1){
					var valor = array[i].split(":")[0];
					var texto = array[i].split(":")[1];
					
					if (tnValorPreseleccionado == valor){
						$(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto.toUpperCase()).attr("selected", "selected"));
					}else{
						$(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto.toUpperCase()));
					}
					
				}
			}        	
        }
    });	
}

function cargaComboGrilla(data,value){
	
}

/*
 * Carga un combo con las empresas de transporte para un tramo
 */
function cargaComboEmpresas_OrigenDestino(tsNombreCombo, codDestino){
	var cuenta;
	cuenta = 0;
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/CoordinacionTransporte/comboEmpresas-listar.php?codUbicacion="+_UBICACION+"&codDestino="+codDestino,
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        	var array = data.split("|");
        	var registros = data.split("|").length;
        	console.log(registros);
            $(tsNombreCombo).empty();
            $(tsNombreCombo).append($("<option></option>").attr("value", 0).text("[SELECCIONAR]"));      
            
			for (i=0; i<registros;i++){
				if (array[i]!="" && array[i].length>1){
					var valor = array[i].split(":")[0];
					var texto = array[i].split(":")[1];	
					$(tsNombreCombo).append($("<option></option>").attr("value", valor).text(texto));
					cuenta++;								
				}
			}
				
			if (cuenta==0){
				showMessage("Error","No hay empresas asociadas a este tramo");
			}				
        }
    });		
}

function desformateaFecha(objeto){
    $(objeto).datepicker( "destroy" );
}

function formateaFecha(objeto){
    $(objeto).datepicker({
	      showOn: "button",
	      buttonImage: "img/ico_calendar.png",
	      buttonImageOnly: true,
 		  changeMonth: true,
		  changeYear: true     				    	
    });
    $(objeto).datepicker( "option", "dateFormat", "dd/mm/yy");	
    //$(objeto).datepicker.regional["es"];
}

function formateaFechaHora(objeto){
	jQuery(objeto).datetimepicker({
		format:'d/m/Y H:i',
		//inline:false,
		lang:'es',
		mask: true
	});	
}

function esInteger(e){
	var charCode;
    if (navigator.appName == "Netscape"){
		charCode = e.which;
    }
	else{
		charCode = e.keyCode;
    }
		if (charCode < 48 || charCode > 57){
			switch(charCode) {
				case 0:
					return true;
				case 8:
					return true;
				default:
					return false;				
			}
		}
		else
		{
		return true;
		}
}

function getFecha(){
	var d = new Date();
	//var strDate = d.getFullYear() + "/" + (d.getMonth()+1) + "/" + d.getDate();
	var dia = 	d.getDate()<10?"0"+d.getDate():d.getDate();
	var mes	= 	(d.getMonth()+1) <10?"0"+(d.getMonth()+1):(d.getMonth()+1);
	var strDate = dia +"/"+ mes +"/"+d.getFullYear();
	return strDate;
}

function validaISO9636(auxTexto){	
	var subResultado;	
	subResultado = 0;
	if (auxTexto.length>=10){
		subResultado += getNumeroAsociado(auxTexto[0])*1;
		subResultado += getNumeroAsociado(auxTexto[1])*2;
		subResultado += getNumeroAsociado(auxTexto[2])*4;
		subResultado += getNumeroAsociado(auxTexto[3])*8;
		subResultado += auxTexto[4]*16;
		subResultado += auxTexto[5]*32;
		subResultado += auxTexto[6]*64;
		subResultado += auxTexto[7]*128;
		subResultado += auxTexto[8]*256;
		subResultado += auxTexto[9]*512;
		
  		var amt = parseFloat(subResultado/11);
        var subResultado2 = amt.toFixed(0);
        var digito = subResultado - (subResultado2 * 11);
        if (auxTexto[10]==digito || (digito == -3 && auxTexto[10]==8)){
        	return "OK";
        }else{
        	return "El digito verificador es incorrecto";
        }		
		
	}else{
		return "El texto posee solo " + auxTexto.length + " caracteres";
	}
}

function getNumeroAsociado(caracter){
	switch(caracter){
		case 'A':
			return 10;
			break;
		case 'B':
			return 12;
			break;
		case 'C':
			return 13;
			break;
		case 'D':
			return 14;
			break;
		case 'E':
			return 15;
			break;
		case 'F':
			return 16;
			break;
		case 'G':
			return 17;
			break;
		case 'H':
			return 18;
			break;
		case 'I':
			return 19;
			break;
		case 'J':
			return 20;
			break;
		case 'K':
			return 21;
			break;			
		case 'L':
			return 23;
			break;		
		case 'M':
			return 24;
			break;		
		case 'N':
			return 25;
			break;		
		case 'O':
			return 26;
			break;		
		case 'P':
			return 27;
			break;		
		case 'Q':
			return 28;
			break;		
		case 'R':
			return 29;
			break;		
		case 'S':
			return 30;
			break;		
		case 'T':
			return 31;
			break;		
		case 'U':
			return 32;
			break;		
		case 'V':
			return 34;
			break;		
		case 'W':
			return 35;
			break;		
		case 'X':
			return 36;
			break;		
		case 'Y':
			return 37;
			break;																																																																										
		case 'Z':
			return 38;
			break;		
	}
}
function limpiaComillas(texto){
    var salida = texto.replace("\"","");
    return texto;
}
