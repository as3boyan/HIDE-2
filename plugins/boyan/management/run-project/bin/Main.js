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
		BootstrapMenu.getMenu("Project",80).addMenuItem("Run",1,Main.runProject,"F5");
		BootstrapMenu.getMenu("Project").addMenuItem("Build",2,Main.buildProject,"F8");
		BootstrapMenu.getMenu("Project").addMenuItem("Set this hxml as project build file",3,Main.setHxmlAsProjectBuildFile);
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
Main.setHxmlAsProjectBuildFile = function() {
	var path = TabManager.getCurrentDocumentPath();
	var extname = js.Node.require("path").extname(path);
	var buildHxml = extname == ".hxml";
	if(buildHxml) {
		var project = ProjectAccess.currentProject;
		project.type = 2;
		project.main = js.Node.require("path").basename(path);
		project.path = js.Node.require("path").dirname(path);
		ProjectAccess.save();
		Alerts.showAlert("Done");
	} else Alerts.showAlert("Currently active document is not a hxml file");
};
Main.runProject = function() {
	Main.buildProject(function() {
		var _g = ProjectAccess.currentProject.runActionType;
		switch(_g) {
		case 0:
			nodejs.webkit.Shell.openExternal(ProjectAccess.currentProject.runActionText);
			break;
		case 1:
			var path = ProjectAccess.currentProject.runActionText;
			js.Node.require("fs").exists(path,function(exists) {
				if(!exists) path = js.Node.require("path").join(ProjectAccess.currentProject.path,path);
				nodejs.webkit.Shell.openItem(path);
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
		var path = TabManager.getCurrentDocumentPath();
		var extname = js.Node.require("path").extname(path);
		var buildHxml = extname == ".hxml";
		var dirname = js.Node.require("path").dirname(path);
		var filename = js.Node.require("path").basename(path);
		if(buildHxml || ProjectAccess.currentProject.type == 2) {
			var hxmlData;
			if(!buildHxml) {
				dirname = ProjectAccess.currentProject.path;
				filename = ProjectAccess.currentProject.main;
				var options = { };
				options.encoding = "utf8";
				js.Node.require("fs").readFile(js.Node.require("path").join(dirname,filename),options,function(err,data) {
					if(err == null) {
						hxmlData = data;
						Main.checkHxml(dirname,filename,hxmlData);
					} else console.log(err);
				});
			} else {
				hxmlData = CM.editor.getValue();
				Main.checkHxml(dirname,filename,hxmlData);
			}
		} else {
			var command = ProjectAccess.currentProject.buildActionCommand;
			command = Main.preprocessCommand(command);
			if(ProjectAccess.currentProject.type == 0) command = [command].concat(ProjectAccess.currentProject.args).join(" ");
			HaxeClient.buildProject(command,onComplete);
		}
	});
};
Main.checkHxml = function(dirname,filename,hxmlData) {
	var useCompilationServer = true;
	var startCommandLine = false;
	if(hxmlData != null) {
		if(hxmlData.indexOf("-cmd") != -1) startCommandLine = true;
		if(hxmlData.indexOf("-cpp") != -1) useCompilationServer = false;
	}
	Main.buildHxml(dirname,filename,useCompilationServer,startCommandLine);
};
Main.buildHxml = function(dirname,filename,useCompilationServer,startCommandLine) {
	if(startCommandLine == null) startCommandLine = false;
	if(useCompilationServer == null) useCompilationServer = true;
	var command = "";
	if(startCommandLine) {
		var _g = Utils.os;
		switch(_g) {
		case 0:
			command = "start";
			break;
		default:
			command = "bash";
		}
		command += " ";
	}
	var compilationServer = "";
	if(useCompilationServer) compilationServer = "--connect 6001";
	HaxeClient.buildProject(command + "haxe " + "--cwd " + dirname + " " + compilationServer + " " + filename);
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
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
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
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Shell = nodejs.webkit.$ui.Shell;
Main.$name = "boyan.management.run-project";
Main.dependencies = ["boyan.bootstrap.project-options","boyan.compilation.client","boyan.management.project-access","boyan.bootstrap.menu","boyan.bootstrap.tab-manager","boyan.bootstrap.alerts","boyan.utils","boyan.codemirror.editor"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map