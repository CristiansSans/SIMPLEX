Ext.Loader.setConfig({
	enabled	: true,
	paths	: {
		simplex	: "app" //<-Es el Nombre del Name Space Principal
	}
});

var splashscreen;

Ext.onReady(function() {
    splashscreen = Ext.getBody().mask('Cargando componentes', 'splashscreen');
    splashscreen.addCls('splashscreen');

    Ext.DomHelper.insertFirst(Ext.query('.x-mask-msg')[0], {
        cls: 'x-splash-icon'
    });
});
		
Ext.application({  
        name        : "simplex", 
		launch      : function(){
			var task = function (delay) {
				Ext.create('Ext.util.DelayedTask', function () {
					splashscreen.fadeOut({
						duration	: delay,
						remove		:true
					});			
					
					splashscreen.next().fadeOut({
						duration: delay,
						remove:true,
						listeners: {
							afteranimate: function() {
								Ext.getBody().unmask();
							}
						}
					});
					
					Ext.create("simplex.view.viewport");
				}).delay(delay);
			};

			task(2000);
		},
		autoCreateViewport: false
});  
