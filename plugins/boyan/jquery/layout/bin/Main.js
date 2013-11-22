(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadJS(Main.$name,["bin/includes/js/jquery.layout-latest.min.js"],function() {
			HIDE.plugins.push(Main.$name);
		});
	});
};
Main.$name = "boyan.jquery.layout";
Main.dependencies = ["boyan.jquery.ui"];
Main.main();
})();

//# sourceMappingURL=Main.js.map