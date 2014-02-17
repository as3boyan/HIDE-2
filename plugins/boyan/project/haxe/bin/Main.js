(function () { "use strict";
var FileTools = function() { }
FileTools.__name__ = true;
FileTools.createDirectoryRecursively = function(path,folderPath,onCreated) {
	var fullPath = js.Node.require("path").join(path,folderPath[0]);
	FileTools.createDirectory(fullPath,function() {
		folderPath.splice(0,1);
		if(folderPath.length > 0) FileTools.createDirectoryRecursively(fullPath,folderPath,onCreated); else onCreated();
	});
}
FileTools.createDirectory = function(path,onCreated) {
	js.Node.require("fs").mkdir(path,null,function(error) {
		if(error != null) console.log(error);
		if(onCreated != null) onCreated();
	});
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
var Main = function() { }
Main.__name__ = true;
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
}
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
}
var Std = function() { }
Std.__name__ = true;
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
js.Node = function() { }
js.Node.__name__ = true;
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
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

//@ sourceMappingURL=Main.js.map