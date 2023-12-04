<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es-es"class=" js no-flexbox canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths no-ipad no-iphone no-ipod no-appleios positionfixed iospositionfixed no-cssmask xhrupload">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <title>
            Prototipo        
		</title>
    </head>
<!--[if (!IE)|(gte IE 8)]>
<!-->
<link href="../css/standard_interface-datauri.css" media="all" rel="stylesheet" type="text/css">
<!--<![endif]-->
<!--[if lte IE 7]>
<link href="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/assets/standard_interface.css" media="all" rel="stylesheet" type="text/css" />
<![endif]-->
    <!--[if (!IE)|(gte IE 8)]>
<!-->
<link href="../css/standard_interface_print-datauri.css" media="print" rel="stylesheet" type="text/css">
<!--<![endif]-->
<!--[if lte IE 7]>
<link href="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/assets/standard_interface_print.css" media="print" rel="stylesheet" type="text/css" />
<![endif]-->
<!--<link rel="stylesheet" type="text/css" href="css/admin.css" media="all">
-->
<script src="../js/modernizr.js" type="text/javascript"></script>
<!--[if lt IE 8 ]>
<script src="/javascripts/json2.js">
</script>
<![endif]-->
<link href="../css/intercom.css" rel="stylesheet" type="text/css">
<link href="../css/spinner.css" rel="stylesheet" type="text/css">
<link href="../css/tipsy.css" rel="stylesheet" type="text/css">
<link href="../css/tipsy-docs.css" rel="stylesheet" type="text/css">

<link rel="stylesheet" type="text/css" href="../../framework/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../../framework/resources/css/xtheme-gray.css" />

<script src="../../framework/adapter/ext/ext-base.js" type="text/javascript"></script>
<script src="../../framework/ext-all.js" type="text/javascript"></script>
<script src="../../framework/src/locale/ext-lang-es.js" type="text/javascript"></script>

<script src="../js/capturactiva.functions.js" type="text/javascript"></script>
<script src="../js/capturactiva.extend.js" type="text/javascript"></script>
<script src="../js/spinner.js" type="text/javascript"></script>
<script src="../js/spinnerfield.js" type="text/javascript"></script>

<script src="../../framework/jquery/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.nicescroll.min.js" type="text/javascript"></script>
<script src="../js/jquery.tipsy.js" type="text/javascript"></script>

<!--
<script src="js/slimScroll.js" type="text/javascript"></script>
-->

