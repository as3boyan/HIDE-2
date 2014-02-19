(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("Project",80).addMenuItem("Run",1,function() {
		},"F5",116);
		BootstrapMenu.getMenu("Project").addMenuItem("Build",1,function() {
		},"F8",119);
		HIDE.notifyLoadingComplete(Main.$name);
	});
}
Main.$name = "boyan.management.run-project";
Main.dependencies = ["boyan.bootstrap.project-options"];
Main.main();
})();

//@ sourceMappingURL=Main.js.map