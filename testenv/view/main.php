<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es-es"class=" js no-flexbox canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths no-ipad no-iphone no-ipod no-appleios positionfixed iospositionfixed no-cssmask xhrupload">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <title>
            Gestion Logistica
	</title>
    </head>
<link href="../css/tipsy.css" rel="stylesheet" type="text/css">
<link href="../css/tipsy-docs.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../../framework/ux/css/lockinggridview.css" />

<link rel="stylesheet" type="text/css" href="../../framework/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../../framework/resources/css/xtheme-gray.css" />

<script src="../../framework/adapter/ext/ext-base.js" type="text/javascript"></script>
<script src="../../framework/ext-all.js" type="text/javascript"></script>
<script src="../../framework/src/locale/ext-lang-es.js" type="text/javascript"></script>

<script src="../js/capturactiva.functions.js" type="text/javascript"></script>
<script src="../js/capturactiva.extend.js" type="text/javascript"></script>
<script src="../../framework/ux/Ext.ux.DateTimeField.js" type="text/javascript"></script>
<script src="../../framework/ux/lockinggridview.js"type="text/javascript"></script>

<!--
<script src="../js/spinner.js" type="text/javascript"></script>
<script src="../js/spinnerfield.js" type="text/javascript"></script>
-->
<script src="../../framework/jquery/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.mousewheel.js" type="text/javascript"></script>

<!--<script src="../js/scrollsync.js" type="text/javascript"></script>-->
<!--<script src="../js/dragscrollable.js" type="text/javascript"></script>-->

<!--<script src="../js/jquery.nicescroll.min.js" type="text/javascript"></script>-->

<script type="text/javascript" src="../js/ux/grid/GridFilters.js"></script>
<script type="text/javascript" src="../js/ux/grid/filter/Filter.js"></script>
<script type="text/javascript" src="../js/ux/grid/filter/StringFilter.js"></script>
<script type="text/javascript" src="../js/ux/grid/filter/DateFilter.js"></script>
<script type="text/javascript" src="../js/ux/grid/filter/ListFilter.js"></script>
<script type="text/javascript" src="../js/ux/grid/filter/NumericFilter.js"></script>
<script type="text/javascript" src="../js/ux/grid/filter/BooleanFilter.js"></script>

<script type="text/javascript" src="../js/ux/menu/EditableItem.js"></script>
<script type="text/javascript" src="../js/ux/menu/RangeMenu.js"></script>
<script type="text/javascript" src="../js/upclick-min.js"></script>

<script src="../js/jquery.tipsy.js" type="text/javascript"></script>

<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>

<!--<script type="text/javascript" src="../js/Ext.ux.ScriptManager.js"></script>-->

