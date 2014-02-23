(function ($hx_exports) { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
var Project = $hx_exports.Project = function() {
	this.customArgs = false;
	this.args = [];
};
var ProjectAccess = $hx_exports.ProjectAccess = function() { };
Main.$name = "boyan.management.project-access";
Main.dependencies = [];
Project.HAXE = 0;
Project.OPENFL = 1;
Project.HXML = 2;
Project.FLASH = 0;
Project.JAVASCRIPT = 1;
Project.PHP = 2;
Project.CPP = 3;
Project.JAVA = 4;
Project.CSHARP = 5;
Project.NEKO = 6;
ProjectAccess.currentProject = new Project();
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map