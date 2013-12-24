(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		NewProjectDialog.getCategory("Haxe").getCategory("HIDE").addItem("HIDE plugin");
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.project.hide.plugin";
Main.dependencies = ["boyan.bootstrap.new-project-dialog"];
Main.main();
})();

//# sourceMappingURL=Main.js.map