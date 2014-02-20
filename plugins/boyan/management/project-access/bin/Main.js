(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.notifyLoadingComplete(Main.$name);
	});
}
var Project = function() {
	this.customArgs = false;
	this.args = [];
};
$hxExpose(Project, "Project");
var ProjectAccess = function() { }
$hxExpose(ProjectAccess, "ProjectAccess");
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
function $hxExpose(src, path) {
	var o = typeof window != "undefined" ? window : exports;
	var parts = path.split(".");
	for(var ii = 0; ii < parts.length-1; ++ii) {
		var p = parts[ii];
		if(typeof o[p] == "undefined") o[p] = {};
		o = o[p];
	}
	o[parts[parts.length-1]] = src;
}
})();

//@ sourceMappingURL=Main.js.map