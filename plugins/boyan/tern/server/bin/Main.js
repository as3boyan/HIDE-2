(function () { "use strict";
var Completion = function() { }
Completion.__name__ = true;
Completion.registerHandlers = function() {
	new $(js.Browser.document).on("getCompletion",null,function(event,data) {
		if(CM.editor.state.completionActive != null && CM.editor.state.completionActive.widget != null) {
			data.data.completions = Completion.completions;
			new $(js.Browser.document).triggerHandler("processHint",data);
		} else {
			console.log("get Haxe completion");
			var projectArguments = ProjectAccess.currentProject.args;
			projectArguments.push("--display");
			projectArguments.push(js.Node.require("path").basename(TabManager.getCurrentDocumentPath()) + "@" + Std.string(data.doc.indexFromPos(data.from)));
			console.log(projectArguments);
		}
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
		HIDE.loadJS(Main.$name,["bin/includes/acorn/acorn.js","bin/includes/acorn/acorn_loose.js","bin/includes/acorn/util/walk.js","bin/includes/tern/doc/demo/polyfill.js","bin/includes/tern/lib/signal.js","bin/includes/tern/lib/tern.js","bin/includes/tern/lib/def.js","bin/includes/tern/lib/comment.js","bin/includes/tern/lib/infer.js","bin/includes/tern/plugin/doc_comment.js"],function() {
			var server = new CodeMirror.TernServer({ defs : [], plugins : { doc_comment : true}});
			CM.editor.on("cursorActivity",function(cm) {
				server.updateArgHints(cm);
			});
			var keyMap = { 'Ctrl-Space' : function(cm) {
				server.complete(cm);
			}, 'Ctrl-Q' : function(cm) {
				server.rename(cm);
			}};
			CM.editor.setOption("extraKeys",keyMap);
			TS.server = server;
			Completion.registerHandlers();
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
var TS = function() { }
$hxExpose(TS, "TS");
TS.__name__ = true;
var js = {}
js.Boot = function() { }
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
				var _g1 = 2, _g = o.length;
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
		for( var k in o ) { ;
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
}
js.Browser = function() { }
js.Browser.__name__ = true;
js.Node = function() { }
js.Node.__name__ = true;
String.__name__ = true;
Array.__name__ = true;
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
Main.$name = "boyan.tern.server";
Main.dependencies = ["boyan.codemirror.editor","boyan.bootstrap.tab-manager","boyan.jquery.xml2json","boyan.management.project-access","boyan.compilation.client"];
js.Browser.document = typeof window != "undefined" ? window.document : null;
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