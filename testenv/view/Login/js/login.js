/*
 * Autentica las credenciales del usuario
 */
function autenticar(){
	var login  = $("#login-username").val();
	var pass   = $("#login-password").val();
	
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/Login/autenticar.php?login="+login+"&pass="+pass,
        dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
            if (data.autenticado == true){
                window.location=data.url;
            }else{
                alert(data.mensaje);
            }
        }
    });	
}

/*
 * Cierra la sesion de usuario
 */
function cerrarSesion(){
    
    $.ajax({
        type: "GET",
        async:false,
        cache:false, 
        url: "../../controller/Login/cerrarSesion.php",
        dataType: "json",
        error: function (xhr, status, error) {
            // you may need to handle me if the json is invalid
            // this is the ajax object
        },
        success: function (data) {
        }
    }); 
    var url    = "../Login/login.html";
    window.location=url;                
    
    
}