<!--<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAAU95kDVDU-5Ve389sRBZmMRSDS7actCjtp4xNzNUSW7xICtwjdhQlKWh2kPaIb2ipOUl4vGqcEu0kWw" type="text/javascript">
</script>
-->
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<style>
	#main {		
		background: white;
		/*padding: 17px;		*/
		padding: 17px;		
		width: 97%;		
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
		behavior: url(pie/PIE.htc);	
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
	div.box-header-ctrls {		
	width: 34px;		
	height: 34px;		
	float: right;		
	position: relative;		
	margin: -2px 0 0 0;	
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
	font-size:11px;	}

	.x-grid3-header{
		background: none repeat scroll 0 0 #EFEFEF;
		border-bottom: 1px solid #CCCCCC;
		font-weight: bold;
		height: 34px;
	}

	.x-grid3-hd-inner {
		/*border-right: 1px solid #CCCCCC;*/
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

	.breadcrumbs a.current, .breadcrumbs a.current:hover {
		color: #9E9E9E;
		font-weight: bold;
		text-decoration: none;
		text-shadow: 0 1px 0 #FFFFFF;
	}

	.breadcrumbs a {
		display: inline-block;
		float: left;
		height: 24px;
		line-height: 23px;
	}

	.breadcrumb_divider {
		background: url("../images/breadcrumb_divider.png") no-repeat scroll 0 0 transparent;
		display: inline-block;
		float: left;
		height: 24px;
		margin: 0 5px;
		width: 12px;
	}

	.breadcrumbs_container {
		background: url("../images/secondary_bar_shadow.png") no-repeat scroll left top transparent;
		float: left;
		height: 38px;
		width: 77%;
	}

	article.breadcrumbs {
		border: 1px solid #CCCCCC;
		border-radius: 5px 5px 5px 5px;
		box-shadow: 0 1px 0 #FFFFFF;
		float: left;
		height: 23px;
		margin: 4px 3%;
		padding: 0 10px;
	}
	
	.eye-fish{
		position:absolute;
		top:10px;
		left:150px;
		width:250px;
		font-size:11px;
	}
	
	div.iconos-header{
		position:relative;
		padding: 0px 2px 2px 2px;
		float:right;
		/*width:300px;*/
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

	div.iconos-header a:hover{
/*	
		border: 1px solid #CCCCCC;
		border-radius: 5px 5px 5px 5px;
		color: #222222;
*/		
	}
	
	#iconos-header-home{
		background: url(../images/icon-home-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-home:hover{
		background: url(../images/icon-home-on.png) no-repeat scroll 10px center #FFF;
	}
	
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

	#iconos-header-profile{
		background: url(../images/icon-profile-off.png) no-repeat scroll 10px center #FFF;
	}

	#iconos-header-profile:hover{
		background: url(../images/icon-profile-on.png) no-repeat scroll 10px center #FFF;
	}
</style>

<body class="firefox windows">
	<div  style="height:75px;background:transparent url('../images/logo-838x90.png') no-repeat 0 0;">
		<div class="iconos-header">
			<a id="iconos-header-home" href="#"></a>
			<a id="iconos-header-mail-WARNING" href="#"></a>
			<a id="iconos-header-mail-WRITE" href="#"></a>
			<a id="iconos-header-profile" href="#" title="xxxx"></a>
		</div>
	</div>

<script type='text/javascript'>
	$(function() {
		$('#iconos-header-profile').tipsy({gravity: 'n'});
	});
</script>
	
	<div id="std-ui-wrap" class="production">
		<div class="detail-view-zero-state" id="app-root-view">
			<div class="app-north">
				<div class="app-north-inner">
					<div class="header-flow">
						<div class="flow-topbar left">
							<ul class="align-left">
								<li style="display: block;" class="action li-settings">
									<a title="Perfil" class="settings">
										<span class="icon">
Perfil</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li style="display: block;" class="action li-notifications">
									<a title="Notificaciones" class="notifications">
										<span class="icon">
Notificaciones</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div style="display: block;" class="count-badge">
0</div>
								</li>
							</ul>
							<ul class="align-right">
								<li style="display: block;" class="action li-new_task">
									<a title="Crear nueva tarea" class="new_task">
										<span class="icon">
Nueva tarea</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
							</ul>
						</div>
      						<div class="flow-topbar center">
							<ul class="align-left">
								<li style="display: block;" class="action li-back">
									<a title="Volver tareas anteriores" class="back">
										<span class="text">
Volver atras</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
							</ul>
        							<ul class="align-right">
								<li style="display: block;" class="action li-sorters disabled">
									<a title="Organizar tareas" class="sorters">
										<span class="icon">
Organizar</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li style="display: block;" class="action li-actions">
									<a title="Lista de acciones" class="actions">
										<span class="icon">
Acciones</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li style="display: block;" class="action li-toggle_navbar disabled">
									<a title="Navegacion" class="toggle_navbar alt">
										<span class="icon">
Navegacion</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
							</ul>
							<ul style="display: none;" class="upcoming-view-selector upcoming-selector group visible">
								<li class="action li-day">
									<a title="Day" class="day">
										<span class="text">
Day</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li class="action li-week">
									<a title="Week" class="week">
										<span class="text">
Week</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li class="action li-month selected">
									<a title="Month" class="month">
										<span class="text">
Month</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li class="action li-all">
									<a title="List" class="all">
										<span class="text">
List</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
							</ul>
							<ul style="display: none;" class="upcoming-view-selector upcoming-date-switch group visible">
								<li class="action li-previous">
									<a title="Previous" class="previous">
										<span class="icon">
Previous</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li class="action li-today disabled">
									<a title="Today" class="today">
										<span class="text">
Today</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
								<li class="action li-next">
									<a title="Next" class="next">
										<span class="icon">
Next</span>
										<span class="left">
</span>
										<span class="right">
</span>
									</a>
									<div class="count-badge">
</div>
								</li>
							</ul>
						</div>
      						<div class="flow-topbar right">
							<ul class="align-left">
							  <li class="search">
								<input class="query" placeholder="Busqueda..." type="text">
								<a class="clear-search" title="Busqueda" style="display: none;">
									<ins>
</ins>
								</a>
							  </li>
							</ul>
							<ul class="align-right">
</ul>
						</div>
					</div>
				</div>
			</div>
<!-- Sidebar -->
<div class="app-west">
  <div class="app-west-inner">
<div style="height: 603px;" class="sidebar">
    <div class="sidebar-inner">
      <div class="primary-boxes-wrap">
<div class="sidebar-primary-boxes">
    <h3>
Administracion</h3>
    <ul class="primary-boxes">
      <li class="box dashboard">
        <a>
          <span>
Dashboard</span>
          <b class="dasboard-badge" style="display: block;">
5</b>
        </a>
      </li>
      <li class="box inbox droppable ui-droppable">
        <a href="javascript:void(null);">
          <span>
Inbox</span>
          <b class="badge inbox-badge" style="display: block;">
3</b>
        </a>
      </li>
      <li class="box upcoming">
        <a href="#/upcoming">
          <span>
Calendario</span>
          <b class="badge upcoming-badge" style="display: block;">
10</b>
        </a>
      </li>
      <li class="box flagged">
        <a href="javascript:void(0);">
          <span>
Priorizadas</span>
          <b class="badge flagged-badge" style="display: block;">
4</b>
        </a>
      </li>
      <li class="box delegated">
        <a href="#/delegated">
          <span>
Derivadas</span>
          <b class="badge delegated-badge" style="display: block;">
10</b>
        </a>
      </li>
      <li class="box all-tasks">
        <a href="#/task-list">
          <span>
Task List</span>
          <b class="badge all-tasks-badge" style="">
17</b>
        </a>
      </li>
      <li class="box map">
        <a href="#/rutas">
          <span>
Rutas</span>
        </a>
      </li>
    </ul>
  </div>
</div>
      <div class="panes-wrap">
<div class="panes-wrap-inner">
    <ul class="sidebar-tabs tabs project-tags-collaborators">
      <li class="projects ui-droppable active" data-pane="projects">
Actividades</li>
      <li class="collaborators ui-droppable" data-pane="collaborators">
Contactos</li>
    </ul>
    <div class="main-sidebar-panes sidebar-panes">
      <div class="pane projects active">
<div class="pane-root">
    <div class="filter projects">
      <input placeholder="Busqueda lista…" type="text">
      <a class="clear-search" title="clear search">
<ins>
</ins>
</a>
    </div>
    <div style="overflow: hidden; padding: 0px; height: 378px;" class="pane-inner">
<div style="height: 378px;" class="jspContainer ios">
<div style="left: 0px; top: 0px; width: 220px;" class="jspPane">
      <ul class="project-list items-list flow-tree ui-sortable">
<li data-cid="c5" data-id="133482" class="folder list-item sortable my-folder open">
    <div class="link-wrap ui-droppable">
      <ins>
</ins>
      <div class="link folder-link">
        <span class="view">
Historial</span>
        <form class="rename">
          <input class="name-field" size="10" type="text">
        </form>
        <div class="settings">
<ins>
</ins>
</div>
      </div>
    </div>
    <ul style="display: block;" class="children">
<li data-cid="c6" data-id="429266" class="project list-item sortable my-project ui-droppable">
    <ins>
</ins>
    <a class="project-link link">
      <ins>
</ins>
      <span class="view">
Actividad-1</span>
    </a>
    <div class="settings">
<ins>
</ins>
</div>
    <div class="fadeout">
</div>
  </li>
<li data-cid="c7" data-id="429265" class="project list-item sortable my-project ui-droppable">
    <ins>
</ins>
    <a class="project-link link">
      <ins>
</ins>
      <span class="view">
Actividad-2</span>
    </a>
    <div class="settings">
<ins>
</ins>
</div>
    <div class="fadeout">
</div>
  </li>
<li data-cid="c8" data-id="429264" class="project list-item sortable my-project ui-droppable">
    <ins>
</ins>
    <a class="project-link link">
      <ins>
</ins>
      <span class="view">
Actividad-3</span>
    </a>
    <div class="settings">
<ins>
</ins>
</div>
    <div class="fadeout">
</div>
  </li>
</ul>
  </li>
<li class="folder list-item folder-archived closed empty">
<div class="link-wrap ui-droppable">
<ins>
</ins>
<div class="link folder-link">
<ins>
</ins>
<span>
Archived Lists</span>
</div>
</div>
<ul style="display: none;" class="children">
</ul>
</li>
</ul>
<div style="display: none;" class="no-results">
No lists found.</div>
    </div>
</div>
</div>
  </div>
</div>
      <div class="pane collaborators">
<div class="pane-root">
    <div class="filter people">
      <input placeholder="Search people…" type="text">
      <a class="clear-search" title="clear search">
<ins>
</ins>
</a>
    </div>
    <div style="overflow: hidden; padding: 0px; height: 378px;" class="pane-inner">
<div style="height: 378px;" class="jspContainer ios">
<div style="left: 0px; top: 0px; width: 220px;" class="jspPane">
          <ul class="collaborators collaborator-list items-list flow-tree">
</ul>
<div style="display: none;" class="no-results">
No contacts found.</div>
</div>
</div>
</div>
  <div class="zero">
<div class="zero-msg plus-button">
</div>
</div>
</div>
</div>
    </div>
  </div>
</div>
      <div style="display: none;" class="secondary-boxes-wrap">
<div class="sidebar-secondary-boxes">
    <h3>
Other Lists</h3>
    <div class="pane">
      <ul class="links">
        <li class="link all-tasks">
<a href="#/tasks/all">
<ins>
</ins>
<span>
All Tasks</span>
</a>
</li>
        <li class="link followed-tasks">
<a href="#/following">
<ins>
</ins>
<span>
Followed Tasks</span>
</a>
</li>
        <li class="link unread-tasks">
<a href="#/unread">
<ins>
</ins>
<span>
Unread Tasks</span>
</a>
</li>
        <li class="link completed-tasks">
<a href="#/complete">
<ins>
</ins>
<span>
Completed Tasks</span>
</a>
</li>
      </ul>
    </div>
  </div>
</div>
      <div class="action-bar-wrap">
<div class="side-action-bar">
    <div class="actions">
      <div class="action toggle-lists up">
<a>
<ins class="toggle alt">
</ins>
</a>
</div>
      <div class="action new-action">
<a>
<ins class="add">
</ins>
</a>
</div>
    </div>
    <div class="status">
3 actividades</div>
  </div>
</div>
    </div>
  </div>
</div>
</div>
<!-- Main Content Area -->
<div class="app-center">
  <div class="app-center-inner">
	<div class="detail-view">
		<div class="detail-view-inner">
<!--      <div class="layout-east">
        <div class="layout-east-inner">
          <div class="navbar">
</div>
        </div>
      </div>
-->
<!--      <div class="layout-center" id="main">
        <div class="layout-center-inner" id="main-container">
          <div class="content-views-wrap upcoming-view-wrap">
            <div class="next-unit-drop-zone ui-droppable">
</div>
            <div class="prev-unit-drop-zone ui-droppable">
</div>
        </div>
      </div>
-->
		<div id="main" class="clearfix last fullscreen">
			<div class="box corners shadow">
				<div class="box-header">
					<h2 id="title-header">
Task List</h2>
					<div class="box-header-ctrls">
<span alt="" class="spin">
</span>
							<a class="help" title="" href="javascript:void(null);">
<!-- -->
</a>
					</div>
				</div>
								<div id="contenido" class="box-content">
					<div id="main-container">
</div>
				</div>
			</div>
				</div>
    </div>
  </div>
</div>
</div>
    </div>
    <div id="view-templates" style="display: none !important;">
      <!-- Sidebar -->
<script id="view-template-flow-app-sidebar" type="text/html">
  <div class="sidebar">
    <div class="sidebar-inner">
      <div class="primary-boxes-wrap">
</div>
      <div class="panes-wrap">
</div>
      <div class="secondary-boxes-wrap">
</div>
      <div class="action-bar-wrap">
</div>
    </div>
  </div>
</script>
      <!-- Sidebar - Action Bar -->
<script id="view-template-side-action-bar" type="text/html">
  <div class="side-action-bar">
    <div class="actions">
      <div class="action toggle-lists">
<a>
<ins class="toggle alt">
</ins>
</a>
</div>
      <div class="action new-action">
<a>
<ins class="add">
</ins>
</a>
</div>
    </div>
    <div class="status">
</div>
  </div>
</script>
      <!-- Sidebar - Folder Row -->
<script id="view-template-sidebar-folder-row" type="text/html">
  <li class="folder list-item">
    <div class="link-wrap">
      <ins>
</ins>
      <div class="link folder-link">
        <span class="view">
</span>
        <form class="rename">
          <input class="name-field" type="text" size="10" />
        </form>
        <div class="settings">
<ins>
</ins>
</div>
      </div>
    </div>
    <ul class="children">
</ul>
  </li>
</script>
      <!-- Sidebar - People Pane -->
<script id="view-template-flow-app-sidebar-people-pane" type="text/html">
  <div class="pane-root">
    <div class="filter people">
      <input type="text" placeholder="Search people…" />
      <a class="clear-search" title="clear search">
<ins>
</ins>
</a>
    </div>
    <div class="pane-inner">
      <ul class="collaborators collaborator-list items-list flow-tree">
</ul>
    </div>
  </div>
</script>
      <!-- Sidebar - Person Row -->
<script id="view-template-sidebar-person-row" type="text/html">
  <li class="person list-item">
    <ins>
</ins>
    <div class="person-link link">
      <ins>
</ins>
      <span class="name">
</span>
      <ul class="summaries">
</ul>
    </div>
    <div class="settings">
<ins>
</ins>
</div>
    <div class="fadeout">
</div>
  </li>
</script>
      <!-- Sidebar - Project Row -->
<script id="view-template-sidebar-project-row" type="text/html">
  <li class="project list-item">
    <ins>
</ins>
    <a class="project-link link">
      <ins>
</ins>
      <span class="view">
</span>
    </a>
    <div class="settings">
<ins>
</ins>
</div>
    <div class="fadeout">
</div>
  </li>
</script>
      <!-- Sidebar - Projects Pane -->
<script id="view-template-flow-app-sidebar-projects-pane" type="text/html">
  <div class="pane-root">
    <div class="filter projects">
      <input type="text" placeholder="Search lists…" />
      <a class="clear-search" title="clear search">
<ins>
</ins>
</a>
    </div>
    <div class="pane-inner">
      <ul class="project-list items-list flow-tree">
</ul>
    </div>
  </div>
</script>
      <!-- Sidebar - Tags Pane -->
<script id="view-template-flow-app-sidebar-tags-pane" type="text/html">
  <div class="pane-root">
    <div class="filter tags">
      <input type="text" placeholder="Search tags…" />
      <a class="clear-search" title="clear search">
<ins>
</ins>
</a>
    </div>
    <div class="pane-inner">
        <ul class="tag-list items-list flow-tree">
</ul>
    </div>
  </div>
</script>
      <!-- Sidebar - Panes -->
<script id="view-template-flow-app-sidebar-panes" type="text/html">
  <div class="panes-wrap-inner">
    <ul class="sidebar-tabs tabs project-tags-collaborators">
      <li class="projects active" data-pane="projects">
Lists</li>
      <li class="collaborators" data-pane="collaborators">
Contacts</li>
    </ul>
    <div class="main-sidebar-panes sidebar-panes">
      <div class="pane projects active">
</div>
      <div class="pane collaborators">
</div>
    </div>
  </div>
</script>
      <!-- Sidebar - Primary Boxes -->
<script id="view-template-flow-app-sidebar-primary-boxes" type="text/html">
  <div class="sidebar-primary-boxes">
    <h3>
Focus</h3>
    <ul class="primary-boxes">
      <!-- li class="box dashboard">
        <a>
          <span>
Dashboard</span>
          <b class="dasboard-badge" style="display: none;">
</b>
        </a>
      </li -->
      <li class="box inbox droppable">
        <a href="#/inbox">
          <span>
Inbox</span>
          <b class="badge inbox-badge" style="display: none;">
</b>
        </a>
      </li>
      <li class="box upcoming">
        <a href="#/upcoming">
          <span>
Upcoming</span>
          <b class="badge upcoming-badge" style="display: none;">
</b>
        </a>
      </li>
      <li class="box flagged">
        <a href="#/flagged">
          <span>
Flagged</span>
          <b class="badge flagged-badge" style="display: none;">
</b>
        </a>
      </li>
      <li class="box delegated">
        <a href="#/delegated">
          <span>
Delegated</span>
          <b class="badge delegated-badge" style="display: none;">
</b>
        </a>
      </li>
      <li class="box all-tasks">
        <a href="#/tasks">
          <span>
My Tasks</span>
          <b class="badge all-tasks-badge" style="display: none;">
</b>
        </a>
      </li>
    </ul>
  </div>
script>
      <!-- Sidebar - Secondary Boxes -->
<script id="view-template-sidebar-secondary-boxes" type="text/html">
   <div class="sidebar-secondary-boxes">
    <h3>
Other Lists</h3>
    <div class="pane">
      <ul class="links">
        <li class="link all-tasks">
<a href="#/tasks/all">
<ins>
</ins>
<span>
All Tasks</span>
</a>
</li>
        <li class="link followed-tasks">
<a href="#/following">
<ins>
</ins>
<span>
Followed Tasks</span>
</a>
</li>
        <li class="link unread-tasks">
<a href="#/unread">
<ins>
</ins>
<span>
Unread Tasks</span>
</a>
</li>
        <li class="link completed-tasks">
<a href="#/complete">
<ins>
</ins>
<span>
Completed Tasks</span>
</a>
</li>
      </ul>
    </div>
  </div>
</script>
      <!-- Task Detail -->
<script id="view-template-task-detail" type="text/html">
  <div class="task-detail">
    <div class="task-detail-inner">
      <!-- The "Back" Bar -->
      <div class="layout-north">
        <div class="layout-north-inner">
            <!--            <ul class="tasknav">
              <li class="previous">
<ins>
Previous Task</ins>
</li>
              <li class="page">
                <span class="current">
7</span>
<span class="slash">
/</span>
<span class="total">
10</span>
              </li>
              <li class="next">
<ins>
Next Task</ins>
</li>
            </ul>
            -->
        </div>
      </div>
      <!-- Activities and Details -->
      <div class="layout-center">
        <div class="layout-center-inner">
          <div class="task-body">
            <div class="task-body-inner">
              <div class="task-wrap">
                <div class="task">
                  <h2>
                    <div class="checker">
                      <span>
                        <input type="checkbox" class="cbk-real task-checkbox" style="opacity: 0" />
                      </span>
                    </div>
                    <span class="task-title">
</span>
                  </h2>
                  <ul class="badges">
                    <li class="flag">
</li>
                    <li class="description">
</li>
                  </ul>
                  <ul class="task-actions">
                    <li class="edit first">
<a class="edit" title="Edit">
<ins>
</ins>
</a>
</li>
                    <li class="delete">
<a class="delete" title="Delete">
<ins>
</ins>
</a>
</li>
                    <li class="flag">
<a class="flag" title="Flag">
<ins>
</ins>
</a>
</li>
                    <li class="toggle">
<a class="toggle-description"  title="Toggle Description">
<ins>
</ins>
</a>
</li>
                  </ul>
                                    <div class="task-notes-wrap">
                    <div class="task-notes-wrap-inner">
                      <div class="task-notes formatted">
</div>
                      <ul class="task-tags-list">
</ul>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Details -->
              <div class="task-detail-infobar infobar">
                <div class="task-detail-infobar-inner infobar-inner">
                  <div class="section details">
                    <div class="section-inner details-inner">
                      <h3 class="title">
<span class='fadeout'>
Details</span>
</h3>
                      <div class="content">
                        <ul class="information">
                          <li class="project-name">
<ins>
</ins>
                            In <a class="task-project-name">
[List]</a>
                          </li>
                          <li class="due-date">
<ins>
</ins>
                            Due <span class="task-due-date-value">
[Due Date]</span>
                          </li>
                          <li class="recurrence">
<ins>
</ins>
                            <span class="task-recurrence-value">
Every 1st year on August the 13th</span>
                          </li>
                          <li class="creation-date">
<ins>
</ins>
                            Created <span class="task-creation-date-value">
[Creation Date]</span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div class="section-collaborators-wrap">
</div>
                  <div class="section controls">
                      <a class="collaboration button">
<ins>
</ins>
<span>
</span>
</a>
                  </div>
                </div>
              </div>
              <!-- Activities -->
              <div class="task-updates">
                <h3 class="title">
Recent Activity</h3>
                <div class="task-updates-inner">
                  <div class="concierge-note" style="display: none;">
                    <div class="text">
                      <h4>
Thanks for using Flow Concierge</h4>
                      <p>
We&rsquo;ve received your task and assigned it to one of our agents. They&rsquo;ll be in touch shortly to help out.</p>
                    </div>
                  </div>
                  <div class="activities-container task-activities-container">
</div>
                  <ul class="activities new-comment">
                    <div class="new-comment-container">
</div>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</script>
      <!-- Task Row -->
<script id="view-template-task-row" type="text/html">
  <li class="task">
    <ins class="sortable">
</ins>
    <div class="checker">
      <span>
        <input type="checkbox" class="task-checkbox" tabindex="-1" style="opacity: 0"/>
      </span>
    </div>
    <div class="task-main">
      <a class="project-name" tabindex="-1">
</a>
      <a class="task-account" tabindex="-1">
</a>
      <a class="task-owner" tabindex="-1">
</a>
      <a class="task-body" tabindex="-1">
</a>
      <span class="task-has_description" tabindex="-1">
</span>
      <span class="task-has_attachments" tabindex="-1">
</span>
    </div>
    <div class="overlay">
      <span class="flagged">
</span>
      <span class="comments">
</span>
      <span class="due_date">
&nbsp;</span>
      <ul class="tags">
</ul>
      <span class="overflow_mask">
</span>
    </div>
    <ul class="task-actions">
      <li class="edit first">
<a title="Edit">
<ins>
</ins>
</a>
</li>
      <li class="delete">
<a title="Delete">
<ins>
</ins>
</a>
</li>
      <li class="comment">
<a title="Comment">
<ins>
</ins>
</a>
</li>
      <li class="flag last">
<a title="Flag">
<ins>
</ins>
</a>
</li>
    </ul>
  </li>
</script>
      <!-- Comment Form -->
<script id="view-template-comment-form" type="text/html">
  <li class="activity comment form">
    <!-- Thumbnail -->
    <a class="thumbnail-author">
      <ins>
<span class="photo">
</span>
</ins>
    </a>
    <div class="content">
      <form class="comment-form">
        <div class="comment-textarea-wrap">
          <div class="comment-textarea-div">
            <div class="textarea-icons">
              <abbr class="icon markdown infotip" title="Simple HTML and Markdown formatting is allowed. Click to view the official Markdown guide.">
<a href="http://daringfireball.net/projects/markdown/" target="_blank">
Help</a>
</abbr>
              <a class="icon preview" title="Preview content">
Preview</a>
            </div>
<!-- .textarea-icons -->
            <textarea class="body" placeholder="Leave a comment, attach files, or invite people...">
</textarea>
          </div>
<!-- .comment-textarea-div -->
        </div>
        <div class="fields-wrap">
</div>
        <input type="text" style="border: 0; clip: rect(0 0 0 0); height: 1px; margin: -1px; overflow: hidden; padding: 0; position: absolute; width: 1px;"/>
        <ul class="footer">
          <li class="left leftmost cancel">
            <a class="button cancel">
Cancel</a>
          </li>
          <li class="left leftmost">
            <a class="button subscribe invite">
Invite people</a>
          </li>
          <li class="left">
            <a class="button attach">
Attach files</a>
          </li>
          <li class="left delete">
            <a class="button delete red">
Delete</a>
          </li>
          <li class="right rightmost">
            <a class="button default submit ">
Post</a>
          </li>
          <li class="right keyboard">
            <span>
? ?</span>
          </li>
        </ul>
      </form>
    </div>
    <div class="bottom-of-comment-form">
</div>
  </li>
</script>
<script id="view-template-flow-comment-form" type="text/html">
  <div>
    <ul class="comment-form-attachments-field">
</ul>
    <ul class="comment-form-invite-field">
</ul>
     </div>
</script>
      <!-- Infobar People List -->
<script id="view-template-infobar-people-list" type="text/html">
  <div class="section collaborators">
    <h3 class="title">
<span class='fadeout'>
Teammates</span>
</h3>
    <div class="section-content">
      <ul class="collaborators">
</ul>
      <div class="quick-invite-wrapper">
</div>
    </div>
  </div>
</script>
      <!-- Activities -->
<script id="view-template-activities" type="text/html">
  <div class="activities">
    <ul class="activities-list">
      <li class="spinner s24">
</li>
    </ul>
    <ul class="notifications-list">
</ul>
  </div>
</script>
      <!-- Global Activities -->
<script id="view-template-global-activity" type="text/html">
  <li class="activity">
    <a class="thumbnail-author">
      <ins>
<span class="photo">
</span>
</ins>
    </a>
    <div class="header">
      <span class="author">
</span>
      <span class="date">
</span>
      <span class="source">
</span>
    </div>
    <div class="content">
      <span class="type">
</span>
      <a class="target">
</a>
    </div>
  </li>
</script>
<!-- Task Detail Activities (old) -->
<script id="view-template-task-detail-activity-old" type="text/html">
  <li class="activity">
    <div class="activity-inner">
      <div class="icon">
</div>
      <div class="summary">
</div>
      <div class="content">
</div>
      <div class="meta">
        <div class="date">
</div>
        <div class="source">
</div>
      </div>
    </div>
    <ul class="activities">
</ul>
  </li>
</script>
<!-- Task Detail Activities -->
<script id="view-template-task-detail-activity" type="text/html">
  <li class="activity">
    <a class="activity-photo">
      <ins>
<span class="photo">
</span>
</ins>
    </a>
    <div class="activity-header">
</div>
    <div class="meta">
      <div class="date">
</div>
      <div class="source">
</div>
    </div>
    <div class="activity-actions">
</div>
  </li>
</script>
      <!-- Notification Request -->
<script id="view-template-flow-notification-request" type="text/html">
  <li class="no-highlight">
    <a class="thumbnail-author">
      <ins>
        <span class="photo">
</span>
      </ins>
    </a>
    <div class="header">
      <span class="author">
        <a class="author">
</a>
      </span>
    </div>
    <div class="segmented">
      <a class='button decline'>
        <span class='decline'>
Decline</span>
      </a>
      <a class='button accept'>
        <span class='accept'>
Accept</span>
      </a>
    </div>
    <div class="approve">
Has been added to your contacts</div>
    <ul class="content">
      <li class="read-more">
<a>
Show all lists & tasks…</a>
</li>
    </ul>
  </li>
</script>
      <script id="view-template-project-form" type="text/html">
  <div class="project-form no-left-column task-form">
    <form class="form" autocomplete="off">
      <div class="task-meta">
        <ul class="task-meta-inner">
</ul>
      </div>
      <button class="submit" type="submit" style="position: absolute; opacity: 0;" tabindex="-1">
Save</button>
    </form>
  </div>
</script>
      <!-- Sidebar -->
<script id="view-template-flow-app-settings" type="text/html">
  <div>
    <ul class="tab-row">
      <li class="tab general default">
<ins>
</ins>
General</li>
      <li class="tab info ">
<ins>
</ins>
My Info</li>
      <li class="tab notifications">
<ins>
</ins>
Notifications</li>
      <li class="tab billing">
<ins>
</ins>
Account &amp; Billing </li>
      <li class="tab password">
<ins>
</ins>
Password</li>
      <li class="tab networks">
<ins>
</ins>
Social Networks</li>
      <li class="tab import last">
<ins>
</ins>
Import &amp; Export</li>
    </ul>
        <div class="body">
    <div class="tab-panes">
      <div class="pane general default">
        <div class="pane-inner">
          <div class="section">
            <label class="section-title">
Start Screen</label>
            <fieldset>
              <select class="startup-state-field">
                <option value="last">
Last page</option>
                <option value="activity">
Activity</option>
                <option value="inbox">
Inbox</option>
                <option value="upcoming">
Upcoming</option>
                <option value="flagged">
Flagged</option>
                <option value="delegated">
Delegated</option>
                <option value="all">
My Tasks</option>
              </select>
            </fieldset>
          </div>
          <div class="section">
            <label class="section-title completed-tasks-label">
Completed Tasks</label>
            <fieldset class='checkbox-list'>
              <label>
Clear completed tasks manually</label>
              <ul class="notifications">
                <li>
<input type="checkbox" class="completed-tasks-clear-manually" name="completed-tasks-clear-manually" />
</li>
              </ul>
            </fieldset>
          </div>
                    <div class="section localization">
            <label class="section-title">
Time Zone</label>
            <fieldset>
              <select class="timezone-field">
                <option value="International Date Line West">
(GMT-11:00) International Date Line West</option>
<option value="Midway Island">
(GMT-11:00) Midway Island</option>
<option value="Samoa">
(GMT-11:00) Samoa</option>
<option value="Hawaii">
(GMT-10:00) Hawaii</option>
<option value="Alaska">
(GMT-09:00) Alaska</option>
<option value="Pacific Time (US &amp; Canada)">
(GMT-08:00) Pacific Time (US &amp; Canada)</option>
<option value="Tijuana">
(GMT-08:00) Tijuana</option>
<option value="Arizona">
(GMT-07:00) Arizona</option>
<option value="Chihuahua">
(GMT-07:00) Chihuahua</option>
<option value="Mazatlan">
(GMT-07:00) Mazatlan</option>
<option value="Mountain Time (US &amp; Canada)">
(GMT-07:00) Mountain Time (US &amp; Canada)</option>
<option value="Central America">
(GMT-06:00) Central America</option>
<option value="Central Time (US &amp; Canada)">
(GMT-06:00) Central Time (US &amp; Canada)</option>
<option value="Guadalajara">
(GMT-06:00) Guadalajara</option>
<option value="Mexico City">
(GMT-06:00) Mexico City</option>
<option value="Monterrey">
(GMT-06:00) Monterrey</option>
<option value="Saskatchewan">
(GMT-06:00) Saskatchewan</option>
<option value="Bogota">
(GMT-05:00) Bogota</option>
<option value="Eastern Time (US &amp; Canada)">
(GMT-05:00) Eastern Time (US &amp; Canada)</option>
<option value="Indiana (East)">
(GMT-05:00) Indiana (East)</option>
<option value="Lima">
(GMT-05:00) Lima</option>
<option value="Quito">
(GMT-05:00) Quito</option>
<option value="Caracas">
(GMT-04:30) Caracas</option>
<option value="Atlantic Time (Canada)">
(GMT-04:00) Atlantic Time (Canada)</option>
<option value="Georgetown">
(GMT-04:00) Georgetown</option>
<option value="La Paz">
(GMT-04:00) La Paz</option>
<option value="Santiago">
(GMT-04:00) Santiago</option>
<option value="Newfoundland">
(GMT-03:30) Newfoundland</option>
<option value="Brasilia">
(GMT-03:00) Brasilia</option>
<option value="Buenos Aires">
(GMT-03:00) Buenos Aires</option>
<option value="Greenland">
(GMT-03:00) Greenland</option>
<option value="Mid-Atlantic">
(GMT-02:00) Mid-Atlantic</option>
<option value="Azores">
(GMT-01:00) Azores</option>
<option value="Cape Verde Is.">
(GMT-01:00) Cape Verde Is.</option>
<option value="Casablanca">
(GMT+00:00) Casablanca</option>
<option value="Dublin">
(GMT+00:00) Dublin</option>
<option value="Edinburgh">
(GMT+00:00) Edinburgh</option>
<option value="Lisbon">
(GMT+00:00) Lisbon</option>
<option value="London">
(GMT+00:00) London</option>
<option value="Monrovia">
(GMT+00:00) Monrovia</option>
<option value="UTC">
(GMT+00:00) UTC</option>
<option value="Amsterdam">
(GMT+01:00) Amsterdam</option>
<option value="Belgrade">
(GMT+01:00) Belgrade</option>
<option value="Berlin">
(GMT+01:00) Berlin</option>
<option value="Bern">
(GMT+01:00) Bern</option>
<option value="Bratislava">
(GMT+01:00) Bratislava</option>
<option value="Brussels">
(GMT+01:00) Brussels</option>
<option value="Budapest">
(GMT+01:00) Budapest</option>
<option value="Copenhagen">
(GMT+01:00) Copenhagen</option>
<option value="Ljubljana">
(GMT+01:00) Ljubljana</option>
<option value="Madrid">
(GMT+01:00) Madrid</option>
<option value="Paris">
(GMT+01:00) Paris</option>
<option value="Prague">
(GMT+01:00) Prague</option>
<option value="Rome">
(GMT+01:00) Rome</option>
<option value="Sarajevo">
(GMT+01:00) Sarajevo</option>
<option value="Skopje">
(GMT+01:00) Skopje</option>
<option value="Stockholm">
(GMT+01:00) Stockholm</option>
<option value="Vienna">
(GMT+01:00) Vienna</option>
<option value="Warsaw">
(GMT+01:00) Warsaw</option>
<option value="West Central Africa">
(GMT+01:00) West Central Africa</option>
<option value="Zagreb">
(GMT+01:00) Zagreb</option>
<option value="Athens">
(GMT+02:00) Athens</option>
<option value="Bucharest">
(GMT+02:00) Bucharest</option>
<option value="Cairo">
(GMT+02:00) Cairo</option>
<option value="Harare">
(GMT+02:00) Harare</option>
<option value="Helsinki">
(GMT+02:00) Helsinki</option>
<option value="Istanbul">
(GMT+02:00) Istanbul</option>
<option value="Jerusalem">
(GMT+02:00) Jerusalem</option>
<option value="Kyiv">
(GMT+02:00) Kyiv</option>
<option value="Pretoria">
(GMT+02:00) Pretoria</option>
<option value="Riga">
(GMT+02:00) Riga</option>
<option value="Sofia">
(GMT+02:00) Sofia</option>
<option value="Tallinn">
(GMT+02:00) Tallinn</option>
<option value="Vilnius">
(GMT+02:00) Vilnius</option>
<option value="Baghdad">
(GMT+03:00) Baghdad</option>
<option value="Kuwait">
(GMT+03:00) Kuwait</option>
<option value="Minsk">
(GMT+03:00) Minsk</option>
<option value="Nairobi">
(GMT+03:00) Nairobi</option>
<option value="Riyadh">
(GMT+03:00) Riyadh</option>
<option value="Tehran">
(GMT+03:30) Tehran</option>
<option value="Abu Dhabi">
(GMT+04:00) Abu Dhabi</option>
<option value="Baku">
(GMT+04:00) Baku</option>
<option value="Moscow">
(GMT+04:00) Moscow</option>
<option value="Muscat">
(GMT+04:00) Muscat</option>
<option value="St. Petersburg">
(GMT+04:00) St. Petersburg</option>
<option value="Tbilisi">
(GMT+04:00) Tbilisi</option>
<option value="Volgograd">
(GMT+04:00) Volgograd</option>
<option value="Yerevan">
(GMT+04:00) Yerevan</option>
<option value="Kabul">
(GMT+04:30) Kabul</option>
<option value="Islamabad">
(GMT+05:00) Islamabad</option>
<option value="Karachi">
(GMT+05:00) Karachi</option>
<option value="Tashkent">
(GMT+05:00) Tashkent</option>
<option value="Chennai">
(GMT+05:30) Chennai</option>
<option value="Kolkata">
(GMT+05:30) Kolkata</option>
<option value="Mumbai">
(GMT+05:30) Mumbai</option>
<option value="New Delhi">
(GMT+05:30) New Delhi</option>
<option value="Sri Jayawardenepura">
(GMT+05:30) Sri Jayawardenepura</option>
<option value="Kathmandu">
(GMT+05:45) Kathmandu</option>
<option value="Almaty">
(GMT+06:00) Almaty</option>
<option value="Astana">
(GMT+06:00) Astana</option>
<option value="Dhaka">
(GMT+06:00) Dhaka</option>
<option value="Ekaterinburg">
(GMT+06:00) Ekaterinburg</option>
<option value="Rangoon">
(GMT+06:30) Rangoon</option>
<option value="Bangkok">
(GMT+07:00) Bangkok</option>
<option value="Hanoi">
(GMT+07:00) Hanoi</option>
<option value="Jakarta">
(GMT+07:00) Jakarta</option>
<option value="Novosibirsk">
(GMT+07:00) Novosibirsk</option>
<option value="Beijing">
(GMT+08:00) Beijing</option>
<option value="Chongqing">
(GMT+08:00) Chongqing</option>
<option value="Hong Kong">
(GMT+08:00) Hong Kong</option>
<option value="Krasnoyarsk">
(GMT+08:00) Krasnoyarsk</option>
<option value="Kuala Lumpur">
(GMT+08:00) Kuala Lumpur</option>
<option value="Perth">
(GMT+08:00) Perth</option>
<option value="Singapore">
(GMT+08:00) Singapore</option>
<option value="Taipei">
(GMT+08:00) Taipei</option>
<option value="Ulaan Bataar">
(GMT+08:00) Ulaan Bataar</option>
<option value="Urumqi">
(GMT+08:00) Urumqi</option>
<option value="Irkutsk">
(GMT+09:00) Irkutsk</option>
<option value="Osaka">
(GMT+09:00) Osaka</option>
<option value="Sapporo">
(GMT+09:00) Sapporo</option>
<option value="Seoul">
(GMT+09:00) Seoul</option>
<option value="Tokyo">
(GMT+09:00) Tokyo</option>
<option value="Adelaide">
(GMT+09:30) Adelaide</option>
<option value="Darwin">
(GMT+09:30) Darwin</option>
<option value="Brisbane">
(GMT+10:00) Brisbane</option>
<option value="Canberra">
(GMT+10:00) Canberra</option>
<option value="Guam">
(GMT+10:00) Guam</option>
<option value="Hobart">
(GMT+10:00) Hobart</option>
<option value="Melbourne">
(GMT+10:00) Melbourne</option>
<option value="Port Moresby">
(GMT+10:00) Port Moresby</option>
<option value="Sydney">
(GMT+10:00) Sydney</option>
<option value="Yakutsk">
(GMT+10:00) Yakutsk</option>
<option value="New Caledonia">
(GMT+11:00) New Caledonia</option>
<option value="Vladivostok">
(GMT+11:00) Vladivostok</option>
<option value="Auckland">
(GMT+12:00) Auckland</option>
<option value="Fiji">
(GMT+12:00) Fiji</option>
<option value="Kamchatka">
(GMT+12:00) Kamchatka</option>
<option value="Magadan">
(GMT+12:00) Magadan</option>
<option value="Marshall Is.">
(GMT+12:00) Marshall Is.</option>
<option value="Solomon Is.">
(GMT+12:00) Solomon Is.</option>
<option value="Wellington">
(GMT+12:00) Wellington</option>
<option value="Nuku'alofa">
(GMT+13:00) Nuku'alofa</option>
              </select>
            </fieldset>
                        <label class="section-title">
Locale</label>
            <fieldset>
              <select class="locale-field">
                <option value="en-CA">
en-CA</option>
                <option value="en-US">
en-US</option>
                <option value="en-GB">
en-GB</option>
                <option value="fr-FR">
fr-FR</option>
                <option value="de-DE">
de-DE</option>
                <option value="ja-JP">
ja-JP</option>
              </select>
            </fieldset>
                  <label class="section-title">
Start of Week</label>
            <fieldset>
              <select class="start-of-week-field">
                <option value="-1">
Locale Default</option>
                <option value="0">
Sunday</option>
                <option value="1">
Monday</option>
                <option value="2">
Tuesday</option>
                <option value="3">
Wednesday</option>
                <option value="4">
Thursday</option>
                <option value="5">
Friday</option>
                <option value="6">
Saturday</option>
              </select>
            </fieldset>
          </div>
<!-- .section -->
                    <div class="section fluid-badge-options" style="display:none">
            <label class="section-title">
Fluid Badge Count</label>
            <fieldset>
              <ul class="inputs">
                <li>
                  <select class="fluid-badge-count">
                    <option value="unread">
Unread Notifications</option>
                    <option value="inbox">
Inbox</option>
                    <option value="upcoming">
Upcoming</option>
                    <option value="flagged">
Flagged</option>
                    <option value="none">
No Badge</option>
                  </select>
                </li>
              </ul>
            </fieldset>
          </div>
<!-- .section -->
                  </div>
      </div>
<!-- .pane.general -->
            <div class="pane info">
</div>
<!-- .pane.info -->
            <div class="pane notifications">
        <div class="pane-inner">
          <form class="notification-settings-form">
            <div class="section digest">
              <label class="section-title">
Daily Digest</label>
              <fieldset>
                  <p>
See your upcoming tasks and catch up on recent activity right from your email inbox.</p>
                   <select class="digest-period">
                  <option value="never">
Never</option>
                  <option value="daily">
Send every day</option>
                  <option value="weekdays">
Send every weekday</option>
                </select>
                                <select class="digest-time">
                  <option value="5">
at 5:00 AM</option>
                  <option value="6">
at 6:00 AM</option>
                  <option value="7">
at 7:00 AM</option>
                  <option value="8">
at 8:00 AM</option>
                  <option value="9">
at 9:00 AM</option>
                  <option value="10">
at 10:00 AM</option>
                  <option value="11">
at 11:00 AM</option>
                  <option value="12">
at 12:00 PM</option>
                </select>
              </fieldset>
            </div>
                        <div class="section email-notifications">
              <label class="section-title">
Email Notifications</label>
              <fieldset>
                <label>
Assigns you a task</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[task_assign_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Invites you to a task</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[task_invite_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Comments on or attaches files to a task</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[task_comment_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Completes, reopens, or deletes a task</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[task_state_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Changes a task&rsquo;s details or followers</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[task_edit_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Invites you to a list</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[project_invite_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Changes a list&rsquo;s details or members</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[project_edit_email]" />
</li>
                </ul>
              </fieldset>
              <fieldset>
                <label>
Archives, reopens, or deletes a list</label>
                <ul class="notifications">
                  <li>
<input type="checkbox" class="email" name="notifications[project_state_email]" />
</li>
                </ul>
              </fieldset>
            </div>
                        <div class="section app-notifications">
              <label class="section-title">
App Notifications</label>
              <fieldset>
                <label>
All task and list activity</label>
                <ul class="notifications">
                  <li>
<input class="in-app-notifications" type="checkbox" name="in_app_notifications" />
</li>
                </ul>
              </fieldset>
            </div>
          </form>
        </div>
      </div>
<!-- .pane.notifications -->
            <div class="pane billing">
</div>
<!-- .pane.billing -->
            <div class="pane password">
        <div class="pane-inner">
          <div class="section">
            <label class="section-title password-label-old">
Old Password</label>
            <fieldset>
              <input class="password-field-old text" autocomplete="off" type="password" />
            </fieldset>
            <label class="section-title password-label-new">
New Password</label>
            <fieldset>
              <input class="password-field-new text" autocomplete="off" type="password" />
            </fieldset>
            <label class="section-title password-label-confirm">
Confirm</label>
            <fieldset>
              <input class="password-field-confirm text" autocomplete="off" type="password" />
            </fieldset>
            <fieldset>
              <p>
<a class="submit-password-change button">
Change Password</a>
</p>
              <p class="message password-change">
</p>
            </fieldset>
          </div>
<!-- .section -->
        </div>
      </div>
<!-- .pane -->
            <div class="pane networks">
        <div class="pane-inner">
          <div class="section">
            <p class="intro">
Quickly invite your friends, family, and colleagues to Flow by adding your social networks.</p>
          </div>
<!-- .section -->
          <div class="section network">
            <ul class="connect-to-networks">
              <li class="facebook">
                <span class="logo">
</span>
                Connect to Facebook                <div class="toggle">
                  <input type="checkbox" name="connect-to-network" class="cbk facebook" value="facebook">
                </div>
              </li>
              <li class="google">
                <span class="logo">
</span>
                Connect to Google                <div class="toggle">
                  <input type="checkbox" name="connect-to-network" class="cbk google" value="google">
                </div>
              </li>
              <li  class="twitter">
                <span class="logo">
</span>
                Connect to Twitter                <div class="toggle">
                  <input type="checkbox" name="connect-to-network" class="cbk twitter" value="twitter">
                </div>
              </li>
            </ul>
            <div class="spinner s24">
</div>
          </div>
<!-- .section -->
          <div class="section">
            <fieldset>
              <p>
<a class="add-contacts-button button">
Add Contacts</a>
</p>
            </fieldset>
          </div>
<!-- .section -->
        </div>
<!-- .pane-inner -->
      </div>
<!-- .pane -->
            <div class="pane localization">
        <div class="pane-inner">
          <div class="section localization">
            <label class="section-title">
Timezone</label>
            <fieldset>
              <select class="timezone-field">
                <option value="International Date Line West">
(GMT-11:00) International Date Line West</option>
<option value="Midway Island">
(GMT-11:00) Midway Island</option>
<option value="Samoa">
(GMT-11:00) Samoa</option>
<option value="Hawaii">
(GMT-10:00) Hawaii</option>
<option value="Alaska">
(GMT-09:00) Alaska</option>
<option value="Pacific Time (US &amp; Canada)">
(GMT-08:00) Pacific Time (US &amp; Canada)</option>
<option value="Tijuana">
(GMT-08:00) Tijuana</option>
<option value="Arizona">
(GMT-07:00) Arizona</option>
<option value="Chihuahua">
(GMT-07:00) Chihuahua</option>
<option value="Mazatlan">
(GMT-07:00) Mazatlan</option>
<option value="Mountain Time (US &amp; Canada)">
(GMT-07:00) Mountain Time (US &amp; Canada)</option>
<option value="Central America">
(GMT-06:00) Central America</option>
<option value="Central Time (US &amp; Canada)">
(GMT-06:00) Central Time (US &amp; Canada)</option>
<option value="Guadalajara">
(GMT-06:00) Guadalajara</option>
<option value="Mexico City">
(GMT-06:00) Mexico City</option>
<option value="Monterrey">
(GMT-06:00) Monterrey</option>
<option value="Saskatchewan">
(GMT-06:00) Saskatchewan</option>
<option value="Bogota">
(GMT-05:00) Bogota</option>
<option value="Eastern Time (US &amp; Canada)">
(GMT-05:00) Eastern Time (US &amp; Canada)</option>
<option value="Indiana (East)">
(GMT-05:00) Indiana (East)</option>
<option value="Lima">
(GMT-05:00) Lima</option>
<option value="Quito">
(GMT-05:00) Quito</option>
<option value="Caracas">
(GMT-04:30) Caracas</option>
<option value="Atlantic Time (Canada)">
(GMT-04:00) Atlantic Time (Canada)</option>
<option value="Georgetown">
(GMT-04:00) Georgetown</option>
<option value="La Paz">
(GMT-04:00) La Paz</option>
<option value="Santiago">
(GMT-04:00) Santiago</option>
<option value="Newfoundland">
(GMT-03:30) Newfoundland</option>
<option value="Brasilia">
(GMT-03:00) Brasilia</option>
<option value="Buenos Aires">
(GMT-03:00) Buenos Aires</option>
<option value="Greenland">
(GMT-03:00) Greenland</option>
<option value="Mid-Atlantic">
(GMT-02:00) Mid-Atlantic</option>
<option value="Azores">
(GMT-01:00) Azores</option>
<option value="Cape Verde Is.">
(GMT-01:00) Cape Verde Is.</option>
<option value="Casablanca">
(GMT+00:00) Casablanca</option>
<option value="Dublin">
(GMT+00:00) Dublin</option>
<option value="Edinburgh">
(GMT+00:00) Edinburgh</option>
<option value="Lisbon">
(GMT+00:00) Lisbon</option>
<option value="London">
(GMT+00:00) London</option>
<option value="Monrovia">
(GMT+00:00) Monrovia</option>
<option value="UTC">
(GMT+00:00) UTC</option>
<option value="Amsterdam">
(GMT+01:00) Amsterdam</option>
<option value="Belgrade">
(GMT+01:00) Belgrade</option>
<option value="Berlin">
(GMT+01:00) Berlin</option>
<option value="Bern">
(GMT+01:00) Bern</option>
<option value="Bratislava">
(GMT+01:00) Bratislava</option>
<option value="Brussels">
(GMT+01:00) Brussels</option>
<option value="Budapest">
(GMT+01:00) Budapest</option>
<option value="Copenhagen">
(GMT+01:00) Copenhagen</option>
<option value="Ljubljana">
(GMT+01:00) Ljubljana</option>
<option value="Madrid">
(GMT+01:00) Madrid</option>
<option value="Paris">
(GMT+01:00) Paris</option>
<option value="Prague">
(GMT+01:00) Prague</option>
<option value="Rome">
(GMT+01:00) Rome</option>
<option value="Sarajevo">
(GMT+01:00) Sarajevo</option>
<option value="Skopje">
(GMT+01:00) Skopje</option>
<option value="Stockholm">
(GMT+01:00) Stockholm</option>
<option value="Vienna">
(GMT+01:00) Vienna</option>
<option value="Warsaw">
(GMT+01:00) Warsaw</option>
<option value="West Central Africa">
(GMT+01:00) West Central Africa</option>
<option value="Zagreb">
(GMT+01:00) Zagreb</option>
<option value="Athens">
(GMT+02:00) Athens</option>
<option value="Bucharest">
(GMT+02:00) Bucharest</option>
<option value="Cairo">
(GMT+02:00) Cairo</option>
<option value="Harare">
(GMT+02:00) Harare</option>
<option value="Helsinki">
(GMT+02:00) Helsinki</option>
<option value="Istanbul">
(GMT+02:00) Istanbul</option>
<option value="Jerusalem">
(GMT+02:00) Jerusalem</option>
<option value="Kyiv">
(GMT+02:00) Kyiv</option>
<option value="Pretoria">
(GMT+02:00) Pretoria</option>
<option value="Riga">
(GMT+02:00) Riga</option>
<option value="Sofia">
(GMT+02:00) Sofia</option>
<option value="Tallinn">
(GMT+02:00) Tallinn</option>
<option value="Vilnius">
(GMT+02:00) Vilnius</option>
<option value="Baghdad">
(GMT+03:00) Baghdad</option>
<option value="Kuwait">
(GMT+03:00) Kuwait</option>
<option value="Minsk">
(GMT+03:00) Minsk</option>
<option value="Nairobi">
(GMT+03:00) Nairobi</option>
<option value="Riyadh">
(GMT+03:00) Riyadh</option>
<option value="Tehran">
(GMT+03:30) Tehran</option>
<option value="Abu Dhabi">
(GMT+04:00) Abu Dhabi</option>
<option value="Baku">
(GMT+04:00) Baku</option>
<option value="Moscow">
(GMT+04:00) Moscow</option>
<option value="Muscat">
(GMT+04:00) Muscat</option>
<option value="St. Petersburg">
(GMT+04:00) St. Petersburg</option>
<option value="Tbilisi">
(GMT+04:00) Tbilisi</option>
<option value="Volgograd">
(GMT+04:00) Volgograd</option>
<option value="Yerevan">
(GMT+04:00) Yerevan</option>
<option value="Kabul">
(GMT+04:30) Kabul</option>
<option value="Islamabad">
(GMT+05:00) Islamabad</option>
<option value="Karachi">
(GMT+05:00) Karachi</option>
<option value="Tashkent">
(GMT+05:00) Tashkent</option>
<option value="Chennai">
(GMT+05:30) Chennai</option>
<option value="Kolkata">
(GMT+05:30) Kolkata</option>
<option value="Mumbai">
(GMT+05:30) Mumbai</option>
<option value="New Delhi">
(GMT+05:30) New Delhi</option>
<option value="Sri Jayawardenepura">
(GMT+05:30) Sri Jayawardenepura</option>
<option value="Kathmandu">
(GMT+05:45) Kathmandu</option>
<option value="Almaty">
(GMT+06:00) Almaty</option>
<option value="Astana">
(GMT+06:00) Astana</option>
<option value="Dhaka">
(GMT+06:00) Dhaka</option>
<option value="Ekaterinburg">
(GMT+06:00) Ekaterinburg</option>
<option value="Rangoon">
(GMT+06:30) Rangoon</option>
<option value="Bangkok">
(GMT+07:00) Bangkok</option>
<option value="Hanoi">
(GMT+07:00) Hanoi</option>
<option value="Jakarta">
(GMT+07:00) Jakarta</option>
<option value="Novosibirsk">
(GMT+07:00) Novosibirsk</option>
<option value="Beijing">
(GMT+08:00) Beijing</option>
<option value="Chongqing">
(GMT+08:00) Chongqing</option>
<option value="Hong Kong">
(GMT+08:00) Hong Kong</option>
<option value="Krasnoyarsk">
(GMT+08:00) Krasnoyarsk</option>
<option value="Kuala Lumpur">
(GMT+08:00) Kuala Lumpur</option>
<option value="Perth">
(GMT+08:00) Perth</option>
<option value="Singapore">
(GMT+08:00) Singapore</option>
<option value="Taipei">
(GMT+08:00) Taipei</option>
<option value="Ulaan Bataar">
(GMT+08:00) Ulaan Bataar</option>
<option value="Urumqi">
(GMT+08:00) Urumqi</option>
<option value="Irkutsk">
(GMT+09:00) Irkutsk</option>
<option value="Osaka">
(GMT+09:00) Osaka</option>
<option value="Sapporo">
(GMT+09:00) Sapporo</option>
<option value="Seoul">
(GMT+09:00) Seoul</option>
<option value="Tokyo">
(GMT+09:00) Tokyo</option>
<option value="Adelaide">
(GMT+09:30) Adelaide</option>
<option value="Darwin">
(GMT+09:30) Darwin</option>
<option value="Brisbane">
(GMT+10:00) Brisbane</option>
<option value="Canberra">
(GMT+10:00) Canberra</option>
<option value="Guam">
(GMT+10:00) Guam</option>
<option value="Hobart">
(GMT+10:00) Hobart</option>
<option value="Melbourne">
(GMT+10:00) Melbourne</option>
<option value="Port Moresby">
(GMT+10:00) Port Moresby</option>
<option value="Sydney">
(GMT+10:00) Sydney</option>
<option value="Yakutsk">
(GMT+10:00) Yakutsk</option>
<option value="New Caledonia">
(GMT+11:00) New Caledonia</option>
<option value="Vladivostok">
(GMT+11:00) Vladivostok</option>
<option value="Auckland">
(GMT+12:00) Auckland</option>
<option value="Fiji">
(GMT+12:00) Fiji</option>
<option value="Kamchatka">
(GMT+12:00) Kamchatka</option>
<option value="Magadan">
(GMT+12:00) Magadan</option>
<option value="Marshall Is.">
(GMT+12:00) Marshall Is.</option>
<option value="Solomon Is.">
(GMT+12:00) Solomon Is.</option>
<option value="Wellington">
(GMT+12:00) Wellington</option>
<option value="Nuku'alofa">
(GMT+13:00) Nuku'alofa</option>
              </select>
            </fieldset>
            <label class="section-title">
Locale</label>
            <fieldset>
              <select class="locale-field">
                <option value="en-CA">
en-CA</option>
                <option value="en-US">
en-US</option>
                <option value="en-GB">
en-GB</option>
                <option value="fr-FR">
fr-FR</option>
                <option value="de-DE">
de-DE</option>
                <option value="ja-JP">
ja-JP</option>
              </select>
            </fieldset>
                  <label class="section-title">
Start of Week</label>
            <fieldset>
              <select class="start-of-week-field">
                <option value="-1">
Locale Default</option>
                <option value="0">
Sunday</option>
                <option value="1">
Monday</option>
                <option value="2">
Tuesday</option>
                <option value="3">
Wednesday</option>
                <option value="4">
Thursday</option>
                <option value="5">
Friday</option>
                <option value="6">
Saturday</option>
              </select>
            </fieldset>
          </div>
<!-- .section -->
        </div>
<!-- .pane-inner -->
      </div>
<!-- .pane -->
      <div class="pane import">
</div>
<!-- .pane.import -->
    </div>
<!-- .tab-panes -->
    </div>
<!-- .body -->
    <div class="clear">
</div>
  </div>
</script>
      <!-- Help -->
<script id="view-template-flow-beta-invite-form" type="text/html">
  <div class="invite-modal">
    <div class="invite-form">
      <h2>
Invite People to Flow</h2>
      <div class="invite-form-zero">
</div>
      <div class="invite-form-wrap">
</div>
    </div>
    <div class="already-invited">
      <h2>
Sent Invites</h2>
      <ul class="ul-sent-invites">
</ul>
    </div>
  </div>
</script>
      <!-- Detail View -->
<script id="view-template-detail-view" type="text/html">
  <div class="detail-view">
    <div class="detail-view-inner">
      <div class="layout-east">
        <div class="layout-east-inner">
          <div class="navbar">
</div>
        </div>
      </div>
      <div class="layout-center">
        <div class="layout-center-inner">
          <div class="content-views-wrap">
</div>
        </div>
      </div>
    </div>
  </div>
</script>
      <!-- Lists -->
<script id="view-template-detail-view-zero-state" type="text/html">
  <div class="zero-states">
    <div class="zero-state">
      <ins>
</ins>
      <div class="text">
        <h4 class="title">
</h4>
        <div class="description">
</div>
      </div>
    </div>
  </div>
</script>
      <!-- Lists -->
<script id="view-template-upcoming-view-zero-state" type="text/html">
  <div class="content-list upcoming-zero-state">
    <h3 class="list-header">
      <span class="count">
0</span>
      <a class="list-title">
</a>
    </h3>
  </div>
</script>
      <!-- Upcoming View -->
<script id="view-template-upcoming-view" type="text/html">
  <div class="detail-view">
    <div class="detail-view-inner">
      <div class="layout-east">
        <div class="layout-east-inner">
          <div class="navbar">
</div>
        </div>
      </div>
      <div class="layout-center">
        <div class="layout-center-inner">
          <div class="content-views-wrap upcoming-view-wrap">
            <div class="next-unit-drop-zone ui-droppable">
</div>
            <div class="prev-unit-drop-zone ui-droppable">
</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</script>
      <!-- Welcome Page -->
<script id="view-template-flow-welcome-state" type="text/html">
  <div class="fancy-indicators">
</div>
  <div class="project-form no-left-column">
    <div class="section no-label no-padding">
      <ul class="sheets">
        <li class="sheet active">
        </li>
      </ul>
    </div>
  </div>
  <div class="navigation-bar">
    <a class="button back">
      <span>
Back</span>
    </a>
    <a class="button default started" style='display: none;'>
      <span>
Quick Guide</span>
    </a>
    <a class="button default next">
      <span>
Next</span>
    </a>
  </div>
</script>
<script id="view-template-flow-welcome-state-start" type="text/html">
  <div class="sheet-content welcome-1" style="display: block;">
    <div class="wrapper">
      <div class="wrapper-text">
        <strong>
Personalize your Flow account!</strong>
<br />
        Upload a photo of yourself.      </div>
      <fieldset class="flow_frame">
        <div class="inner-frame">
          <div class="image">
</div>
          <div class="loading">
</div>
        </div>
      </fieldset>
      <div class="upload-photo-wrap">
</div>
    </div>
  </div>
  </script>
<script id="view-template-flow-welcome-state-connect" type="text/html">
  <div class="sheet-content welcome-2" style="display: block;">
    <div class="wrapper">
      <div class="wrapper-text">
<strong>
Let's Invite Your Team</strong>
<br />
Invite your co-workers, friends and family, but don't worry, they'll only be able to see tasks that you choose to share with them.      </div>
      <div class="contact-form">
</div>
    </div>
  </div>
</script>
<script id="view-template-flow-welcome-state-done" type="text/html">
  <div class="sheet-content welcome-3" style="display: block;">
     <div class="wrapper">
      <div class="wrapper-text">
        <strong>
Alright, we're ready to get started!</strong>
        <br>
Let's kick things off by adding your first task. Click the blue button when you're ready to go.      </div>
      <div class="welcome-task-form">
</div>
    </div>
    </div>
  </script>
      <!-- Quick Guide -->
<script id="view-template-flow-quick-guide-first" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
This Quick Guide will get you familiar with some of Flow's features. You can access it anytime from your Flow preferences.</p>
        <img alt="Quickguide_01" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_01.png" width="222" />
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-third" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Just tap the ENTER key or the New Task button at any time to start creating, delegating, and organizing your tasks.</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Creating Lists</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_02" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_02.png" width="222" />
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-fourth" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Task pages are where you can add comments, attach files, delegate tasks, and invite others to collaborate.</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Task Pages</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_03" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_03.png" width="222" />
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-fifth" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Create a new list by hitting the + button, then fill it with tasks and invite people so they'll be notified anytime there's an update.</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Activity Feed</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_04" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_04.png" width="222" />
      </div>
    </div>
  </div>
  </script>
<script id="view-template-flow-quick-guide-sixth" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Check out your Activity Feed to get up-to-speed on all the progress your collaborators have made while you were out.</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Contacts</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_05" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_05.png" width="222" />
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-seventh" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Click on any of your collaborators in the Contacts tab to see shared tasks and lists and other important information.</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Email from Anywhere</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_06" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_06.png" width="222" />
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-eighth" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Use Flow's free iPhone app or Mobile View to follow and comment on tasks from any mobile device. <a href="http://www.getflow.com/iphone/download" class="download">
Download the app now.</a>
</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Mac &amp; iPhone</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_07" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_07.png" width="222" />
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-ninth" type="text/html">
  <div>
    <div class="wrapper">
      <div class="wrapper-text quick-guide">
        <p>
Use our companion Mac app to receive notifications and create new tasks directly from your desktop. <a href="http://www.getflow.com/mac/download" class="download">
Download the app now.</a>
</p>
        <a class="button not-on-modal  advance-slide">
Next: <em>
Any Questions?</em>
<ins>
</ins>
</a>
        <img alt="Quickguide_08" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_08.png" width="222" />
              </div>
    </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-tenth" type="text/html">
  <div>
  <div class="wrapper">
    <div class="wrapper-text quick-guide">
      <p>
Email new tasks to <a href="mailto:tasks@getflow.com">
tasks@getflow.com</a>
 and let us handle the rest. You can even leave notes and delegate to any of your contacts.</p>
      <img alt="Quickguide_09" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_09.png" width="222" />
    </div>
  </div>
  </div>
</script>
<script id="view-template-flow-quick-guide-eleven" type="text/html">
  <div>
  <div class="wrapper">
    <div class="wrapper-text quick-guide">
      <p>
Need help? Just click "Get Help&hellip;" in the Flow Menu and someone from the Flow Team will be happy to lend a hand.</p>
      <a class="button default create-a-task not-on-modal ">
Create your first task</a>
      <img alt="Quickguide_10" height="139" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/welcome/quickguide_10.png" width="222" />
     </div>
  </div>
  </div>
</script>
      <!-- HTML Modal -->
<script id="view-template-flow-html-modal" type="text/html">
  <div class="html-modal">
    <div class="html-modal-content">
</div>
  </div>
</script>
      <!-- Email Integration Help -->
<script id="view-template-flow-email-integration" type="text/html">
  <div class="sheet formatted">
    <h2>
Creating Tasks with Email</h2>
    <p>
Flow lets you quickly create a task by sending an email to <a href="mailto:tasks@getflow.com">
tasks@getflow.com</a>
. The email subject is used to title, file, schedule, delegate, tag, and invite people to the task; the email body becomes the task's description. By default, tasks you email will be added to your inbox.</p>
    <p>
<img alt="Email-advanced" height="172" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/graphics/email-advanced.png" width="635" />
</p>
    <p class="note">
<em>
Flow will accept messages from both the email address you use to log in and the alternate address you may optionally set in the My Info tab of your preferences.</em>
</p>
  </div>
  <div class="sheet formatted">
    <h2>
Add Tasks to Lists</h2>
    <p>
File tasks in lists using <q>
[ ]</q>
 or <q>
list:</q>
</p>
    <blockquote>
      <p>
[Ship Repairs] Repair the class 1.0 hyperdrive motivator</p>
    </blockquote>
  </div>
  <div class="sheet formatted">
     <h2>
Delegating Tasks to Others</h2>
    <p>
Delegate tasks to people using <q>
@</q>
 or <q>
delegate:</q>
</p>
    <blockquote>
      <p>
@Chewbacca Repair the class 1.0 hyperdrive motivator</p>
    </blockquote>
  </div>
    <div class="sheet formatted">
       <h2>
Setting Due Dates</h2>
    <p>
Schedule tasks using <q>
!</q>
 or <q>
due:</q>
</p>
    <blockquote>
      <p>
!tuesday Repair the class 1.0 hyperdrive motivator</p>
    </blockquote>
    <p>
You can also use <q>
!!</q>
 to quickly schedule tasks today.</p>
  </div>
  <div class="sheet formatted">
       <h2>
Tagging Tasks</h2>
    <p>
Tag tasks with <q>
#</q>
 or <q>
tag:</q>
</p>
    <blockquote>
      <p>
Repair the class 1.0 hyperdrive motivator #falcon #repair</p>
    </blockquote>
  </div>
  <div class="sheet formatted">
       <h2>
Inviting People</h2>
    <p>
Invite people using <q>
+</q>
 or <q>
invite:</q>
</p>
    <blockquote>
      <p>
Repair the class 1.0 hyperdrive motivator +luke +han</p>
    </blockquote>
  </div>
  <div class="sheet formatted">
    <h2>
More Email Tips</h2>
    <p>
Delegate to or invite new Flow users with their email address:</p>
    <blockquote>
      <p>
@vader@empire.com Complete the death star +palpatine@empire.com</p>
    </blockquote>
    <p>
Invite multiple or add multiple tags at once using comma delimination:</p>
    <blockquote>
      <p>
Destroy the shield generator #&lsquo;endor, rebel alliance&rsquo; +&lsquo;han, lando, luke, leia&rsquo;</p>
    </blockquote>
        <p>
Use symbols and keywords interchangeably:</p>
    <blockquote>
      <p>
Destroy the shield generator #endor tag:"rebel alliance"</p>
    </blockquote>
  </div>
</script>
      <!-- Keyboard Shortcuts Help -->
<script id="view-template-flow-keyboard-shortcuts" type="text/html">
  <div class="sheet">
    <h2>
General</h2>
    <ul class="commands">
      <li>
        <h3>
New Task</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
enter</span>
              <span class="bot">
return</span>
               </div>
        </div>
      </li>
      <li class='open-quick-task-form'>
        <h3>
Open Quick Task Bar</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="bot">
shift</span>
            </div>
            <div class="plus-key">
              +            </div>
            <div class="key secondary">
              <span class="top">
enter</span>
              <span class="bot">
return</span>
               </div>
        </div>
      </li>
      <li>
        <h3>
New Task List</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              L            </div>
        </div>
      </li>
      <li>
        <h3>
New Folder</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              F            </div>
        </div>
      </li>
      <li>
        <h3>
New Contact</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              O            </div>
        </div>
      </li>
      <li>
        <h3>
Quick Search</h3>
        <div class="key-combo">
            <div class="key">
              /            </div>
        </div>
      </li>
      <li>
        <h3>
Settings</h3>
        <div class="key-combo">
            <div class="key">
              ,            </div>
        </div>
      </li>
      <li>
        <h3>
Keyboard Commands</h3>
        <div class="key-combo">
            <div class="key">
              ?            </div>
        </div>
      </li>
      <li>
        <h3>
Close Pop-outs</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="bot">
esc</span>
                </div>
        </div>
      </li>
            <li>
        <h3>
Switch to Lists Tab</h3>
        <div class="key-combo">
          <div class="key secondary">
            <span class="top">
alt</span>
            <span class="bot">
option</span>
             </div>
          <div class="plus-key">
            +          </div>
          <div class="key">
            1          </div>
        </div>
      </li>
      <li>
        <h3>
Switch to Contacts Tab</h3>
        <div class="key-combo">
          <div class="key secondary">
            <span class="top">
alt</span>
            <span class="bot">
option</span>
             </div>
          <div class="plus-key">
            +          </div>
          <div class="key">
            2          </div>
        </div>
      </li>
          </ul>
  </div>
    <div class="sheet">
    <h2>
Task Lists</h2>
    <ul class="commands">
      <li>
        <h3>
Next task</h3>
        <div class="key-combo">
            <div class="key nav-key">
              ?            </div>
            <div class="or-key">
              or            </div>
            <div class="key">
              J            </div>
        </div>
      </li>
      <li>
        <h3>
Previous task</h3>
        <div class="key-combo">
            <div class="key nav-key">
              ?            </div>
            <div class="or-key">
              or            </div>
            <div class="key">
              K            </div>
        </div>
      </li>
      <li>
        <h3>
Select all tasks</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              A            </div>
        </div>
      </li>
      <li class="key-clear-completed-tasks">
        <h3>
Clear Completed Tasks</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              K            </div>
        </div>
      </li>
      <li>
        <h3>
Toggle Lists</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              G            </div>
        </div>
      </li>
      <li>
        <h3>
Reload List</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              R            </div>
        </div>
      </li>
       <li>
        <h3>
Calendar View: Previous</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key nav-key">
              ?            </div>
        </div>
      </li>
      <li>
        <h3>
Calendar View: Next</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key nav-key">
              ?            </div>
        </div>
      </li>
    </ul>
  </div>
      <div class="sheet">
    <h2>
Task Pages</h2>
    <ul class="commands">
      <li>
        <h3>
Comment</h3>
        <div class="key-combo">
            <div class="key">
              C            </div>
        </div>
      </li>
      <li>
        <h3>
Return to List</h3>
        <div class="key-combo">
            <div class="key">
              U            </div>
        </div>
      </li>
      <li>
        <h3>
Toggle Description</h3>
        <div class="key-combo">
            <div class="key">
              \            </div>
        </div>
      </li>
      <li>
        <h3>
Edit Task</h3>
        <div class="key-combo">
            <div class="key">
              E            </div>
        </div>
      </li>
      <li>
        <h3>
Flag Task</h3>
        <div class="key-combo">
            <div class="key">
              F            </div>
        </div>
      </li>
      <li>
        <h3>
Delete Task</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              D            </div>
        </div>
      </li>
      <li>
        <h3>
Complete Task</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              C            </div>
        </div>
      </li>
      <li>
        <h3>
Follow Task</h3>
        <div class="key-combo">
            <div class="key">
              L            </div>
        </div>
      </li>
      <li>
        <h3>
Reload Task Page</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              R            </div>
        </div>
      </li>
      <li>
        <h3>
Post Comment</h3>
        <div class="key-combo">
            <div class="key">
              ?            </div>
            <div class="plus-key">
              +            </div>
            <div class="key secondary">
              <span class="top">
enter</span>
              <span class="bot">
return</span>
               </div>
        </div>
      </li>
    </ul>
  </div>
      <div class="sheet">
    <h2>
Selected Tasks</h2>
    <ul class="commands">
      <li>
        <h3>
Open Task Page</h3>
        <div class="key-combo">
            <div class="key nav-key">
              ?            </div>
        </div>
      </li>
      <li>
        <h3>
Comment</h3>
        <div class="key-combo">
            <div class="key">
              C            </div>
        </div>
      </li>
      <li>
        <h3>
Edit Task</h3>
        <div class="key-combo">
            <div class="key">
              E            </div>
        </div>
      </li>
      <li>
        <h3>
Flag Task</h3>
        <div class="key-combo">
            <div class="key">
              F            </div>
        </div>
      </li>
      <li>
        <h3>
Delete Task</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              D            </div>
        </div>
      </li>
      <li>
        <h3>
Complete Task</h3>
        <div class="key-combo">
            <div class="key secondary">
              <span class="top">
alt</span>
              <span class="bot">
option</span>
               </div>
            <div class="plus-key">
              +            </div>
            <div class="key">
              C            </div>
        </div>
      </li>
      <li>
        <h3>
Follow Task</h3>
        <div class="key-combo">
            <div class="key">
              L            </div>
        </div>
      </li>
    </ul>
  </div>
</script>
      <!-- Pop Out Task Form -->
<script id="view-template-task-popout-form" type="text/html">
  <div class="task-form">
    <div class="notification">
      <span class="icon">
</span>
      <span class="message">
</span>
    </div>
    <div class="edit-all-occurrences">
      <h3>
Apply changes to future occurrences?</h3>
      <ul class="switch">
        <li class="first yes">
Yes</li>
        <li class="last no">
No</li>
      </ul>
    </div>
    <form class="form" autocomplete="off">
      <div class="task-meta">
        <ul class="task-meta-inner">
</ul>
      </div>
      <button class="submit" type="submit" style="position: absolute; opacity: 0;" tabindex="-1">
Save</button>
    </form>
  </div>
</script>
      <!-- Infobar Projects List -->
<script id="view-template-infobar-projects-list" type="text/html">
  <div class="section projects">
    <h3 class="title">
<span class='fadeout'>
Lists</span>
</h3>
    <div class="section-content">
      <ul class="projects">
</ul>
      <ul class="actions">
</ul>
    </div>
  </div>
</script>
      <!-- Infobar Profile -->
<script id="view-template-infobar-profile" type="text/html">
  <div class="section profile">
    <div class="section-content">
      <div class="content">
        <div class="photo">
          <ins>
            <span class="photo">
</span>
          </ins>
        </div>
        <div class="text">
          <span class="name">
</span>
          <ul class="summaries">
</ul>
        </div>
        <div class="info">
          <ul>
</ul>
        </div>
        <div class="profile-actions">
          <a class="button default add">
Add</a>
          <a class="button remove">
Remove</a>
          <a class="button add-task">
Create Task</a>
        </div>
      </div>
    </div>
  </div>
</script>
      <!-- Infobar Action -->
<script id="view-template-infobar-actions" type="text/html">
  <div class="section projects">
    <div class="section-content">
      <ul class="actions-list" style="display: block;">
        <li class="action-item activities">
          <ins>
</ins>
          <a class="name" title="View activity">
Activity</a>
        </li>
        <li class="action-item everyone">
          <ins>
</ins>
          <a class="name" title="View everyone's tasks">
All Tasks</a>
          <div class="count">
29</div>
        </li>
        <li class="action-item my-account">
          <ins>
<span class='photo'>
</span>
</ins>
          <a class="name" title="View My Tasks">
My Tasks</a>
          <div class="count">
29</div>
        </li>
      </ul>
    </div>
  </div>
</script>
      <!-- Info Settings Pane -->
<script id="view-template-info-settings-pane" type="text/html">
  <div class="pane-inner">
    <div class="section user-photo">
      <label for="name-field-8" class="section-title">
Name &amp; Photo</label>
      <fieldset>
        <div class="account-photo">
          <ins>
            <span class="photo">
</span>
          </ins>
          <div class="spinner s24">
</div>
        </div>
        <div class="controls">
          <div class="upload-photo-wrap">
</div>
          <p>
or <a class="clear-photo">
remove this photo</a>
</p>
        </div>
      </fieldset>
      <fieldset>
        <ul class="inputs">
          <li>
<input class="name-field text icon name" type="text" placeholder="Name…" />
</li>
        </ul>
      </fieldset>
    </div>
        <div class="section">
      <label class="section-title name-label">
Primary Email</label>
      <fieldset>
        <ul class="inputs">
          <li>
<input class="email-field text icon email" type="text" placeholder="Email Address…" />
</li>
        </ul>
      </fieldset>
            <div class="alternate-email-div">
        <label class="section-title name-label">
Alternates</label>
        <fieldset>
          <ul class="inputs">
            <li class="intro">
Add your other emails to receive tasks shared with them:</li>
            <li class="alternate-email-li">
              <ul class="alternate-emails">
</ul>
              <input class="new-alternate-email-field text icon email" type="text" placeholder="Add another email address…" />
            </li>
          </ul>
        </fieldset>
      </div>
    </div>
        <div class="section profile-info">
      <label class="section-title profile-label">
Profile Info</label>
      <fieldset>
        <ul class="inputs">
          <li>
<input class="phone-field text icon phone" type="text" placeholder="Phone number…" />
</li>
          <li class="double">
            <input class="im-field text icon im" type="text" placeholder="Instant messenger…" />
            <select class="im-protocol field">
              <option value="">
Select service…</option>
              <option value="aim">
AIM</option>
                            <option value="gtalk">
Gtalk</option>
              <option value="msn">
MSN</option>
              <option value="yahoo">
Yahoo</option>
                            <option value="jabber">
Jabber</option>
              <option value="icq">
ICQ</option>
                                        </select>
          </li>
          <li>
<input class="skype-field text icon skype" type="text" placeholder="Skype…" />
</li>
          <li>
<input class="web-field text icon website" type="text" placeholder="Website…" />
</li>
          <li>
            <input class="location-field text icon location" type="text" placeholder="Location…" />
            <a class="button auto-detect-location">
<ins>
</ins>
</a>
          </li>
        </ul>
      </fieldset>
    </div>
    <div class="section profile-info">
      <label class="section-title profile-label">
Privacy</label>
      <fieldset class='checkbox-list'>
        <label>
Hide my account from public searches</label>
        <ul class="notifications">
          <li>
<input type="checkbox" class="privacy-hide-public-search" name="privacy-hide-public-search" />
</li>
        </ul>
      </fieldset>
    </div>
  </div>
</script>
      <fieldset class="checkbox-list">
        <label>
Only show my profile info to my contacts</label>
        <ul class="notifications">
          <li>
<input class="privacy-hide-profile-information" name="" type="checkbox">
</li>
        </ul>
      </fieldset>
    </div>
  </div>
<div style="display: none;" class="modal-underlay animation">
</div>
<div style="position: absolute; overflow: visible; top: 0px; left: 463px; display: none;" class="fancy-tooltip taskviewer animation">
<div class="tooltip-body">
<div class="event_blocker">
</div>
<div style="max-height: 653px;" class="task-viewer-inner task">
<div>
<h2 class="header">
<a>
Delete this task by clicking the trash can to the right</a>
<span class="is-flagged">
</span>
</h2>
<div class="checker">
<span>
<input style="opacity: 0;" class="task-checkbox" type="checkbox">
</span>
</div>
<ul class="menu">
<li class="task-edit">
<a class="edit">
<ins>
</ins>
edit</a>
</li>
<li class="task-delete">
<a class="delete">
<ins>
</ins>
delete</a>
</li>
<li class="task-comment">
<a class="comment">
<ins>
</ins>
comment</a>
</li>
<li class="task-flag">
<a class="flag">
<ins>
</ins>
flag</a>
</li>
</ul>
<ul class="information">
<li class="project-name">
<ins>
</ins>
In <a href="#/projects/429266" class="task-project-name">
The Basics</a>
</li>
<li style="display: none;" class="due-date">
<ins>
</ins>
Due <span class="task-due-date-value">
</span>
</li>
<li style="display: none;" class="recurrence-data">
<ins>
</ins>
<span class="task-recurrence-value">
</span>
</li>
<li style="display: list-item;" class="creation-date">
<ins>
</ins>
Created <span title="Sat May 12 2012 20:31:16 GMT-0400" class="task-creation-date-value">
53 minutes ago</span>
</li>
<li class="creator">
<ins>
</ins>
<span>
By </span>
<a class="name">
fschatzke</a>
</li>
</ul>
</div>
<div style="max-height: 0px; overflow: hidden; padding: 0px; height: 0px;" class="note_scroll_pane hidden">
<div style="height: 0px;" class="jspContainer">
<div style="left: 0px; top: 0px; width: 0px;" class="jspPane">
<div class="note formatted">
</div>
</div>
<div class="jspVerticalBar">
<div style="" class="jspTrack">
<div style="min-height: 10px; display: none;" class="jspDrag">
<div class="jspDragTop">
</div>
<div class="jspDragBottom">
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div style="position: absolute; width: 10px; height: 19px; top: 40px; left: -10px;" class="tooltip-tail center">
</div>
</div>
<div style="position: absolute; overflow: visible; top: 46px; left: 3px; display: none;" class="fancy-tooltip contextmenu">
<div class="tooltip-body">
<ul class="fancy-list">
<li class="group-header level-0 item">
<span>
Preferences</span>
</li>
<li class="std level-0 item">
<span>
General…</span>
</li>
<li class="std level-0 item">
<span>
My Info…</span>
</li>
<li class="std level-0 item">
<span>
Notifications…</span>
</li>
<li class="std level-0 item">
<span>
Account &amp; Billing…</span>
</li>
<li class="std level-0 item">
<span>
Password…</span>
</li>
<li class="std level-0 item">
<span>
Social Networks…</span>
</li>
<li class="std level-0 item">
<span>
Import &amp; Export…</span>
</li>
<li class="separator level-0 item">
<span>
------</span>
</li>
<li class="group-header level-0 item">
<span>
Extras</span>
</li>
<li class="std level-0 item">
<span>
Get Flow for Free…</span>
</li>
<li class="std level-0 item">
<span>
Download iPhone App</span>
</li>
<li class="std level-0 item">
<span>
Download Mac App</span>
</li>
<li class="std level-0 item">
<span>
Do Later Bookmarklet…</span>
</li>
<li class="separator level-0 item">
<span>
------</span>
</li>
<li class="group-header level-0 item">
<span>
Support</span>
</li>
<li class="std level-0 item">
<span>
Quick Start Guide…</span>
</li>
<li class="std level-0 item">
<span>
Email Integration…</span>
</li>
<li class="std level-0 item">
<span>
Keyboard Shortcuts…</span>
</li>
<li class="std level-0 item">
<span>
Get Help…</span>
</li>
<li class="std level-0 item">
<span>
Turn Off Quick Tips</span>
</li>
<li class="separator level-0 item">
<span>
------</span>
</li>
<li class="std level-0 item">
<span>
Logout</span>
</li>
</ul>
</div>
<div style="position: absolute; width: 26px; height: 12px; top: -12px; left: 18px;" class="tooltip-tail top">
</div>
</div>
<div style="display: none; position: absolute;" class="pop-out-wrap quicksearch pop-out-list">
<div class="pop-out">
<div class="pop-out-body">
<div class="pop-out-header">
<a style="display: inline;" class="wrapper">
<button class="left cancel" type="button">
Cancel</button>
<div class="back_button">
</div>
</a>
<h2 class="title">
Quick Search</h2>
<button style="display: none;" class="button right" type="button">
</button>
</div>
<div class="pop-out-content">
<ul class="fancy-list">
</ul>
<div class="spinner s16">
</div>
</div>
<div class="pop-out-footer slim">
<a class="button">
<div>
<span>
View all tasks (includes all completed)…</span>
</div>
</a>
</div>
</div>
</div>
<div class="pop-out-tail">
</div>
</div>
      <script id="view-template-import-settings-pane" type="text/html">
  <div class="pane-inner">
    <div class="section things-db">
      <label for="things-db" class="section-title">
Import from Things</label>
      <fieldset>
        <div class="instructions">
          <p>
Flow will import your tasks, tags, and projects from Things for Mac. Simply upload your Things database to get started!</p>
          <ol class="flow_box steps">
            <li>
<span class="number">
1</span>
 Open Finder and Type ? ? G</li>
            <li>
<span class="number">
2</span>
 Copy &amp; paste <input class="no-auto-select" title="Click here and  ?-C" readonly type="text" value="~/Library/Application Support/Cultured Code/Things" onclick="this.select();"/>
</li>
            <li>
<span class="number">
3</span>
 Click <em>
Upload Things DB</em>
 and drag in Database.xml</li>
          </ol>
          <!-- <pre style="white-space: pre-wrap;">
Library/Application Support/Cultured Code/Things/Database.xml</pre>
  -->
        </div>
        <div class="things-db-upload">
<ins>
</ins>
</div>
        <div class="controls">
          <div class="upload-things-db-wrap">
</div>
        </div>
      </fieldset>
    </div>
    <div class="section">
      <label class="section-title">
Export Data</label>
      <fieldset>
        <ul class="inputs">
          <li class="intro">
Export all of your data, including tasks, lists, and contacts.</li>
          <li>
            <button class="start-account-export button">
              <span class="button-progress-bar">
</span>
              <span class="button-text">
Start Export</span>
            </button>
            <p class="export-message">
</p>
          </li>
        </ul>
      </fieldset>
    </div>
<!-- .section -->
  </div>
</script>
      <script id="view-template-flow-bookmarklet-help" type="text/html">
  <div>
    <div class="info formatted">
      <p class="intro">
Drag this to your bookmarks bar to save web pages to Flow:</p>
      <p>
<a href="javascript:(function(){document.body.appendChild(document.createElement('script')).src='https://app.getflow.com/bookmarklets/later.js';})();" class="bookmarklet">
? &nbsp; Do Later</a>
</p>
            <p class="footnote">
Click &ldquo;Do Later&rdquo; on any web page to save a link to the page in your inbox.</p>
      <p class="footnote">
<a href="http://www.getflow.com/blog/2011/08/do-later-bookmarklet/" title="Read our blog post about the Do Later bookmarklet" target="_blank">
Read more on our blog &rarr;</a>
</p>
    </div>
    <img src="../images/graphics/do_later.png" title="Do Later Bookmarklet" alt="Do Later Bookmarklet"/>
  </div>
</script>
      <script id="view-template-flow-tasks-list-export" type="text/html">
  <div >
    <form class="tasks-list-export-form">
      <p>
Download the tasks in this list to save, email, print, or share. The HTML and XML formats include activities and comments with each task.</p>
      <ul class="file-types">
        <li class="active">
           <label>
             <img src="../images/icons/filetype-large-pdf.png" alt="PDF"/>
             <div class="checkbox">
               <input type="radio" name="export_format" value="pdf" class="rdo-format rdo-pdf" checked="checked"/>
              </div>
          </label>
        </li>
        <li>
           <label>
             <img src="../images/icons/filetype-large-csv.png" alt="CSV"/>
             <div class="checkbox">
               <input type="radio" name="export_format" value="csv" class="rdo-format rdo-csv" />
              </div>
          </label>
        </li>
        <li>
           <label>
             <img src="../images/icons/filetype-large-html.png" alt="HTML"/>
             <div class="checkbox">
               <input type="radio" name="export_format" value="html" class="rdo-format rdo-html"/>
              </div>
          </label>
        </li>
        <li class="last">
           <label>
             <img src="../images/icons/filetype-large-xml.png" alt="XML"/>
             <div class="checkbox">
               <input type="radio" name="export_format" value="xml" class="rdo-format rdo-xml" />
              </div>
          </label>
        </li>
      </ul>
            <button type="submit" class="button start-export">
          <span class="icon">
</span>
           <span class="text">
Download</span>
</button>
      <div class="note">
Downloads will take longer depending on the number of tasks.</div>
    </form>
  </div>
</script>
      <!-- Welcome Slides -->
<script id="view-template-flow-welcome-back" type="text/html">
    <div>
      <div class="sheet formatted">
        <h2>
Your new trial starts today!</h2>
        <p>
You can continue using Flow for free until <strong class="free-until">
Great Birnam Wood to high Dunsinane Hill shall come against your</strong>
. Check out the video to see some of the great new features we’ve released recently...</p>
      </div>
      <div class="sheet formatted lower">
        <ol class="flow_box">
          <li>
            <a class="start-adding-contacts" title="Start adding contacts" target="_blank">
              <div class="bullet one">
1</div>
              <h3>
Invite your friends, family, and colleagues</h3>
              <p>
You&rsquo;ll be amazed by our collaborative features.</p>
              <div class="arrow">
</div>
            </a>
          </li>
          <li>
            <a href="http://support.getflow.com" title="Check out our Support Centre" target="_blank">
              <div class="bullet two">
2</div>
              <h3>
Check our the Support Centre</h3>
              <p>
We&rsquo;ve got great documentation and support staff.</p>
            <div class="arrow">
</div>
                         </a>
          </li>
          <li>
            <a href="http://twitter.com/flowapp" title="Follow us on Twitter" target="_blank">
              <div class="bullet three">
3</div>
               <h3>
Follow @flowapp on Twitter</h3>
              <p>
Stay up to date on feature announcements and news.</p>
              <div class="arrow">
</div>
            </a>
          </li>
        </ol>
    </div>
  </div>
</script>
      <!-- Quicktask FOrm -->
<script id="view-template-quicktask" type="text/html">
  <div class="quick-task">
    <ins>
<span class="inner">
</span>
</ins>
    <p class="quick-task-label">
New task&hellip;</p>
    <p class="quick-task-shortcut">
? ?</p>
    <div class="quick-task-form">
      <input type="text" class="quick-task-field" />
      <a class="quick-task-clear">
clear</a>
    </div>
  </div>
</script>
      <script id="view-template-delete-account-modal" type="text/html">
  <div class="section no-label no-padding navigation-vc">
  </div>
  <div class="navigation-bar">
    <a class="button back">
      <span>
Back</span>
    </a>
    <a class="button default started" style='display: none;'>
      <span>
Quick Guide</span>
    </a>
    <a class="button default next">
      <span>
Next</span>
    </a>
  </div>
</script>
<script id="view-template-delete-account-start" type="text/html">
  <div class="sheet-content welcome-3" style="display: block;">
     <div class="wrapper">
      <div class="wrapper-text">
        <h2>
Sorry to hear you’re leaving Flow</h2>
        <p>
Before you go, please take a moment to let us know why you’re moving on. We’re always looking for ways to improve Flow, and your feedback would be extremely helpful.</p>
      </div>
      <fieldset class="full-screen flow_box">
        <ul class="table-view">
</ul>
      </fieldset>
     </div>
    </div>
  </script>
<script id="view-template-delete-account-feedback" type="text/html">
  <div class="sheet-content welcome-3" style="display: block;">
    <div class="wrapper">
      <div class="wrapper-text">
        <h2>
What feature(s) would you like to see in Flow?</h2>
        <textarea placeholder="Details…">
</textarea>
        <p class="system-info">
User information such as browser specifications and error logs will be collected automatically.</p>
      </div>
    </div>
    </div>
  </script>
<script id="view-template-delete-account-done" type="text/html">
  <div class="sheet-content" style="display: block;">
     <div class="wrapper center">
      <img alt="Delete-account-success" height="96" src="https://d2e7uokvo0ac6e.cloudfront.net/1336777675/images/delete-account-success.png" width="96" />
      <h1>
Your Subscription Has Been Canceled</h1>
      <p>
Your subscription is now set to expire at the end of this billing cycle (December 24, 2012) and can be renewed at any time.</p>
    </div>
    </div>
  </script>
<script id="view-template-delete-account-close" type="text/html">
  <div class="sheet-content" style="display: block;">
    <div class="loading">
</div>
    <div class="wrapper delete delete-active">
      <h2>
Before you go…</h2>
      <p>
If you delete your account, all of your tasks and lists will be permanently removed from Flow. This includes any tasks added by others to the shared lists you’ve created.</p>
      <p>
You can also choose to cancel your subscription. You won’t be charged again, but your data will be left intact. You’ll be able to use Flow’s Collaborator View and you’ll have the option to fully reactivate your account at any time.</p>
    </div>
    <div class="wrapper delete delete-trial">
      <h2>
Before you go…</h2>
      <p>
If you delete your account, all of your tasks and lists will be permanently removed from Flow. This includes any tasks added by others to the shared lists you’ve created.</p>
      <p>
You can also choose to do nothing. You won’t be charged for Flow, but your data will be left intact. You’ll be able to use the Collaborator View and you’ll have the option to fully reactivate your account at any time</p>
    </div>
      <div class="wrapper delete delete-payed">
      <h2>
Before you go…</h2>
      <p>
If you close your account, all of your tasks and lists will be permanently removed from Flow. This includes any tasks added by others to the shared lists you’ve created.</p>
      <p>
You can also ask the person paying for your subscription to remove you. They will no longer be charged for your account, but we’ll leave your data intact. You’ll be able to use the Collaborator View and you’ll have the option to fully reactivate your account at any time.</p>
    </div>
      <div class="wrapper cancel">
      <h2>
Before you go…</h2>
      <p>
If you cancel your subscription, you’ll no longer be able to create new tasks, lists, or folders within Flow, or access the majority of Flow’s other features. Instead, you’ll be directed to Flow’s Collaborator View, where you’ll be limited to commenting on and completing shared tasks.</p>
      <p>
If you change your mind and want to access your account again, no problem: all of your data will be kept intact and secure so you can fully reactivate at any time.</p>
    </div>
  </div>
  </script>
<script id="view-template-delete-account-password" type="text/html">
  <div class="sheet-content" style="display: block;">
    <div class="loading">
</div>
      <div class="wrapper center">
        <h2>
Last step, we promise.</h2>
        <p>
We just need to make sure it’s you who’s deleting your account.</p>
        <input type="password" placeholder="Enter your password" />
      </div>
  </div>
</script>
      <script id="view-template-support-center-modal" type="text/html">
  <div class="section no-label no-padding navigation-vc">
  </div>
</script>
<script id="view-template-support-center-vc" type="text/html">
<div>
  <div class="wrapper">
    <div class="loading">
</div>
    <a class="table-row button" target="_blank" href="http://support.getflow.com">
      <div class="lifesaver">
</div>
      <div class="arrow">
</div>
      <h2>
Flow Support Center</h2>
      <p>
Our knowledge base includes helpful tips, tricks, and answers to the more frequently asked questions.</p>
    </a>
    <p class="primary-content">
For further assistance, contact Flow Support using the form below or by emailing <a href="mailto:support@getflow.com">
support@getflow.com</a>
.</p>
    <textarea placeholder="Your question…">
</textarea>
    <div class="submit">
      <p>
Info such as browser specs and error logs will be collected automatically</p>
      <a class="button default">
        <span>
Send Question</span>
      </a>
    </div>
  </div>
</div>
</script>
      <!-- Contact Form -->
<!--<script id="view-template-flow-contact-form-invite" type="text/html">
  <div class='contact-form-tab'>
    <div class='contact-form-tabbar'>
      <input class="invite name-field text name empty" type="text" placeholder="Full name…">
      <input class='invite email-field text name empty' type="text"  placeholder='Email address…'>
      <a class='send button disabled'>
        <span>
Send Invite</span>
      </a>
    </div>
    <div class='content'>
      <div class='invite-zero-state'>
</div>
    </div>
  </div>
</script>
<script id="view-template-flow-contact-form-suggest" type="text/html">
  <div class='contact-form-tab'>
    <div class='contact-form-tabbar connect'>
      <a class='google button network' data-network="google">
        <span>
Connect to Google</span>
      </a>
      <a class='facebook button network' data-network="facebook">
        <span>
Connect to Facebook</span>
      </a>
      <a class='twitter button network' data-network="twitter">
        <span>
Connect to Twitter</span>
      </a>
    </div>
    <div class='content'>
      <div class='suggested-zero-state'>
</div>
    </div>
  </div>
</script>
<script id="view-template-flow-contact-form-search" type="text/html">
  <div class='contact-form-tab'>
    <div class='contact-form-tabbar'>
      <input class='search-field text icon' type="text"  placeholder='Search Flow Users…'>
    </div>
    <div class='content'>
      <div class='search-zero-state'>
</div>
    </div>
  </div>
</script>
<script id="view-template-people-token-field-invite-form" type="text/html">
<div>
  <form method="post" action="">
    <div class="msg-bar has-helpout centeredTooltipText" data-tooltip="You receive a free month each time someone you invite subscribes to Flow.">
<div class="help-icon">
?</div>
 Get a free month with this invitation!</div>
    <input name="invite_name" placeholder="Name…" class="invite_name">
    <input name="invite_email" placeholder="Email…" class="invite_email">
    <div class="pop-out-footer two-buttons">
      <a class="button cancel">
<span>
Cancel</span>
</a>
      <a class="send button default disabled">
<span>
Send Invite</span>
</a>
    </div>
  </form>
</div>
</script>
<script id="view-template-flow-billing" type="text/html">
  <div class="pane-inner">
</div>
</script>
  <script id="view-template-flow-billing-loading-section" type="text/html">
  <sections>
    <section class="billing-section loading view-state" data-state="loading">
      <div class="spinner s36">
</div>
    </section>
    <section class="billing-section loading view-state error" data-state="error">
      <header>
        <ins class="avatar">
</ins>
        <div class="text">
          <h3>
Error Loading Subscription</h3>
          <p>
Please contact customer support.</p>
        </div>
      </header>
    </section>
  </sections>
</script>
  <script id="view-template-flow-billing-account-status" type="text/html">
  <div>
    <ins class="avatar">
      <span class="photo">
</span>
    </ins>
    <div class="text">
      <h3>
My Account</h3>
      <p class="since">
Since <span class="start-date">
</span>
 <a class="delete-account-link">
(Delete)</a>
</p>
    </div>
  </div>
</script>
  <script id="view-template-flow-billing-sub-status" type="text/html">
  <div>
    <div class="view-state" data-state="trial">
      <div class="text">
        <h3>
Free <span class="trial-length">
##</span>
-day Trial</h3>
        <p>
Enjoy through <span class="end-date">
MMM DD</span>
</p>
      </div>
      <div class="guarentee-stamp">
30-day Money Back</div>
    </div>
    <div class="view-state" data-state="active">
      <div class="text">
        <h3>
<span class="plan">
XXXXX</span>
 Subscription x <span class="qty">
0</span>
</h3>
        <p class="savings inline">
You are saving: <span class="saving">
0</span>
%<span class="discount-nfp">
NFP</span>
</p>
        <p class="since inline">
Since <span class="start-date">
</span>
</p>
        <p class="tax inline">
(Tax: <span class="tax-percent">
0</span>
%)</p>
        <p class="invoices inline">
<a class="invoices-link" href="/subscription/invoices" target="_blank">
(View Invoices)</a>
</p>
      </div>
      <div class="price">
        $<span class="dollars">
0</span>
<sup class="cents">
00</sup>
        <p class="period">
per <span class="unit">
xxxx</span>
</p>
      </div>
    </div>
    <div class="view-state" data-state="expired">
      <div class="text">
        <h3>
Your Trial Has Expired</h3>
      </div>
      <div class="guarentee-stamp">
30-day Money Back</div>
    </div>
    <div class="view-state" data-state="comped">
      <ins class="avatar">
        <span class="photo">
</span>
      </ins>
      <div class="text">
        <h3>
MetaLab <span style="font-weight: normal;">
pays for you</span>
</h3>
        <p class="enjoy">
Enjoy Free Flow Forever!</p>
      </div>
      <div class="guarentee-stamp">
30-day Money Back</div>
    </div>
    <div class="view-state" data-state="paid">
      <ins class="avatar">
        <span class="photo">
</span>
      </ins>
      <div class="text">
        <h3>
<span class="name">
XXXX</span>
 <span style="font-weight: normal;">
pays for you</span>
</h3>
        <p class="since">
Since <span class="start-date">
</span>
</p>
      </div>
      <div class="guarentee-stamp">
30-day Money Back</div>
    </div>
    <div class="view-state" data-state="canceled">
      <div class="text">
        <h3>
Your Subscription Is Cancelled</h3>
        <p class="ends">
Ends on <span class="end-date">
</span>
</p>
      </div>
      <div class="guarentee-stamp">
30-day Money Back</div>
    </div>
  </div>
</script>
  <script id="view-template-flow-billing-accounts-controls" type="text/html">
  <div>
    <div class="view-state" data-state="initial">
      <button class="button add-more-accounts purchase-initiator">
Add More Accounts</button>
    </div>
    <div class="view-state" data-state="default">
      <button class="button add-remove-accounts purchase-initiator">
Add/Remove Accounts</button>
    </div>
    <div class="view-state" data-state="form">
      <div class="add-account-wrap">
        <input class="email-field text icon email" type="text" placeholder="Email address..." />
        <button class="button form-ctl cancel">
<ins>
</ins>
</button>
      </div>
    </div>
  </div>
</script>
<script id="view-template-flow-billing-accounts-list" type="text/html">
  <ul class="accounts-list">
</ul>
</script>
      <script id="view-template-flow-billing-accounts-form" type="text/html">
  <div>
    <div class="view-state" data-state="empty">
      <label class="section-title">
Purchase Accounts for Your Team</label>
      <ul class="discount-list">
        <li>
Purchase <strong>
3 or more</strong>
 accounts and get <em>
30% off!</em>
</li>
        <li>
Purchase <strong>
10 or more</strong>
 accounts and get <em>
50% off!</em>
</li>
      </ul>
      <div class="accounts-ctls-wrap">
</div>
    </div>
    <div class="view-state" data-state="first">
      <p>
You can pay for anyone with or without a Flow account. If you add someone who already has a paid account, they&rsquo;ll receive an email to confirm the change.</p>
      <div class="accounts-ctls-wrap">
</div>
    </div>
    <div class="view-state" data-state="default">
      <div class="accounts-list-wrap">
</div>
      <div class="accounts-ctls-wrap">
</div>
    </div>
  </div>
</script>
<script id="view-template-flow-billing-sub-form" type="text/html">
  <div>
    <ul class="plans">
</ul>
  </div>
</script>
-->
<!--<script id="view-template-flow-billing-cc-form" type="text/html">
  <div>
    <ul class="inputs">
      <li>
        <input class="billing_info_first_name text half " type="text" placeholder="First name…" />
        <input class="billing_info_last_name text half " type="text" placeholder="Last name…" />
      </li>
      <li>
        <input class="billing_info_credit_card_number credit_card_number text " type="text" placeholder="Credit card number…" />
        <input class="billing_info_credit_card_verification_value security_code text " type="text" placeholder="CCV…" maxlength="4" />
      </li>
      <li>
        <div class="billing_info_credit_card_month credit_card_month">
          <select>
            <option value="">
Month...</option>
            <option value="01">
01 - Jan</option>
            <option value="02">
02 - Feb</option>
            <option value="03">
03 - Mar</option>
            <option value="04">
04 - Apr</option>
            <option value="05">
05 - May</option>
            <option value="06">
06 - Jun</option>
            <option value="07">
07 - Jul</option>
            <option value="08">
08 - Aug</option>
            <option value="09">
09 - Sep</option>
            <option value="10">
10 - Oct</option>
            <option value="11">
11 - Nov</option>
            <option value="12">
12 - Dec</option>
          </select>
        </div>
        <div class="billing_info_credit_card_year credit_card_year">
          <select>
            <option value="">
Year...</option>
              <option value="2012">
2012</option>
              <option value="2013">
2013</option>
              <option value="2014">
2014</option>
              <option value="2015">
2015</option>
              <option value="2016">
2016</option>
              <option value="2017">
2017</option>
              <option value="2018">
2018</option>
              <option value="2019">
2019</option>
              <option value="2020">
2020</option>
              <option value="2021">
2021</option>
              <option value="2022">
2022</option>
          </select>
        </div>
		      </li>
      <li>
        <input class="billing_info_address1 text" type="text" placeholder="Street 1" />
      </li>
      <li>
        <input class="billing_info_address2 text" type="text" placeholder="Street 2" />
      </li>
      <li>
        <input class="billing_info_city text" type="text" placeholder="City…" />
      </li>
      <li>
        <div class="billing_info_country half">
          <select class="select-country">
            <option value="">
Country…</option>
            <option value="AF">
Afghanistan</option>
<option value="AL">
Albania</option>
<option value="DZ">
Algeria</option>
<option value="AS">
American Samoa</option>
<option value="AD">
Andorra</option>
<option value="AO">
Angola</option>
<option value="AI">
Anguilla</option>
<option value="AG">
Antigua and Barbuda</option>
<option value="AR">
Argentina</option>
<option value="AM">
Armenia</option>
<option value="AW">
Aruba</option>
<option value="AU" place="top" order="4">
Australia</option>
<option value="AT">
Austria</option>
<option value="AZ">
Azerbaijan</option>
<option value="BS">
Bahamas</option>
<option value="BH">
Bahrain</option>
<option value="BD">
Bangladesh</option>
<option value="BB">
Barbados</option>
<option value="BY">
Belarus</option>
<option value="BE">
Belgium</option>
<option value="BZ">
Belize</option>
<option value="BJ">
Benin</option>
<option value="BM">
Bermuda</option>
<option value="BT">
Bhutan</option>
<option value="BO">
Bolivia</option>
<option value="BA">
Bosnia and Herzegovina</option>
<option value="BW">
Botswana</option>
<option value="BV">
Bouvet Island</option>
<option value="BR">
Brazil</option>
<option value="IO">
British Indian Ocean Territory</option>
<option value="BN">
Brunei Darussalam</option>
<option value="BG">
Bulgaria</option>
<option value="BF">
Burkina Faso</option>
<option value="BI">
Burundi</option>
<option value="KH">
Cambodia</option>
<option value="CM">
Cameroon</option>
<option value="CA" place="top" order="1">
Canada</option>
<option value="CV">
Cape Verde</option>
<option value="KY">
Cayman Islands</option>
<option value="CF">
Central African Republic</option>
<option value="TD">
Chad</option>
<option value="CL">
Chile</option>
<option value="CN">
China</option>
<option value="CX">
Christmas Island</option>
<option value="CC">
Cocos (Keeling) Islands</option>
<option value="CO">
Colombia</option>
<option value="KM">
Comoros</option>
<option value="CG">
Congo</option>
<option value="CD">
Congo, the Democratic Republic of the</option>
<option value="CK">
Cook Islands</option>
<option value="CR">
Costa Rica</option>
<option value="CI">
Cote D'Ivoire</option>
<option value="HR">
Croatia</option>
<option value="CU">
Cuba</option>
<option value="CY">
Cyprus</option>
<option value="CZ">
Czech Republic</option>
<option value="DK">
Denmark</option>
<option value="DJ">
Djibouti</option>
<option value="DM">
Dominica</option>
<option value="DO">
Dominican Republic</option>
<option value="EC">
Ecuador</option>
<option value="EG">
Egypt</option>
<option value="SV">
El Salvador</option>
<option value="GQ">
Equatorial Guinea</option>
<option value="ER">
Eritrea</option>
<option value="EE">
Estonia</option>
<option value="ET">
Ethiopia</option>
<option value="FK">
Falkland Islands (Malvinas)</option>
<option value="FO">
Faroe Islands</option>
<option value="FJ">
Fiji</option>
<option value="FI">
Finland</option>
<option value="FR">
France</option>
<option value="GF">
French Guiana</option>
<option value="PF">
French Polynesia</option>
<option value="TF">
French Southern Territories</option>
<option value="GA">
Gabon</option>
<option value="GM">
Gambia</option>
<option value="GE">
Georgia</option>
<option value="DE">
Germany</option>
<option value="GH">
Ghana</option>
<option value="GI">
Gibraltar</option>
<option value="GR">
Greece</option>
<option value="GL">
Greenland</option>
<option value="GD">
Grenada</option>
<option value="GP">
Guadeloupe</option>
<option value="GU">
Guam</option>
<option value="GT">
Guatemala</option>
<option value="GG">
Guernsey</option>
<option value="GN">
Guinea</option>
<option value="GW">
Guinea-Bissau</option>
<option value="GY">
Guyana</option>
<option value="HT">
Haiti</option>
<option value="HM">
Heard Island And Mcdonald Islands</option>
<option value="VA">
Holy See (Vatican City State)</option>
<option value="HN">
Honduras</option>
<option value="HK">
Hong Kong</option>
<option value="HU">
Hungary</option>
<option value="IS">
Iceland</option>
<option value="IN">
India</option>
<option value="ID">
Indonesia</option>
<option value="IR">
Iran, Islamic Republic of</option>
<option value="IQ">
Iraq</option>
<option value="IE">
Ireland</option>
<option value="IM">
Isle Of Man</option>
<option value="IL">
Israel</option>
<option value="IT">
Italy</option>
<option value="JM">
Jamaica</option>
<option value="JP" place="top" order="5">
Japan</option>
<option value="JE">
Jersey</option>
<option value="JO">
Jordan</option>
<option value="KZ">
Kazakhstan</option>
<option value="KE">
Kenya</option>
<option value="KI">
Kiribati</option>
<option value="KP">
Korea, Democratic People's Republic of</option>
<option value="KR">
Korea, Republic of</option>
<option value="KW">
Kuwait</option>
<option value="KG">
Kyrgyzstan</option>
<option value="LA">
Lao People's Democratic Republic</option>
<option value="LV">
Latvia</option>
<option value="LB">
Lebanon</option>
<option value="LS">
Lesotho</option>
<option value="LR">
Liberia</option>
<option value="LY">
Libyan Arab Jamahiriya</option>
<option value="LI">
Liechtenstein</option>
<option value="LT">
Lithuania</option>
<option value="LU">
Luxembourg</option>
<option value="MO">
Macao</option>
<option value="MK">
Macedonia, the Former Yugoslav Republic of</option>
<option value="MG">
Madagascar</option>
<option value="MW">
Malawi</option>
<option value="MY">
Malaysia</option>
<option value="MV">
Maldives</option>
<option value="ML">
Mali</option>
<option value="MT">
Malta</option>
<option value="MH">
Marshall Islands</option>
<option value="MQ">
Martinique</option>
<option value="MR">
Mauritania</option>
<option value="MU">
Mauritius</option>
<option value="YT">
Mayotte</option>
<option value="MX">
Mexico</option>
<option value="FM">
Micronesia, Federated States of</option>
<option value="MD">
Moldova, Republic of</option>
<option value="MC">
Monaco</option>
<option value="MN">
Mongolia</option>
<option value="ME">
Montenegro</option>
<option value="MS">
Montserrat</option>
<option value="MA">
Morocco</option>
<option value="MZ">
Mozambique</option>
<option value="MM">
Myanmar</option>
<option value="NA">
Namibia</option>
<option value="NR">
Nauru</option>
<option value="NP">
Nepal</option>
<option value="NL">
Netherlands</option>
<option value="AN">
Netherlands Antilles</option>
<option value="NC">
New Caledonia</option>
<option value="NZ">
New Zealand</option>
<option value="NI">
Nicaragua</option>
<option value="NE">
Niger</option>
<option value="NG">
Nigeria</option>
<option value="NU">
Niue</option>
<option value="NF">
Norfolk Island</option>
<option value="MP">
Northern Mariana Islands</option>
<option value="NO">
Norway</option>
<option value="OM">
Oman</option>
<option value="PK">
Pakistan</option>
<option value="PW">
Palau</option>
<option value="PS">
Palestinian Territory, Occupied</option>
<option value="PA">
Panama</option>
<option value="PG">
Papua New Guinea</option>
<option value="PY">
Paraguay</option>
<option value="PE">
Peru</option>
<option value="PH">
Philippines</option>
<option value="PN">
Pitcairn</option>
<option value="PL">
Poland</option>
<option value="PT">
Portugal</option>
<option value="PR">
Puerto Rico</option>
<option value="QA">
Qatar</option>
<option value="RE">
Reunion</option>
<option value="RO">
Romania</option>
<option value="RU">
Russian Federation</option>
<option value="RW">
Rwanda</option>
<option value="BL">
Saint Barthélemy</option>
<option value="SH">
Saint Helena</option>
<option value="KN">
Saint Kitts and Nevis</option>
<option value="LC">
Saint Lucia</option>
<option value="MF">
Saint Martin (French part)</option>
<option value="PM">
Saint Pierre and Miquelon</option>
<option value="VC">
Saint Vincent and the Grenadines</option>
<option value="WS">
Samoa</option>
<option value="SM">
San Marino</option>
<option value="ST">
Sao Tome and Principe</option>
<option value="SA">
Saudi Arabia</option>
<option value="SN">
Senegal</option>
<option value="RS">
Serbia</option>
<option value="SC">
Seychelles</option>
<option value="SL">
Sierra Leone</option>
<option value="SG">
Singapore</option>
<option value="SK">
Slovakia</option>
<option value="SI">
Slovenia</option>
<option value="SB">
Solomon Islands</option>
<option value="SO">
Somalia</option>
<option value="ZA">
South Africa</option>
<option value="GS">
South Georgia and the South Sandwich Islands</option>
<option value="ES">
Spain</option>
<option value="LK">
Sri Lanka</option>
<option value="SD">
Sudan</option>
<option value="SR">
Suriname</option>
<option value="SJ">
Svalbard and Jan Mayen</option>
<option value="SZ">
Swaziland</option>
<option value="SE">
Sweden</option>
<option value="CH">
Switzerland</option>
<option value="SY">
Syrian Arab Republic</option>
<option value="TW">
Taiwan, Province of China</option>
<option value="TJ">
Tajikistan</option>
<option value="TZ">
Tanzania, United Republic of</option>
<option value="TH">
Thailand</option>
<option value="TL">
Timor Leste</option>
<option value="TG">
Togo</option>
<option value="TK">
Tokelau</option>
<option value="TO">
Tonga</option>
<option value="TT">
Trinidad and Tobago</option>
<option value="TN">
Tunisia</option>
<option value="TR">
Turkey</option>
<option value="TM">
Turkmenistan</option>
<option value="TC">
Turks and Caicos Islands</option>
<option value="TV">
Tuvalu</option>
<option value="UG">
Uganda</option>
<option value="UA">
Ukraine</option>
<option value="AE">
United Arab Emirates</option>
<option value="GB" place="top" order="3">
United Kingdom</option>
<option value="US" place="top" order="2">
United States</option>
<option value="UM">
United States Minor Outlying Islands</option>
<option value="UY">
Uruguay</option>
<option value="UZ">
Uzbekistan</option>
<option value="VU">
Vanuatu</option>
<option value="VE">
Venezuela</option>
<option value="VN">
Viet Nam</option>
<option value="VG">
Virgin Islands, British</option>
<option value="VI">
Virgin Islands, U.S.</option>
<option value="WF">
Wallis and Futuna</option>
<option value="EH">
Western Sahara</option>
<option value="YE">
Yemen</option>
<option value="ZM">
Zambia</option>
<option value="ZW">
Zimbabwe</option>
<option value="AX">
Åland Islands</option>
          </select>
        </div>
        <div class="billing_info_state select canada half">
          <select class="select-prov-state">
            <option value="">
Province…</option>
            <option value="BC">
British Columbia</option>
<option value="AB">
Alberta</option>
<option value="SK">
Saskatchewan</option>
<option value="MB">
Manitoba</option>
<option value="ON">
Ontario</option>
<option value="QC">
Quebec</option>
<option value="NL">
Newfoundland and Labrador</option>
<option value="NB">
New Brunswick</option>
<option value="PE">
Prince Edward Island</option>
<option value="NS">
Nova Scotia</option>
<option value="YT">
Yukon</option>
<option value="NT">
Northwest Territories</option>
<option value="NU">
Nunavut</option>
          </select>
        </div>
        <div class="billing_info_state select us half">
          <select "select-prov-state">
            <option value="">
State…</option>
              <option value="AK">
Alaska</option>
  <option value="AL">
Alabama</option>
  <option value="AR">
Arkansas</option>
  <option value="AZ">
Arizona</option>
  <option value="CA">
California</option>
  <option value="CO">
Colorado</option>
  <option value="CT">
Connecticut</option>
  <option value="DC">
District of Columbia</option>
  <option value="DE">
Delaware</option>
  <option value="FL">
Florida</option>
  <option value="GA">
Georgia</option>
  <option value="HI">
Hawaii</option>
  <option value="IA">
Iowa</option>
  <option value="ID">
Idaho</option>
  <option value="IL">
Illinois</option>
  <option value="IN">
Indiana</option>
  <option value="KS">
Kansas</option>
  <option value="KY">
Kentucky</option>
  <option value="LA">
Louisiana</option>
  <option value="MA">
Massachusetts</option>
  <option value="MD">
Maryland</option>
  <option value="ME">
Maine</option>
  <option value="MI">
Michigan</option>
  <option value="MN">
Minnesota</option>
  <option value="MO">
Missouri</option>
  <option value="MS">
Mississippi</option>
  <option value="MT">
Montana</option>
  <option value="NC">
North Carolina</option>
  <option value="ND">
North Dakota</option>
  <option value="NE">
Nebraska</option>
  <option value="NH">
New Hampshire</option>
  <option value="NJ">
New Jersey</option>
  <option value="NM">
New Mexico</option>
  <option value="NV">
Nevada</option>
  <option value="NY">
New York</option>
  <option value="OH">
Ohio</option>
  <option value="OK">
Oklahoma</option>
  <option value="OR">
Oregon</option>
  <option value="PA">
Pennsylvania</option>
  <option value="RI">
Rhode Island</option>
  <option value="SC">
South Carolina</option>
  <option value="SD">
South Dakota</option>
  <option value="TN">
Tennessee</option>
  <option value="TX">
Texas</option>
  <option value="UT">
Utah</option>
  <option value="VA">
Virginia</option>
  <option value="VT">
Vermont</option>
  <option value="WA">
Washington</option>
  <option value="WI">
Wisconsin</option>
  <option value="WV">
West Virginia</option>
  <option value="WY">
Wyoming</option>
          </select>
        </div>
        <input class="billing_info_state text half " type="text" placeholder="Province/State…" />
      </li>
      <li>
        <input class="billing_info_zip text half" type="text" placeholder="ZIP / Postal Code" />
        <input class="billing_info_phone text half" type="text" placeholder="Phone" />
      </li>
    </ul>
  </div>
</script>
-->
      <script id="view-template-flow-billing-purchase-summary" type="text/html">
  <div>
    <div class="division payment-summary">
      <ul>
        <li class="sub-total">
          <label>
<span class="plan_name">
XXXX</span>
 Subscription × <span class="qty">
0</span>
</label>
          <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
        <li class="discount">
          <label>
discount name</label>
          <p class="cost">
-$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
        <li class="tax">
          <label>
Tax (<span class="percent">
0</span>
%)</label>
          <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
        <li class="total">
          <label>
Total</label>
          <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
      </ul>
      <div class="messages">
</div>
    </div>
    <div class="division submit">
      <div class="controls">
        <p class="terms">
By clicking the payment button below you&rsquo;re agreeing to the <a href="http://getflow.com/tos">
Terms of Use</a>
 &amp; <a href="http://getflow.com/tos#pp">
Privacy Policy</a>
.</p>
        <fieldset>
          <button type="submit" class="button confirm-submit default">
            <span class="button-progress-bar">
</span>
            <span class="button-text">
Process Payment</span>
          </button>
          <span class="or-cancel cancel-submit">
or <a>
cancel</a>
</span>
        </fieldset>
      </div>
    </div>
  </div>
</script>
      <script id="view-template-flow-billing-editsub-summary" type="text/html">
  <div>
    <div class="division payment-summary">
      <ul>
        <li class="current-payment fade" data-set="new">
          <label>
Current Payment (<span class="plan-short-summary">
</span>
)</label>
          <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
        <li class="divider" data-set="new">
</li>
        <li class="new-subtotal" data-set="new">
          <label>
Subtotal (<span class="plan-short-summary">
</span>
)</label>
          <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
        <li class="discount">
          <label>
discount name</label>
          <p class="cost">
-$<span class="amount">
0.00</span>
<hide>
/<span class="period">
xx</span>
</hide>
</p>
        </li>
        <li class="tax" data-set="new">
          <label>
Tax (<span class="percent">
0</span>
%, <span class="state">
XX</span>
)</label>
          <p class="cost">
$<span class="amount">
0.00</span>
<hide>
/<span class="period">
xx</span>
</hide>
</p>
        </li>
        <li class="total" data-set="new">
          <label>
New Payment</label>
          <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
        </li>
      </ul>
      <div class="messages">
</div>
    </div>
    <div class="division submit">
      <p class="notes prorate to-annual">
Your new annual billing cycle will begin today. The balance of your monthly payments will be credited to your first invoice.</p>
      <p class="notes prorate to-monthly">
Your new monthly billing cycle will begin today. The balance of your annual payments will be credited to future invoices.</p>
      <div class="controls">
        <fieldset>
          <button type="submit" class="button confirm-submit default">
            <span class="button-progress-bar">
</span>
            <span class="button-text">
Process Payment</span>
          </button>
          <span class="or-cancel cancel-submit">
or <a>
cancel</a>
</span>
        </fieldset>
      </div>
    </div>
  </div>
</script>
      <script id="view-template-flow-billing-editbilling-summary" type="text/html">
  <div>
    <div class="division submit">
      <div class="controls">
        <fieldset>
          <button type="submit" class="button confirm-submit default">
            <span class="button-progress-bar">
</span>
            <span class="button-text">
Save Change</span>
          </button>
          <span class="or-cancel cancel-submit">
or <a>
cancel</a>
</span>
        </fieldset>
      </div>
    </div>
  </div>
</script>
      <script id="view-template-flow-billing-subscription-section" type="text/html">
  <sections>
    <section class="billing-section subscription subscription-form-wrap view-state" data-state="trial">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division">
        <p>
Purchase a $9.99/monthly or $99/annual subscription. Save up to 50% when you pay for your team!</p>
        <button type="submit" class="button purchase-subscription default purchase-initiator">
            <span class="button-progress-bar">
</span>
            <span class="button-text">
Purchase a Subscription</span>
        </button>
      </div>
    </section>
    <section class="billing-section subscription subscription-form-wrap view-state" data-state="purchase">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division accounts">
<!-- Account Form Goes Here -->
</div>
      <div class="division sub">
        <label class="section-title">
Subscription</label>
        <fieldset>
<!-- Sub Form Goes Here -->
</fieldset>
      </div>
      <div class="division cc">
        <form class="form credit-card">
          <label class="section-title">
            <span>
Credit Card</span>
            <div class="right">
              <div class="banner secure">
Secure Form</div>
              <ul class="accepted">
                <li class="card visa">
Visa</li>
                <li class="card master">
Master Card</li>
                <li class="card american_express">
American Express</li>
              </ul>
            </div>
          </label>
          <fieldset>
<!-- CC Form Goes Here -->
</fieldset>
        </form>
      </div>
      <footer>
<!-- Submit Summary Goes Here -->
</footer>
    </section>
    <section class="billing-section subscription subscription-form-wrap view-state" data-state="editsub">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division sub">
        <label class="section-title">
Subscription</label>
        <fieldset>
<!-- Sub Form Goes Here -->
</fieldset>
        <p class="or-cancel">
or <a class="cancel-subscription-link">
cancel your subscription</a>
</p>
      </div>
      <footer>
<!-- Edit Sub Summary Goes Here -->
</footer>
    </section>
    <section class="billing-section subscription subscription-form-wrap view-state" data-state="editbilling">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division cc">
        <form class="form credit-card">
          <label class="section-title">
            <span>
Credit Card</span>
            <div class="right">
              <div class="banner secure">
Secure Form</div>
              <ul class="accepted">
                <li class="card visa">
Visa</li>
                <li class="card master">
Master Card</li>
                <li class="card american_express">
American Express</li>
              </ul>
            </div>
          </label>
          <fieldset>
<!-- CC Form Goes Here -->
</fieldset>
        </form>
      </div>
      <footer>
<!-- Edit Billing Summary Goes Here -->
</footer>
    </section>
    <section class="billing-section subscription subscription-form-wrap view-state" data-state="active">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division subscription-edit-controls">
        <button type="submit" class="button edit-subscription purchase-initiator">
Edit Subscription</button>
        <button type="submit" class="button edit-billing-info purchase-initiator">
Edit Billing Info</button>
        <div class="card-type-icon card">
Visa</div>
      </div>
    </section>
    <section class="billing-section subscription subscription-form-wrap comped view-state" data-state="comped">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division">
        <button type="submit" class="button pay-for-self purchase-initiator">
Pay for Myself</button>
      </div>
    </section>
    <section class="billing-section subscription subscription-form-wrap view-state" data-state="paid">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division">
        <button type="submit" class="button pay-for-self purchase-initiator">
Take Over Payment</button>
      </div>
    </section>
    <section class="billing-section subscription subscription-form-wrap expired view-state" data-state="expired">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division">
        <p>
To ensure you’re not left out of the loop, you will be able to continue viewing all the tasks you’ve been assigned or invited to. Subcribe to Flow to continue creating, delegating, and managing tasks.</p>
        <button type="submit" class="button purchase-subscription default purchase-initiator">
          <span class="button-progress-bar">
</span>
          <span class="button-text">
Purchase a Subscription</span>
        </button>
      </div>
    </section>
    <section class="billing-section subscription subscription-form-wrap canceled view-state" data-state="canceled">
      <header>
<!-- Sub Status Goes Here -->
</header>
      <div class="division">
        <p>
You can continue to use Flow without limitation until the end date above. You can reactivate your subscription.</p>
        <button type="submit" class="button reactivate-subscription default purchase-initiator">
          <span class="button-progress-bar">
</span>
          <span class="button-text">
Reactivate Subscription</span>
        </button>
      </div>
    </section>
  </sections>
</script>
      <script id="view-template-flow-billing-editaccounts-summary" type="text/html">
  <div>
    <div class="view-state" data-state="default">
      <div class="division payment-summary">
        <ul>
          <li class="current-payment fade" data-set="new">
            <label>
Current Payment (<span class="plan-short-summary">
</span>
)</label>
            <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
          </li>
          <li class="divider" data-set="new">
</li>
          <li class="new-subtotal" data-set="new">
            <label>
Subtotal (<span class="plan-short-summary">
</span>
)</label>
            <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
          </li>
          <li class="discount">
            <label>
discount name</label>
            <p class="cost">
-$<span class="amount">
0.00</span>
<hide>
/<span class="period">
xx</span>
</hide>
</p>
          </li>
          <li class="tax" data-set="new">
            <label>
Tax (<span class="percent">
0</span>
%, <span class="state">
XX</span>
)</label>
            <p class="cost">
$<span class="amount">
0.00</span>
<hide>
/<span class="period">
xx</span>
</hide>
</p>
          </li>
          <li class="total" data-set="new">
            <label>
New Payment</label>
            <p class="cost">
$<span class="amount">
0.00</span>
/<span class="period">
xx</span>
</p>
          </li>
        </ul>
        <div class="messages">
</div>
      </div>
      <div class="division submit">
        <p class="notes prorate increase">
The number of accounts you&rsquo;re paying for has increased, so a prorated invoice for <span class="count">
0 new account</span>
 will be processed today.</p>
        <p class="notes prorate decrease">
The number of accounts you&rsquo;re paying for has decreased, so you&rsquo;ll see a credit on your next invoice.</p>
        <div class="controls">
          <fieldset>
            <button type="submit" class="button confirm-submit default">
              <span class="button-progress-bar">
</span>
              <span class="button-text">
Save Changes</span>
            </button>
            <span class="or-cancel cancel-submit">
or <a>
cancel</a>
</span>
          </fieldset>
        </div>
      </div>
    </div>
    <div class="view-state" data-state="simple">
      <div class="division payment-summary">
        <ul>
          <li class="diff">
            <label>
+/- 0 account(s)</label>
          </li>
        </ul>
        <div class="messages">
</div>
      </div>
      <div class="division submit">
        <div class="controls">
          <fieldset>
            <button type="submit" class="button confirm-submit default">
              <span class="button-progress-bar">
</span>
              <span class="button-text">
Save Change</span>
            </button>
            <span class="or-cancel cancel-submit">
or <a>
cancel</a>
</span>
          </fieldset>
        </div>
      </div>
    </div>
  </div>
</script>
      <script id="view-template-flow-billing-accounts-section" type="text/html">
  <sections>
    <section class="billing-section account view-state" data-state="empty">
      <header>
<!-- Account Status Goes Here -->
</header>
      <div class="division accounts">
<!-- Account Form Goes Here -->
</div>
    </section>
    <section class="billing-section account view-state" data-state="default">
      <header>
<!-- Account Status Goes Here -->
</header>
      <div class="division accounts">
<!-- Account Form Goes Here -->
</div>
    </section>
    <section class="billing-section account view-state" data-state="editaccounts">
      <header>
<!-- Account Status Goes Here -->
</header>
      <div class="division accounts">
<!-- Account Form Goes Here -->
</div>
      <footer>
<!-- Edit Accounts Summary Goes Here -->
</footer>
    </section>
    <section class="billing-section account view-state header-only" data-state="paid">
      <header>
<!-- Account Status Goes Here -->
</header>
    </section>
  </sections>
</script>
      <script id="view-template-flow-billing-referral-section" type="text/html">
  <sections>
    <section class="billing-section referral-info view-state" data-state="initial">
      <header>
        <ins class="avatar">
</ins>
        <div class="text">
          <h3>
Referral Program</h3>
          <p>
Earn free months by referring your friends!</p>
        </div>
      </header>
      <div class="division">
        <p>
Earn more free months when you invite new subscribers either within Flow or by sending people your referral link to sign up.</p>
        <div class="link-and-share">
          <div class="referral-link">
<input class="referral-link-input" value="" readonly />
</div>
          <ul class="share">
            <li>
<a class="share-on-twitter-link" target="_blank">
<img src="/images/share-twitter.png" alt="Share on Twitter"/>
</a>
</li>
            <li>
<a class="share-on-facebook-link" target="_blank">
<img src="/images/share-facebook.png" alt="Share on Facebook"/>
</a>
</li>
          </ul>
        </div>
      </div>
    </section>
  </sections>
</script>
      <script id="view-template-quick-invite" type="text/html">
  <div class="quick-invite">
    <ins class="icon">
      <span>
</span>
    </ins>
    <div class="placeholder">
Invite People</div>
    <div class="field">
      <input class="quick-invite-field">
    </div>
  </div>
</script>
    <div id="pre-loaded-images" style="display: none !important;">
<img style="display: none;" src="../images/top.png">
<img style="display: none;" src="../images/top-black.png">
<img style="display: none;" src="../images/right.png">
<img style="display: none;" src="../images/bottom.png">
<img style="display: none;" src="../images/bottom-black.png">
<img style="display: none;" src="../images/bottom-grey.png">
<img style="display: none;" src="../images/bottom-light-blue.png">
<img style="display: none;" src="../images/left.png">
<img style="display: none;" src="../images/spinner-black-16.png">
<img style="display: none;" src="../images/spinner-black-24.png">
<img style="display: none;" src="../images/spinner-black-36.png">
<img style="display: none;" src="../images/spinner-blue-12.png">
<img style="display: none;" src="../images/spinner-blue-48.png">
<img style="display: none;" src="../images/spinner-white-12.png">
<img style="display: none;" src="../images/spinner-blue-12.png">
</div>
</body>
</html>
