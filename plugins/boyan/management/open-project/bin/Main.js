(function () { "use strict";
var HxOverrides = function() { }
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
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		BootstrapMenu.getMenu("File").addMenuItem("Open...",2,OpenProject.openProject,"Ctrl-O",79,true,false,false);
	});
	HIDE.notifyLoadingComplete(Main.$name);
}
var OpenProject = function() { }
OpenProject.openProject = function() {
	FileDialog.openFile(function(path) {
		var filename = js.Node.require("path").basename(path);
		switch(filename) {
		case "project.hide":
			break;
		case "project.xml":
			break;
		default:
			var extension = js.Node.require("path").extname(filename);
			switch(extension) {
			case ".hxml":
				break;
			default:
			}
		}
	});
}
var Std = function() { }
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
var js = {}
js.Node = function() { }
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
Main.dependencies = ["boyan.bootstrap.menu","boyan.window.file-dialog"];
Main.main();
})();

//@ sourceMappingURL=Main.js.map