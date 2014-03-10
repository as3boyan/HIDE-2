(function ($hx_exports) { "use strict";
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw "EReg::matched";
	}
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
		BootstrapMenu.getMenu("Project",80).addMenuItem("Run",1,Main.runProject,"F5",116);
		BootstrapMenu.getMenu("Project").addMenuItem("Build",2,Main.buildProject,"F8",119);
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
Main.runProject = function() {
	Main.buildProject(function() {
		var gui = js.Node.require("nw.gui");
		var _g = ProjectAccess.currentProject.runActionType;
		switch(_g) {
		case 0:
			gui.Shell.openExternal(ProjectAccess.currentProject.runActionText);
			break;
		case 1:
			var path = ProjectAccess.currentProject.runActionText;
			js.Node.require("fs").exists(path,function(exists) {
				if(!exists) path = js.Node.require("path").join(ProjectAccess.currentProject.path,path);
				gui.Shell.openItem(path);
			});
			break;
		case 2:
			HaxeClient.buildProject(Main.preprocessCommand(ProjectAccess.currentProject.runActionText));
			break;
		default:
		}
	});
};
Main.buildProject = function(onComplete) {
	if(ProjectAccess.currentProject.path == null) Alerts.showAlert("Please open or create project first!"); else TabManager.saveAll(function() {
		var command = ProjectAccess.currentProject.buildActionCommand;
		command = Main.preprocessCommand(command);
		if(ProjectAccess.currentProject.type == 0) command = [command].concat(ProjectAccess.currentProject.args).join(" ");
		HaxeClient.buildProject(command,onComplete);
	});
};
Main.preprocessCommand = function(command) {
	var processedCommand = command;
	processedCommand = StringTools.replace(processedCommand,"%path%",ProjectAccess.currentProject.path);
	var ereg = new EReg("%join%[(](.+)[)]","");
	if(ereg.match(processedCommand)) {
		var matchedString = ereg.matched(1);
		var $arguments = matchedString.split(",");
		processedCommand = StringTools.replace(processedCommand,ereg.matched(0),js.Node.require("path").join($arguments[0],$arguments[1]));
	}
	return processedCommand;
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
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
Main.$name = "boyan.management.run-project";
Main.dependencies = ["boyan.bootstrap.project-options","boyan.compilation.client","boyan.management.project-access","boyan.bootstrap.menu","boyan.bootstrap.tab-manager","boyan.bootstrap.alerts"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map