(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("Developer Tools",100).addMenuItem("Reload IDE",1,function() {
			HaxeServer.terminate();
			nodejs.webkit.Window.get().reloadIgnoringCache();
		},"Ctrl-Shift-R");
		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Compile plugins and reload IDE",2,function() {
			HaxeServer.terminate();
			HIDE.compilePlugins(function() {
				nodejs.webkit.Window.get().reloadIgnoringCache();
			},function(data) {
			});
		},"Shift-F5");
		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Console",3,function() {
			var $window = nodejs.webkit.Window.get();
			$window.showDevTools();
		});
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Menu = nodejs.webkit.$ui.Menu;
nodejs.webkit.MenuItem = nodejs.webkit.$ui.MenuItem;
nodejs.webkit.Window = nodejs.webkit.$ui.Window;
Main.$name = "boyan.developer-tools.hide";
Main.dependencies = ["boyan.bootstrap.menu","boyan.bootstrap.alerts","boyan.compilation.server"];
Main.main();
})();

//# sourceMappingURL=Main.js.map