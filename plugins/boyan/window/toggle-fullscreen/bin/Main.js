(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("View",2).addMenuItem("Toggle Fullscreen",1,function() {
			nodejs.webkit.Window.get().toggleFullscreen();
		},"F11");
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
Main.$name = "boyan.window.toggle-fullscreen";
Main.dependencies = ["boyan.bootstrap.menu"];
Main.main();
})();

//# sourceMappingURL=Main.js.map