<style>
	#main {	
		background: white;
		width: 98.5%;
		padding-left: 10px;
		min-height: 100%;	
	}	
	
	#main.fullscreen {
		background: white;
		float: none;		
		margin-right: 0;		
		border-right: none;	
	}	
	
	div.box {		
		background: white;		
		border: 1px solid #B4B4B4;		
		margin: 0 auto;		
		position: relative!important;		
		width: 99.7%;		
		height: 97%;	
	}		
	
	.shadow {		
		-moz-box-shadow: 0px 0px 4px #ccc;		
		-webkit-box-shadow: 0px 0px 4px #ccc;		
		box-shadow: 0px 0px 4px #ccc;		
	}		

	.corners {		
		-moz-border-radius: 5px;		
		-webkit-border-radius: 5px;		
		border-radius: 5px;	
	}			

	div.box-header {		
		height: 29px;		
		padding: 10px;		
		background: #EEE url(../images/bg-header.png) repeat-x;		
		-moz-border-radius-topleft: 5px;		
		-moz-border-radius-topright: 5px;		
		-webkit-border-top-left-radius: 5px;		
		-webkit-border-top-right-radius: 5px;		
		border-top-left-radius: 5px;		
		border-top-right-radius: 5px;	
	}		

	div.box-header h2 {		
		float: left;		
		margin: 4px 0 0 0px;		
		color: #555;		
		font-size: 18px;		
		text-shadow: 0 1px 1px white;		
		font-family: 'UbuntuBold', Arial, sans-serif;	
	}		

	#main-container {		
		background: -moz-linear-gradient(#FFFFFF 0%, #FFFFFF 300px) 
		repeat scroll 0 0 transparent;		
		border-radius: 5px 5px 5px 5px;		
		border-top: 0px solid #FFFFFF;		
		margin: 0 auto;		
		min-height: 850px;		
		padding-top:0px;		
		width: 100%;		
		font-size:11px;	
	}

	.x-grid3-header{
		background: none repeat scroll 0 0 #EFEFEF;
		border-bottom: 1px solid #CCCCCC;
		font-weight: bold;
		height: 34px;
	}

	.x-grid3-hd-inner {
		padding: 10px 0 0 10px;
		height: 25px;
		font-weight: bold;
	}

	.x-grid3-cell-inner {
		padding: 10px;
	}	

	.x-grid3-row td, .x-grid3-summary-row td{
		vertical-align: middle;
	}	


	article.breadcrumbs {
		float: left;
		padding: 0 10px;
		border: 1px solid #CCC;
	/*	-moz-border-radius: 5px;
		border-radius: 5px;
		-webkit-box-shadow: 0 1px 0 white;*/
		box-shadow: 0 1px 0 white;
		height: 29px;
		margin: 4px 3%;
	}	

	.breadcrumbs a:link, .breadcrumbs a:visited {
		color: #44474F;
		text-decoration: none;
		text-shadow: 0 1px 0 white;
		font-weight: bold;
	}

	breadcrumbs a.current, .breadcrumbs a.current:hover {
		color: #9E9E9E;
		font-weight: bold;
		text-shadow: 0 1px 0 white;
		text-decoration: none;
	}

	.breadcrumbs a {
		display: inline-block;
		float: left;
		height: 30px;
		line-height: 29px;
	}	
	
	.breadcrumb_divider {
		background: url(../images/breadcrumb_divider_end.png) no-repeat scroll 0 0 transparent;
		display: inline-block;
		float: left;
		height: 30px;
		margin: 0 5px;
		width: 15px;
	}

	.breadcrumb_divider_end {
		background: url(../images/breadcrumb_divider_end.png) no-repeat scroll 0 0 transparent;
		display: inline-block;
		float: left;
		height: 30px;
		margin: 0 5px;
		width: 15px;
	}

	.breadcrumbs_container {
		background: url(../images/secondary_bar_shadow.png) no-repeat scroll left top transparent;
		float: left;
		height: 38px;
		width: 77%;
	}

	.eye-fish{
		position:absolute;
		top:5px;
		left:180px;
		width:450px;
		font-size:11px;
	}
	
	div.iconos-header{
		position:relative;
		padding: 0px 2px 2px 2px;
		float:right;
		height:90px;
	}
	
	div.iconos-header a{
		float:right;
		padding: 4px 10px 6px 9px;
		position: relative;
		text-decoration: none;
		width:64px;
		height:64px;
	}
