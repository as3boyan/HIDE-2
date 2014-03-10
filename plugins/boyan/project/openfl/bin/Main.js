(function ($hx_exports) { "use strict";
var CreateOpenFLProject = function() { };
CreateOpenFLProject.__name__ = true;
CreateOpenFLProject.createOpenFLProject = function(params,path,onComplete) {
	var args = ["haxelib","run","openfl","create"].concat(params).join(" ");
	console.log(args);
	var OpenFLTools = js.Node.require("child_process").exec(args,{ cwd : path},function(error,stdout,stderr) {
		console.log(stderr);
	});
	OpenFLTools.on("close",function(code) {
		console.log("exit code: " + ("" + code));
		if(code == 0 && onComplete != null) onComplete();
	});
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
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
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		NewProjectDialog.getCategory("OpenFL",2).addItem("OpenFL Project",Main.createOpenFLProject,false);
		NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Extension",Main.createOpenFLExtension,false);
		var samples = ["ActuateExample","AddingAnimation","AddingText","DisplayingABitmap","HandlingKeyboardEvents","HandlingMouseEvent","HerokuShaders","PiratePig","PlayingSound","SimpleBox2D","SimpleOpenGLView"];
		var _g = 0;
		while(_g < samples.length) {
			var sample = samples[_g];
			++_g;
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem(sample,function(data) {
				Main.createOpenFLProject(data,true);
			},false,true);
		}
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.createOpenFLProject = function(data,sample) {
	if(sample == null) sample = false;
	var params;
	if(!sample) {
		var str = "";
		if(data.projectPackage != "") str = Std.string(data.projectPackage) + ".";
		params = ["project","\"" + str + Std.string(data.projectName) + "\""];
		if(data.projectCompany != "") params.push("\"" + Std.string(data.projectCompany) + "\"");
	} else params = [data.projectName];
	CreateOpenFLProject.createOpenFLProject(params,data.projectLocation,function() {
		var pathToProject = js.Node.require("path").join(data.projectLocation,data.projectName);
		Main.createProject(data);
		TabManager.openFileInNewTab(js.Node.require("path").join(pathToProject,"Source","Main.hx"));
	});
};
Main.createOpenFLExtension = function(data) {
	CreateOpenFLProject.createOpenFLProject(["extension",data.projectName],data.projectLocation,function() {
		Main.createProject(data);
	});
};
Main.createProject = function(data) {
	var pathToProject = js.Node.require("path").join(data.projectLocation,data.projectName);
	var project = new Project();
	project.name = data.projectName;
	project.projectPackage = data.projectPackage;
	project.company = data.projectCompany;
	project.license = data.projectLicense;
	project.url = data.projectURL;
	project.type = 1;
	project.openFLTarget = "flash";
	project.path = pathToProject;
	project.buildActionCommand = ["haxelib","run","openfl","build","\"%join%(%path%,project.xml)\"",project.openFLTarget].join(" ");
	project.runActionType = 2;
	project.runActionText = ["haxelib","run","openfl","run","\"%join%(%path%,project.xml)\"",project.openFLTarget].join(" ");
	ProjectAccess.currentProject = project;
	OpenFLTools.getParams(project.path,project.openFLTarget,function(stdout) {
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
		ProjectOptions.updateProjectOptions();
		var path = js.Node.require("path").join(pathToProject,"project.json");
		js.Browser.getLocalStorage().setItem("pathToLastProject",path);
		ProjectAccess.save(function() {
			FileTree.load(project.name,pathToProject);
		});
	});
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.__name__ = true;
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
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Browser = function() { };
js.Browser.__name__ = true;
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
js.Node.__name__ = true;
String.__name__ = true;
Array.__name__ = true;
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
Main.$name = "boyan.project.openfl";
Main.dependencies = ["boyan.bootstrap.new-project-dialog","boyan.bootstrap.tab-manager","boyan.bootstrap.file-tree","boyan.bootstrap.project-options","boyan.openfl.tools","boyan.management.project-access","boyan.codemirror.editor"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map