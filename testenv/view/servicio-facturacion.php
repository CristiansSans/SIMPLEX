<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<script>
	var eyeFish_BUTTONS='<div class="eye-fish">'+
						'	<article class="breadcrumbs">'+
						'		<a href="javascript:void(0);">Principal</a>'+
						'		<div class="breadcrumb_divider"></div>'+
						'		<a class="current">Servicio Facturacion</a>'+
						'	</article>'+
						'</div>';

	Ext.onReady(function(){
		var hBrowser = (typeof window.innerHeight != 'undefined' ? window.innerHeight : document.body.offsetHeight)-Ext.get('main').getTop();

		Ext.fly('title-header').update('Facturacion'+eyeFish_BUTTONS, false);

		new Ext.TabPanel({
			id			: id,
			renderTo	: 'main-container',
			height		: hBrowser-50,
			tabPosition	: 'bottom',
			activeTab	: 0,
			defaults	: {autoScroll:true},
			items		: [
				{
					title		: 'Servicios sin facturar',
					closable	: false,
					layout		: 'fit',
					border		: false,
					autoScroll	: true,
					autoLoad	: {url : 'servicios-sin-facturar.php', scripts: true}
				},
				{
					title		: 'Facturas',
					closable	: false,
					layout		: 'fit',
					border		: false,
					autoScroll	: true,
					autoLoad	: {url : 'facturas.php', scripts: true}
				}
			]
		});
	});
</script>