var _PERMISOS;
function inicializar() {
    console.log('Iniciando');
    $('body').layout({
        applyDemoStyles : true
    });
    var myLayout = $('body').layout();
    myLayout.sizePane("west", 250);
    

    cargaPerfil();
}

//Carga el menú izquierdo
function cargaPerfil() {
    var auxTexto, codFuncion, nombreFuncion;
    $.ajax({
        type : "GET",
        async : true,
        cache : false,
        url : "../../controller/Login/perfilObtener.php",
        dataType : "json",
        error : function(xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success : function(data) {
            if (data.autenticado == true) {
                var ultimogrupo = 10;
                
                //Llenado del perfil de usuario
                $("#lblNombreUsuario").text(data.nombre + " " + data.apellido);
                $("#lblrol").text(data.rol);

                _PERMISOS = data.permisos;
                //Llenado de menu de acuerdo al perfil seleccionado

                $("#accordionMenuTest").accordion({
                    heightStyle : "content"
                });
                auxTexto = "<li><div>Operaciones</div><ul>";
                $("#accordionMenuTest").append(auxTexto);

                for (var i = 0, j = data.permisos.length; i < j; i++) {
                    var grupo = data.permisos[i].split('|')[0];
                    if (grupo < 20) {
                        grupo = 10;
                    } else {
                        if (grupo < 30) {
                            grupo = 20;
                        } else {
                            if (grupo < 40) {
                                grupo = 30;
                            } else {
                                grupo = 40;
                            }
                        }
                    };

                    if (grupo > ultimogrupo) {
                        switch (grupo){
                            case 20:
                                auxTexto = "</li><li><div>Reportes</div><ul>";
                            break;
                            case 30:
                                auxTexto = "</li><li><div>Mantenedores</div><ul>";
                            break;
                        }  
                        
                        $("#accordionMenuTest").append(auxTexto);
                         ultimogrupo = grupo;
                    };

                    auxTexto = "<li><a href='#' onclick='cargarPantalla(" + data.permisos[i].split('|')[0] + ")'>- " + data.permisos[i].split('|')[1] + "</a></li>";
                    $("#accordionMenuTest").append(auxTexto);
                };

                auxTexto = "</ul></li></ul>";
                $("#accordionMenuTest").append(auxTexto);

            } else {
                alert(data.mensaje);
            }
        }
    });
}

function cargaMenu() {

}

//Carga el combo de mantenedores
function cargaComboMantenedores() {

}

//Carga la grilla con los datos del mantenedor
function cargarPantalla(idMantenedor) {

    for (var i = 0, j = _PERMISOS.length; i < j; i++) {
        if (_PERMISOS[i].split('|')[0] == idMantenedor) {
            showMessageAuxiliar("Inicializando pantalla");
            $('#divOrdenServicio').load(_PERMISOS[i].split('|')[2]);
            $("#lblMantenedor").text(_PERMISOS[i].split('|')[1]);
            $("#lblAyuda").text(_PERMISOS[i].split('|')[1]);

            break;
        }
    };

    /*
     switch(idMantenedor) {
     case(11):
     showMessageAuxiliar("Inicializando modulo de ordenes de servicio");
     $('#divOrdenServicio').load('OrdenServicio.htm');
     $("#lblMantenedor").text("Orden de servicio");
     $("#lblAyuda").text("Orden de servicio");
     break;
     case(12):
     showMessageAuxiliar("Inicializando coordinacion de transporte");
     $('#divOrdenServicio').load('CoordinacionTransporte.htm');
     $("#lblMantenedor").text("Coordinacion de transporte");
     $("#lblAyuda").text("Permite coordinar el transporte");
     //$("#lnkAgregarEmpresa").fadeIn();
     break;
     case(13):
     showMessageAuxiliar("Inicializando programacion de transporte");
     $('#divOrdenServicio').load('ProgramacionTransporte.htm');
     $("#lblMantenedor").text("Programacion de transporte");
     $("#lblAyuda").text("Permite programar el transporte");
     //$("#lnkAgregarCliente").fadeIn();
     break;
     case(14):
     $('#divOrdenServicio').load('Seguimiento.htm');
     $("#lblMantenedor").text("Seguimiento de transporte");
     $("#lblAyuda").text("Seguimiento de transporte");
     break;
     case(15):
     $('#divOrdenServicio').load('inventario.htm');
     $("#lblMantenedor").text("Inventario");
     $("#lblAyuda").text("Inventario");
     break;
     case(31):
     $('#divOrdenServicio').load('../Mantenedores/mantenedor-lugar.htm');
     $("#lblMantenedor").text("Mantenedor de lugares");
     $("#lblAyuda").text("Mantenedor de lugares");
     break;
     case(32):
     $('#divOrdenServicio').load('../Mantenedores/mantenedor-tramos.htm');
     $("#lblMantenedor").text("Mantenedor de tramos");
     $("#lblAyuda").text("Mantenedor de lugares");
     break;
     case(33):
     $('#divOrdenServicio').load('../Mantenedores/mantenedor-empresa.htm');
     $("#lblMantenedor").text("Mantenedor de empresas");
     $("#lblAyuda").text("Mantenedor de empresas");
     break;
     case(34):
     $('#divOrdenServicio').load('../Mantenedores/mantenedor-cliente.htm');
     $("#lblMantenedor").text("Mantenedor de lugares");
     $("#lblAyuda").text("Mantenedor de lugares");
     break;
     case(35):
     $('#divOrdenServicio').load('../Mantenedores/mantenedor-naviera.htm');
     $("#lblMantenedor").text("Mantenedor de lugares");
     $("#lblAyuda").text("Mantenedor de lugares");
     break;
     case(36):
     $('#divOrdenServicio').load('../Mantenedores/mantenedor-usuarios.htm');
     $("#lblMantenedor").text("Mantenedor de lugares");
     $("#lblAyuda").text("Mantenedor de lugares");
     break;
     case(37):
     $('#divOrdenServicio').load('../Mantenedores/disenador-servicios.htm');
     $("#lblMantenedor").text("Dise�ador de servicios");
     $("#lblAyuda").text("Dise�ador de servicios");
     break;
     }
     */
}