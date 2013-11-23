(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,Main.loadBootstrap);
	HIDE.loadCSS(Main.$name,["bin/includes/css/bootstrap.min.css"]);
	HIDE.loadCSS(Main.$name,["bin/includes/css/bootstrap-glyphicons.css"]);
};
Main.loadBootstrap = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/bootstrap.min.js"],function() {
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
Main.$name = "boyan.bootstrap.script";
Main.dependencies = ["boyan.jquery.script"];
Main.main();
})();

//# sourceMappingURL=Main.js.map