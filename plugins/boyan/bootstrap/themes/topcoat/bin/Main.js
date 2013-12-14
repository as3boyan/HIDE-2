(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadCSS(Main.$name,["bin/css/topcoat-desktop-light.min.css"],function() {
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
};
Main.$name = "boyan.bootstrap.themes.topcoat";
Main.dependencies = ["boyan.bootstrap.script"];
Main.main();
})();

//# sourceMappingURL=Main.js.map