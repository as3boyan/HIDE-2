(function ($hx_exports) { "use strict";
var HxOverrides = function() { };
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("File").addMenuItem("Open...",2,OpenProject.openProject,"Ctrl-O");
		OpenProject.searchForLastProject();
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
var OpenProject = function() { };
OpenProject.openProject = function(pathToProject) {
	if(pathToProject == null) FileDialog.openFile(OpenProject.parseProject); else OpenProject.checkIfFileExists(pathToProject);
};
OpenProject.checkIfFileExists = function(path) {
	js.Node.require("fs").exists(path,function(exists) {
		if(exists) OpenProject.parseProject(path); else console.log("previously opened project: " + path + " was not found");
	});
};
OpenProject.parseProject = function(path) {
	console.log("open project: ");
	console.log(path);
	var filename = js.Node.require("path").basename(path);
	switch(filename) {
	case "project.json":
		var options = { };
		options.encoding = "utf8";
		js.Node.require("fs").readFile(path,options,function(error,data) {
			var pathToProject = js.Node.require("path").dirname(path);
			ProjectAccess.currentProject = js.Node.parse(data);
			ProjectAccess.currentProject.path = pathToProject;
			ProjectOptions.updateProjectOptions();
			FileTree.load(ProjectAccess.currentProject.name,pathToProject);
			js.Browser.getLocalStorage().setItem("pathToLastProject",path);
		});
		break;
	case "project.xml":case "application.xml":
		var pathToProject1 = js.Node.require("path").dirname(path);
		var project = new Project();
		var pos = pathToProject1.lastIndexOf(js.Node.require("path").sep);
		project.name = HxOverrides.substr(pathToProject1,pos,null);
		project.type = 1;
		project.openFLTarget = "flash";
		project.path = pathToProject1;
		OpenFLTools.getParams(pathToProject1,project.openFLTarget,function(stdout) {
			var args = [];
			var currentLine;
			var _g = 0;
			var _g1 = stdout.split("\n");
			while(_g < _g1.length) {
				var line = _g1[_g];
				++_g;
				currentLine = StringTools.trim(line);
				if(!StringTools.startsWith(currentLine,"#")) args.push(currentLine);
			}
			project.args = args;
			var pathToProjectHide = js.Node.require("path").join(pathToProject1,"project.json");
			ProjectAccess.currentProject = project;
			ProjectOptions.updateProjectOptions();
			ProjectAccess.save(function() {
				FileTree.load(project.name,pathToProject1);
			});
			js.Browser.getLocalStorage().setItem("pathToLastProject",pathToProjectHide);
		});
		break;
	default:
		var extension = js.Node.require("path").extname(filename);
		switch(extension) {
		case ".hxml":
			var pathToProject2 = js.Node.require("path").dirname(path);
			var project1 = new Project();
			var pos1 = pathToProject2.lastIndexOf(js.Node.require("path").sep);
			project1.name = HxOverrides.substr(pathToProject2,pos1,null);
			project1.type = 2;
			project1.path = pathToProject2;
			project1.main = js.Node.require("path").basename(path);
			ProjectAccess.currentProject = project1;
			ProjectOptions.updateProjectOptions();
			FileTree.load(project1.name,pathToProject2);
			js.Browser.getLocalStorage().setItem("pathToLastProject",path);
			break;
		default:
		}
		TabManager.openFileInNewTab(path);
	}
};
OpenProject.searchForLastProject = function() {
	var pathToLastProject = js.Browser.getLocalStorage().getItem("pathToLastProject");
	if(pathToLastProject != null) OpenProject.openProject(pathToLastProject);
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var js = {};
js.Browser = function() { };
js.Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
};
js.Node = function() { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
var module, setImmediate, clearImmediate;
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
var version = HxOverrides.substr(js.Node.process.version,1,null).split(".").map(Std.parseInt);
if(version[0] > 0 || version[1] >= 9) {
	js.Node.setImmediate = setImmediate;
	js.Node.clearImmediate = clearImmediate;
}
Main.$name = "boyan.management.open-project";
Main.dependencies = ["boyan.bootstrap.menu","boyan.window.file-dialog","boyan.management.project-access","boyan.bootstrap.project-options","boyan.bootstrap.file-tree","boyan.bootstrap.tab-manager","boyan.openfl.tools","boyan.codemirror.editor"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map