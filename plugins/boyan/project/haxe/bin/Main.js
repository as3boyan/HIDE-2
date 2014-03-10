(function ($hx_exports) { "use strict";
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
		NewProjectDialog.getCategory("Haxe",1).addItem("Flash Project",Main.createFlashProject);
		NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project",Main.createJavaScriptProject);
		NewProjectDialog.getCategory("Haxe").addItem("Neko Project",Main.createNekoProject);
		NewProjectDialog.getCategory("Haxe").addItem("PHP Project",Main.createPhpProject);
		NewProjectDialog.getCategory("Haxe").addItem("C++ Project",Main.createCppProject);
		NewProjectDialog.getCategory("Haxe").addItem("Java Project",Main.createJavaProject);
		NewProjectDialog.getCategory("Haxe").addItem("C# Project",Main.createCSharpProject);
		HIDE.readFile(Main.$name,"templates/Main.hx",function(data) {
			window.console.warn(data == "");
			Main.code = data;
			HIDE.notifyLoadingComplete(Main.$name);
		});
		HIDE.readFile(Main.$name,"templates/index.html",function(data1) {
			Main.indexPageCode = data1;
		});
	});
};
Main.createCSharpProject = function(data) {
	Main.createHaxeProject(data,5);
};
Main.createJavaProject = function(data) {
	Main.createHaxeProject(data,4);
};
Main.createCppProject = function(data) {
	Main.createHaxeProject(data,3);
};
Main.createPhpProject = function(data) {
	Main.createHaxeProject(data,2);
};
Main.createNekoProject = function(data) {
	Main.createHaxeProject(data,6);
};
Main.createFlashProject = function(data) {
	Main.createHaxeProject(data,0);
};
Main.createJavaScriptProject = function(data) {
	Main.createHaxeProject(data,1);
};
Main.createHaxeProject = function(data,target) {
	FileTools.createDirectoryRecursively(data.projectLocation,[data.projectName,"src"],function() {
		var pathToProject = data.projectLocation;
		if(data.createDirectory) pathToProject = js.Node.require("path").join(pathToProject,data.projectName);
		var pathToMain = pathToProject;
		pathToMain = js.Node.require("path").join(pathToMain,"src","Main.hx");
		js.Node.require("fs").writeFile(pathToMain,Main.code,null,function(error) {
			if(error != null) console.log(error);
			js.Node.require("fs").exists(pathToMain,function(exists) {
				if(exists) TabManager.openFileInNewTab(pathToMain); else console.log(pathToMain + " file was not generated");
			});
		});
		var project = new Project();
		project.name = data.projectName;
		project.projectPackage = data.projectPackage;
		project.company = data.projectCompany;
		project.license = data.projectLicense;
		project.url = data.projectURL;
		project.type = 0;
		project.target = target;
		project.path = pathToProject;
		project.buildActionCommand = ["haxe","--connect","6001","--cwd","\"%path%\""].join(" ");
		var pathToBin = js.Node.require("path").join(pathToProject,"bin");
		js.Node.require("fs").mkdir(pathToBin,null,function(error1) {
			var args = "-cp src\n-main Main\n";
			var _g = project.target;
			switch(_g) {
			case 0:
				var pathToFile = "bin/" + project.name + ".swf";
				args += "-swf " + pathToFile + "\n";
				project.runActionType = 1;
				project.runActionText = pathToFile;
				break;
			case 1:
				var pathToFile1 = "bin/" + project.name + ".js";
				args += "-js " + pathToFile1 + "\n";
				var updatedPageCode = StringTools.replace(Main.indexPageCode,"::title::",project.name);
				updatedPageCode = StringTools.replace(updatedPageCode,"::script::",project.name + ".js");
				var pathToWebPage = js.Node.require("path").join(pathToBin,"index.html");
				js.Node.require("fs").writeFile(pathToWebPage,updatedPageCode,"utf8",function(error2) {
				});
				project.runActionType = 1;
				project.runActionText = js.Node.require("path").join("bin","index.html");
				break;
			case 6:
				var pathToFile2 = "bin/" + project.name + ".n";
				args += "-neko " + pathToFile2 + "\n";
				project.runActionType = 2;
				project.runActionText = "neko " + js.Node.require("path").join(project.path,pathToFile2);
				break;
			case 2:
				args += "-php " + "bin/" + project.name + ".php\n";
				break;
			case 3:
				var pathToFile3 = "bin/" + project.name + ".exe";
				args += "-cpp " + pathToFile3 + "\n";
				project.runActionType = 2;
				project.runActionText = js.Node.require("path").join(project.path,pathToFile3);
				break;
			case 4:
				args += "-java " + "bin/" + project.name + ".jar\n";
				break;
			case 5:
				args += "-cs " + "bin/" + project.name + ".exe\n";
				break;
			default:
			}
			args += "-debug\n -dce full";
			project.args = args.split("\n");
			var path = js.Node.require("path").join(pathToProject,"project.json");
			js.Browser.getLocalStorage().setItem("pathToLastProject",path);
			ProjectAccess.currentProject = project;
			ProjectAccess.save(function() {
				FileTree.load(project.name,pathToProject);
			});
			ProjectOptions.updateProjectOptions();
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
var StringTools = function() { };
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
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
Main.$name = "boyan.project.haxe";
Main.dependencies = ["boyan.bootstrap.new-project-dialog","boyan.bootstrap.tab-manager","boyan.bootstrap.project-options","boyan.bootstrap.file-tree","boyan.management.project-access","boyan.codemirror.editor"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map