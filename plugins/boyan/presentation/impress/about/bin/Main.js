(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("Help").addMenuItem("About HIDE...",function() {
			return HIDE.openPageInNewWindow(Main.$name,"bin/index.html",{ toolbar : false});
		});
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.presentation.impress.about";
Main.dependencies = ["boyan.bootstrap.menu"];
Main.main();
})();

//# sourceMappingURL=Main.js.map