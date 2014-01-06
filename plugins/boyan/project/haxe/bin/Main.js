(function () { "use strict";
var FileTools = function() { };
FileTools.createDirectoryRecursively = function(path,folderPath,onCreated) {
	var fullPath = js.Node.require("path").join(path,folderPath[0]);
	FileTools.createDirectory(fullPath,function() {
		folderPath.splice(0,1);
		if(folderPath.length > 0) FileTools.createDirectoryRecursively(fullPath,folderPath,onCreated); else onCreated();
	});
};
FileTools.createDirectory = function(path,onCreated) {
	js.Node.require("fs").mkdir(path,null,function(error) {
		if(error != null) console.log(error);
		if(onCreated != null) onCreated();
	});
};
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
		NewProjectDialog.getCategory("Haxe",1).addItem("Flash Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").addItem("Neko Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").addItem("PHP Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").addItem("C++ Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").addItem("Java Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").addItem("C# Project",Main.createHaxeProject);
		NewProjectDialog.getCategory("Haxe").select();
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.createHaxeProject = function(data) {
	FileTools.createDirectoryRecursively(data.projectLocation,[data.projectName,"src"],function() {
		var pathToMain = data.projectLocation;
		if(data.createDirectory) js.Node.require("path").join(pathToMain,data.projectName);
		pathToMain = js.Node.require("path").join(pathToMain,"src","Main.hx");
		var code = "package ;\n\nclass Main\n{\n    static public function main()\n    {\n        \n    }\n}";
		js.Node.require("fs").writeFile(pathToMain,code,null,function(error) {
			if(error != null) console.log(error);
			TabManager.openFileInNewTab(pathToMain);
		});
	});
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var js = {};
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
Main.$name = "boyan.project.haxe";
Main.dependencies = ["boyan.bootstrap.new-project-dialog","boyan.bootstrap.tab-manager"];
Main.main();
})();

//# sourceMappingURL=Main.js.map