/*
	#iconos-header-mail-WARNING{
		background: url(../images/icon-mail-warning-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-mail-WARNING:hover{
		background: url(../images/icon-mail-warning-on.png) no-repeat scroll 10px center #FFF;
	}
	
	#iconos-header-mail-WRITE{
		background: url(../images/icon-mail-write-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-mail-WRITE:hover{
		background: url(../images/icon-mail-write-on.png) no-repeat scroll 10px center #FFF;
	}
*/
	#iconos-header-profile{
		background: url(../images/icon-profile-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-profile:hover{
		background: url(../images/icon-profile-on.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-map{
		background: url(../images/icon-map-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-map:hover{
		background: url(../images/icon-map-on.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-logout{
		background: url(../images/icon-logout-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-logout:hover{
		background: url(../images/icon-logout-on.png) no-repeat scroll 10px center #FFF;
	}
	
	#iconos-header-home{
		background: url(../images/icon-home-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-home:hover{
		background: url(../images/icon-home-on.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-coordinacion{
		background: url(../images/icon-coordinacion-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-coordinacion:hover{
		background: url(../images/icon-coordinacion-on.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-filter-grid{
		background: url(../images/icon-search-off.png) no-repeat scroll 0px transparent;
	}

	#iconos-filter-grid:hover{
		background: url(../images/icon-search-on.png) no-repeat scroll 0px transparent;
	}

	#iconos-tracking{
		background: url(../images/icon-tracking-off.png) no-repeat scroll 0px transparent;
	}

	#iconos-tracking:hover{
		background: url(../images/icon-tracking-on.png) no-repeat scroll 0px transparent;
	}

	#iconos-invoice{
		background: url(../images/icon-invoice-off.png) no-repeat scroll 0px transparent;
	}

	#iconos-invoice:hover{
		background: url(../images/icon-invoice-on.png) no-repeat scroll 0px transparent;
	}

	#iconos-masters{
		background: url(../images/icon-masters-off.png) no-repeat scroll 0px transparent;
	}

	#iconos-masters:hover{
		background: url(../images/icon-masters-on.png) no-repeat scroll 0px transparent;
	}
	
	#app-root-view {
	  /*background: url("data:image/png;charset=utf-8;base64,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") repeat scroll 0 0 #D8DFE6;*/
	  min-width: 1000px;
	}	

	#std-ui-wrap, #app-root-view {
	  height: 100%;
	  position: relative;
	  z-index: 0;
	}

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

	div.box-header-ctrls {
		width: 36px;
		height: 32px;
		float: left;
		position: relative;
	/*	margin: -2px 0 0 10px;*/
		text-decoration: none;
		cursor:pointer;
	}	

	div.box-header-ctrls a{
		float:left;
	/*	padding: 4px 10px 6px 9px;*/
		position: relative;
		text-decoration: none;
		width:32px;
		height:32px;
	}

	#gkBreadcrumb {
		font-size: 16px;
		margin: 0 0 32px;
	}
	
	#gkBreadcrumb .breadcrumbs {
		float: left;
		podition:absolute;
		top:20px;
		left:30px;
	}
	
	ul {
		list-style: none;
		margin: 0;
		padding: 0;
	}
	
	ul, menu, dir {
		display: block;
	/*	-webkit-margin-before: 1em;*/
	/*	-webkit-margin-after: 1em;*/
		-webkit-margin-start: 0px;
		-webkit-margin-end: 0px;
	/*	-webkit-padding-start: 40px;*/
	}
	
	li {
		display: list-item;
		text-align: -webkit-match-parent;
	}
	
	
	#gkBreadcrumb .breadcrumbs li.pathway {
		padding-right: 20px;
		background: #EBEBEB url(../images/breadcrump.png) no-repeat 100% 100%;
		font-weight: bold;
		color: #212121;
	}
	
	#gkBreadcrumb .breadcrumbs li.separator {
		background: #EBEBEB url(../images/breadcrump.png) no-repeat 100% 0 !important;
		width: 10px;
		padding: 0 !important;
		text-indent: -9999px;
	}
	
	#gkBreadcrumb .breadcrumbs > ul > li {
		float: left;
		border-top: none;
		font-size: 12px;
		line-height: 28px;
		margin-bottom: 5px;
	}
	
	ul li {
		list-style-position: outside;
	}
	
	li {
		display: list-item;
		text-align: -webkit-match-parent;
	}
	
	.logo-empresa{
		height:75px;
		background:transparent url('../images/logo-670x72.png') no-repeat 0 0;
/*		zoom:98%;
		-moz-transform :scale(0.95);
		-webkit-transform: scale(0.9);*/
	}
</style>

<body class="firefox windows">
	<div  class="logo-empresa">
		<div class="iconos-header">
			<a id="iconos-header-logout" href="../" title="Cerrar session"></a>
			<a id="iconos-masters" href="javascript:loadModulo('mantenedores.php');" title="Mantenedores"></a>
		<!--<a id="iconos-header-profile" href="#" title="Perfil de usuario"></a>-->
			<a id="iconos-header-map"  href="javascript:loadModulo('planeacion-rutas.php');" title="Planeacion rutas"></a>
			<a id="iconos-invoice" href="javascript:loadModulo('servicio-facturacion.php');" title="Facturacion"></a>
			<a id="iconos-tracking"  href="javascript:loadModulo('tracking-transporte.php');" title="Tracking"></a>
			<a id="iconos-coordinacion"  href="javascript:loadModulo('programacion-transporte.php');" title="Coordinacion"></a>
			<a id="iconos-header-home" href="javascript:loadModulo('task-list.php');" title="Ir a principal"></a>
		</div>
	</div>
	<div id="main" class="clearfix last fullscreen">
		<div class="box corners shadow">
			<div class="box-header">
				<div class="box-header-ctrls">
					<span alt="" class="spin"></span>
					<a id="iconos-filter-grid" title="Mostrar filtros informacion" href="javascript:void(null);"></a>
				</div>
				<h2 id="title-header">Task List</h2>

			</div>
			<div id="contenido" class="box-content">
				<div id="main-container"></div>
			</div>
		</div>
	</div>
<!--
	<div id="content">
		<div class="box corners shadow">
			<div class="box-header">
				<h2 id="title-header">Task List</h2>
				<div class="box-header-ctrls"><span class="spin" alt=""></span>	
					<a href="javascript:void(null);" title="" class="help"></a>
				</div>
			</div>
						
			<div class="box-content" id="contenido">
				<div id="main-container"></div>
			</div
		</div>	
	</div>
-->	
</body>

<!-- begin olark code -->
<!--
<script data-cfasync="false" type='text/javascript'>/*{literal}<![CDATA[*/
	window.olark||(function(c){var f=window,d=document,l=f.location.protocol=="https:"?"https:":"http:",z=c.name,r="load";var nt=function(){f[z]=function(){(a.s=a.s||[]).push(arguments)};var a=f[z]._={},q=c.methods.length;while(q--){(function(n){f[z][n]=function(){f[z]("call",n,arguments)}})(c.methods[q])}a.l=c.loader;a.i=nt;a.p={0:+new Date};a.P=function(u){a.p[u]=new Date-a.p[0]};function s(){a.P(r);f[z](r)}f.addEventListener?f.addEventListener(r,s,false):f.attachEvent("on"+r,s);var ld=function(){function p(hd){hd="head";return["<",hd,"></",hd,"><",i,' onl' + 'oad="var d=',g,";d.getElementsByTagName('head')[0].",j,"(d.",h,"('script')).",k,"='",l,"//",a.l,"'",'"',"></",i,">"].join("")}var i="body",m=d[i];if(!m){return setTimeout(ld,100)}a.P(1);var j="appendChild",h="createElement",k="src",n=d[h]("div"),v=n[j](d[h](z)),b=d[h]("iframe"),g="document",e="domain",o;n.style.display="none";m.insertBefore(n,m.firstChild).id=z;b.frameBorder="0";b.id=z+"-loader";if(/MSIE[ ]+6/.test(navigator.userAgent)){b.src="javascript:false"}b.allowTransparency="true";v[j](b);try{b.contentWindow[g].open()}catch(w){c[e]=d[e];o="javascript:var d="+g+".open();d.domain='"+d.domain+"';";b[k]=o+"void(0);"}try{var t=b.contentWindow[g];t.write(p());t.close()}catch(x){b[k]=o+'d.write("'+p().replace(/"/g,String.fromCharCode(92)+'"')+'");d.close();'}a.P(2)};ld()};nt()})({loader: "static.olark.com/jsclient/loader0.js",name:"olark",methods:["configure","extend","declare","identify"]});
/* custom configuration goes here (www.olark.com/documentation) */
olark.identify('4403-740-10-4712');/*]]>{/literal}*/</script><noscript><a href="https://www.olark.com/site/4403-740-10-4712/contact" title="Contactenos" target="_blank">Questions? Feedback?</a> powered by <a href="http://www.olark.com?welcome" title="Olark live chat software">Olark live chat software</a></noscript><!-- end olark code -->
-->
</html>
<script type='text/javascript'>

	$(function() {
		$('#iconos-header-home').tipsy({gravity: 'n'});
		$('#iconos-coordinacion').tipsy({gravity: 'n'});
		
		$('#iconos-tracking').tipsy({gravity: 'n'});
		$('#iconos-header-map').tipsy({gravity: 'n'});
		$('#iconos-invoice').tipsy({gravity: 'n'});
		$('#iconos-masters').tipsy({gravity: 'n'});
		$('#iconos-header-logout').tipsy({gravity: 'ne'});
		
		$('#iconos-filter-grid').tipsy({gravity: 'nw'});
	});
	
</script>