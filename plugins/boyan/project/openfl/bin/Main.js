(function () { "use strict";
var CreateOpenFLProject = function() { };
CreateOpenFLProject.__name__ = true;
CreateOpenFLProject.createOpenFLProject = function(params) {
	var OpenFLTools = js.Node.require("child_process").spawn("haxelib",["run","openfl","create"].concat(params));
	var log = "";
	OpenFLTools.stderr.setEncoding("utf8");
	OpenFLTools.stderr.on("data",function(data) {
		var str = data.toString();
		log += str;
	});
	OpenFLTools.on("close",function(code) {
		console.log("exit code: " + Std.string(code));
		console.log(log);
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
			var sample = [samples[_g]];
			++_g;
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem(sample[0],(function(sample) {
				return function(data) {
					Main.createOpenFLProject([sample[0]]);
				};
			})(sample),false,true);
		}
	});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.createOpenFLProject = function(data) {
	var str = "";
	if(data.projectPackage != "") str = Std.string(data.projectPackage) + ".";
	var params = ["project",str + Std.string(data.projectName.value)];
	if(data.projectCompany != "") params.push(data.projectCompany);
	CreateOpenFLProject.createOpenFLProject(params);
};
Main.createOpenFLExtension = function(data) {
	CreateOpenFLProject.createOpenFLProject(["extension",data.projectName]);
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
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
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
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
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
Main.dependencies = ["boyan.bootstrap.new-project-dialog"];
Main.main();
})();

//# sourceMappingURL=Main.js.map