(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.dependencies,Main.loadBootstrap);
	HIDE.loadCSS(Main.$name,["bin/includes/css/bootstrap.min.css"]);
	HIDE.loadCSS(Main.$name,["bin/includes/css/bootstrap-glyphicons.css"]);
};
Main.loadBootstrap = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/bootstrap/bootstrap.min.js"],function() {
		HIDE.plugins.push(Main.$name);
	});
};
Main.$name = "boyan.bootstrap.script";
Main.dependencies = ["boyan.jquery.script"];
Main.main();
})();

//# sourceMappingURL=Main.js.map