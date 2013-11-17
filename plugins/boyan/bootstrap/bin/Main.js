(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.dependencies,Main.loadBootstrap);
	HIDE.loadCSS("../plugins/boyan/bootstrap/bin/includes/css/bootstrap.min.css");
	HIDE.loadCSS("../plugins/boyan/bootstrap/bin/includes/css/bootstrap-glyphicons.css");
};
Main.loadBootstrap = function() {
	HIDE.loadJS("../plugins/boyan/bootstrap/bin/includes/js/bootstrap/bootstrap.min.js",function() {
		HIDE.plugins.push(Main.$name);
	});
};
Main.$name = "boyan.bootstrap";
Main.dependencies = ["boyan.jquery"];
Main.main();
})();

//# sourceMappingURL=Main.js.map