(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("Help",110).addMenuItem("How to develop plugins for HIDE",1,function() {
			return HIDE.openPageInNewWindow(Main.$name,"bin/index.html",{ toolbar : false});
		});
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.presentation.reveal.plugin-development-tutorial";
Main.dependencies = ["boyan.bootstrap.menu"];
Main.main();
})();

//# sourceMappingURL=Main.js.map