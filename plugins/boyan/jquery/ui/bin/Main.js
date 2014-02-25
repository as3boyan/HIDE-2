(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadJS(Main.$name,["bin/includes/js/jquery-ui-1.9.2.custom.min.js"],function() {
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/jquery-ui-1.9.2.custom.min.css"]);
}
Main.$name = "boyan.jquery.ui";
Main.dependencies = ["boyan.jquery.script"];
Main.main();
})();

//@ sourceMappingURL=Main.js.map