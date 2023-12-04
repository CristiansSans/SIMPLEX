<!DOCTYPE HTML>
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	<title>Gestión Logística</title>
	
	<meta name="Designer" content="capturactiva.com">
	<link rel="stylesheet" type="text/css" href="css/reset.css">
	<link rel="stylesheet" type="text/css" href="css/structure.css">

	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/extjs/3.4.1-1/resources/css/ext-all.css" />
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/extjs/3.4.1-1/resources/css/xtheme-gray.css" />

	<script src="//cdnjs.cloudflare.com/ajax/libs/extjs/3.4.1-1/adapter/ext/ext-base.js" type="text/javascript"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/extjs/3.4.1-1/ext-all.js" type="text/javascript"></script>
	
	<script src="../framework/src/locale/ext-lang-es.js" type="text/javascript"></script>

	<script src="js/capturactiva.functions.js" type="text/javascript"></script>
	<script src="js/capturactiva.extend.js" type="text/javascript"></script>
	
</head>
<style>
	/*body{		background:transparent url('images/container.jpg') no-repeat 0 0;	}*/
	body {
		color: #777777;
		font-family: 'Lucida Grande','Lucida Sans Unicode',Arial,Helvetica,sans-serif;
		font-size: 11px;
		height: 100%;
		overflow: hidden;
		width: 100%;
	}	
	
	.msg .x-box-mc {
		font-size:14px;
	}
	#msg-div {
		position:absolute;
		left:35%;
		top:10px;
		width:300px;
		z-index:20000;
	}
	#msg-div .msg {
		border-radius: 8px;
		-moz-border-radius: 8px;
		background: #F6F6F6;
		border: 2px solid #ccc;
		margin-top: 2px;
		padding: 10px 15px;
		color: #555;
	}
	#msg-div .msg h3 {
		margin: 0 0 8px;
		font-weight: bold;
		font-size: 15px;
	}
	#msg-div .msg p {
		margin: 0;
	}
</style>
<body>


<form name="login-form" class="box login" action="javascript:validationLogin();">
	<div style="float:left; padding:15px;">
		<img src="images/logo-116x96.jpg" />
	</div>
	<div style="float:right; padding:0px;">
		<img src="images/container.jpg" />
	</div>
	
	<fieldset class="boxBody">
	  <label>Nombre de usuario</label>
	  <input id="username" type="text" tabindex="1" placeholder="Introduzca su nombre de usuario" required>
	  <label><a href="#" class="rLink" tabindex="5">Olvido su contraseña?</a>Contraseña</label>
	  <input id="password" type="password" tabindex="2" required>
	</fieldset>
	<footer>
	  <input type="submit" class="btnLogin" value="Login" tabindex="4">
	  <label><input type="checkbox" tabindex="3">Recordar la próxima vez</label>
	</footer>
</form>

<footer id="main">
  <a href="http://www.capturactiva.com">Gestión Logística, Copyright © 2012 by Capturactiva</a>
</footer>
</body>
</html>

<script>
	var validationLogin=function(){
		if(Ext.isEmpty(Ext.get('username').dom.value)||Ext.isEmpty(Ext.get('password').dom.value)){
			messageProcess.msg('Autenticacion', 'Algunos datos son obligatorios, favor verifique y re-ingrese');
			return false;
		}

		Ext.Ajax.request({
			url		: 'controller/get-autenticacion.php',
			method	: 'POST',
			params	: {username:Ext.get('username').dom.value, password:Ext.get('password').dom.value},
			success	: function (form, request){
				records=Ext.util.JSON.decode(form.responseText).data;
				if (records.length>0){
					document.forms[0].action = "view/main.php";
					document.forms[0].submit();
					
					messageProcess.msg('Autenticacion', 'Bienvenido');
				}
				else
					messageProcess.msg('Autenticacion', 'Usuario/Contraseña no coinciden, re-ingrese nuevamente...');
			},
			failure : function (form, action) {}
		});				
	}
</script>