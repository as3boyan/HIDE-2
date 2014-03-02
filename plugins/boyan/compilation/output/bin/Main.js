(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.loadCSS(Main.$name,["bin/includes/css/output.css"]);
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		var output = js.Browser.document.createElement("textarea");
		output.id = "output";
		output.readOnly = true;
		Splitpane.components[2].appendChild(output);
	},true);
	HIDE.notifyLoadingComplete(Main.$name);
}
var js = {}
js.Browser = function() { }
Main.$name = "boyan.compilation.output";
Main.dependencies = ["boyan.jquery.layout","boyan.jquery.split-pane","boyan.window.splitpane"];
js.Browser.document = typeof window != "undefined" ? window.document : null;
Main.main();
})();

//@ sourceMappingURL=Main.js.map