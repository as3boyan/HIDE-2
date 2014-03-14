(function ($hx_exports) { "use strict";
var Bootbox = $hx_exports.Bootbox = function() { };
Bootbox.prompt = function(question,defaultValue,onClick) {
	var bootboxStatic = bootbox;
	bootboxStatic.prompt({ title : question, value : defaultValue, callback : function(result) {
		if(result != null) onClick(result);
	}});
};
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadJS(Main.$name,["bin/js/bootbox.min.js"],function() {
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
};
Main.$name = "boyan.bootstrap.bootbox";
Main.dependencies = ["boyan.bootstrap.script"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map