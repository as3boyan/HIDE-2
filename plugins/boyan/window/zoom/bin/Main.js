(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		var $window = nodejs.webkit.Window.get();
		BootstrapMenu.getMenu("View").addMenuItem("Zoom In",2,function() {
			$window.zoomLevel += 1;
		},"Ctrl-Shift-+");
		BootstrapMenu.getMenu("View").addMenuItem("Zoom Out",3,function() {
			$window.zoomLevel -= 1;
		},"Ctrl-Shift--");
		BootstrapMenu.getMenu("View").addMenuItem("Reset",4,function() {
			$window.zoomLevel = 0;
		},"Ctrl-Shift-0");
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
Main.$name = "boyan.window.zoom";
Main.dependencies = ["boyan.bootstrap.menu"];
Main.main();
})();

//# sourceMappingURL=Main.js.map