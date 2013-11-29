(function ($hx_exports) { "use strict";
var IMap = function() { };
IMap.__name__ = true;
var haxe = {};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
};
var HIDE = $hx_exports.HIDE = function() { };
HIDE.__name__ = true;
HIDE.loadJS = function(name,urls,onLoad) {
	if(name != null) {
		var _g1 = 0;
		var _g = urls.length;
		while(_g1 < _g) {
			var i = _g1++;
			urls[i] = js.Node.require("path").join(HIDE.getPluginPath(name),urls[i]);
		}
	}
	HIDE.loadJSAsync(name,urls,onLoad);
};
HIDE.loadCSS = function(name,urls,onLoad) {
	var url;
	var _g1 = 0;
	var _g = urls.length;
	while(_g1 < _g) {
		var i = [_g1++];
		url = urls[i[0]];
		if(name != null) url = js.Node.require("path").join(HIDE.getPluginPath(name),url);
		var link;
		var _this = window.document;
		link = _this.createElement("link");
		link.href = url;
		link.type = "text/css";
		link.rel = "stylesheet";
		link.onload = (function(i) {
			return function(e) {
				HIDE.traceScriptLoadingInfo(name,url);
				if(i[0] == urls.length - 1 && onLoad != null) onLoad();
			};
		})(i);
		window.document.head.appendChild(link);
	}
};
HIDE.traceScriptLoadingInfo = function(name,url) {
	var str;
	if(name != null) str = "\n" + name + ":\n" + url + "\n"; else str = url + " loaded";
	console.log(str);
};
HIDE.getPluginPath = function(name) {
	var pathToPlugin = HIDE.pathToPlugins.get(name);
	if(pathToPlugin == null) console.log("HIDE can't find path for plugin: " + name + "\nPlease check that folder structure of plugin corresponds to it's 'name'");
	return pathToPlugin;
};
HIDE.waitForDependentPluginsToBeLoaded = function(name,plugins,onLoaded,callOnLoadWhenAtLeastOnePluginLoaded) {
	if(callOnLoadWhenAtLeastOnePluginLoaded == null) callOnLoadWhenAtLeastOnePluginLoaded = false;
	var data = { name : name, plugins : plugins, onLoaded : onLoaded, callOnLoadWhenAtLeastOnePluginLoaded : callOnLoadWhenAtLeastOnePluginLoaded};
	HIDE.requestedPluginsData.push(data);
	HIDE.checkRequiredPluginsData();
};
HIDE.notifyLoadingComplete = function(name) {
	HIDE.plugins.push(name);
	HIDE.checkRequiredPluginsData();
};
HIDE.checkRequiredPluginsData = function() {
	if(HIDE.requestedPluginsData.length > 0) {
		var pluginData;
		var j = 0;
		while(j < HIDE.requestedPluginsData.length) {
			pluginData = HIDE.requestedPluginsData[j];
			var pluginsLoaded;
			if(pluginData.callOnLoadWhenAtLeastOnePluginLoaded == false) pluginsLoaded = Lambda.foreach(pluginData.plugins,function(plugin) {
				return Lambda.has(HIDE.plugins,plugin);
			}); else pluginsLoaded = !Lambda.foreach(pluginData.plugins,function(plugin) {
				return !Lambda.has(HIDE.plugins,plugin);
			});
			if(pluginsLoaded) {
				HIDE.requestedPluginsData.splice(j,1);
				pluginData.onLoaded();
			} else j++;
		}
		if(Lambda.count(HIDE.pathToPlugins) == HIDE.plugins.length) {
			console.log("all plugins loaded");
			var delta = new Date().getTime() - Main.currentTime;
			console.log("Loading took: " + Std.string(delta) + " ms");
		}
	}
};
HIDE.loadJSAsync = function(name,urls,onLoad) {
	var script;
	var _this = window.document;
	script = _this.createElement("script");
	script.src = urls.splice(0,1)[0];
	script.onload = function(e) {
		HIDE.traceScriptLoadingInfo(name,script.src);
		if(urls.length > 0) HIDE.loadJSAsync(name,urls,onLoad); else if(onLoad != null) onLoad();
	};
	window.document.body.appendChild(script);
};
HIDE.registerHotkey = function(hotkey,functionName) {
};
HIDE.registerHotkeyByKeyCode = function(code,functionName) {
	window.addEventListener("keyup",function(e) {
		if(e.keyCode == code) {
		}
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
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = true;
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
};
Lambda.foreach = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
};
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	js.Node.require("nw.gui").Window.get().showDevTools();
	window.addEventListener("load",function(e) {
		js.Node.require("nw.gui").Window.get().show();
		Main.currentTime = new Date().getTime();
		Main.loadPlugins();
	});
};
Main.loadPlugins = function() {
	var pathToPlugins = js.Node.require("path").join("..","plugins");
	Main.readDir(pathToPlugins,"",function(path,pathToPlugin) {
		var pluginName = StringTools.replace(pathToPlugin,js.Node.require("path").sep,".");
		var relativePathToPlugin = js.Node.require("path").join(path,pathToPlugin);
		HIDE.pathToPlugins.set(pluginName,relativePathToPlugin);
		var absolutePathToPlugin = js.Node.require("path").resolve(relativePathToPlugin);
		Main.compilePlugin(pluginName,absolutePathToPlugin,Main.loadPlugin);
	});
	haxe.Timer.delay(function() {
		if(HIDE.requestedPluginsData.length > 0) {
			console.log("still not loaded plugins: ");
			var _g = 0;
			var _g1 = HIDE.requestedPluginsData;
			while(_g < _g1.length) {
				var pluginData = _g1[_g];
				++_g;
				console.log(pluginData.name + ": can't load plugin, required plugins are not found");
				console.log(pluginData.plugins);
			}
		}
	},10000);
};
Main.readDir = function(path,pathToPlugin,onLoad) {
	var pathToFolder;
	js.Node.require("fs").readdir(js.Node.require("path").join(path,pathToPlugin),function(error,folders) {
		if(error != null) console.log(error); else {
			var _g = 0;
			while(_g < folders.length) {
				var item = [folders[_g]];
				++_g;
				if(item[0] != "inactive") {
					pathToFolder = js.Node.require("path").join(path,pathToPlugin,item[0]);
					js.Node.require("fs").stat(pathToFolder,(function(item) {
						return function(error1,stat) {
							if(error1 != null) console.log(error1); else {
								var pluginName = StringTools.replace(pathToPlugin,js.Node.require("path").sep,".");
								if(stat.isDirectory()) Main.readDir(path,js.Node.require("path").join(pathToPlugin,item[0]),onLoad); else if(item[0] == "plugin.hxml" && !Lambda.has(HIDE.inactivePlugins,pluginName)) {
									console.log("    - pushd " + StringTools.replace(js.Node.require("path").join("plugins",pathToPlugin),js.Node.require("path").sep,"/") + " && haxe plugin.hxml && popd");
									onLoad(path,pathToPlugin);
									return;
								}
							}
						};
					})(item));
				}
			}
		}
	});
};
Main.loadPlugin = function(pathToPlugin) {
	var pathToMain = js.Node.require("path").join(pathToPlugin,"bin","Main.js");
	js.Node.require("fs").exists(pathToMain,function(exists) {
		if(exists) HIDE.loadJS(null,[pathToMain]); else console.log(pathToMain + " is not found/nPlease compile " + pathToPlugin + " plugin");
	});
};
Main.compilePlugin = function(name,pathToPlugin,onSuccess) {
	var haxeCompilerProcess = js.Node.require("child_process").spawn("haxe",["--cwd",pathToPlugin,"plugin.hxml"]);
	haxeCompilerProcess.stderr.on("data",function(data) {
		console.log(pathToPlugin + " stderr: " + data);
	});
	haxeCompilerProcess.on("close",function(code) {
		if(code == 0) onSuccess(pathToPlugin); else console.log("can't load " + name + " plugin, compilation failed");
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
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = true;
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe.Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
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
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.__name__ = true;
Array.__name__ = true;
Date.__name__ = ["Date"];
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
HIDE.plugins = new Array();
HIDE.pathToPlugins = new haxe.ds.StringMap();
HIDE.inactivePlugins = ["boyan.ace.editor","boyan.jquery.split-pane"];
HIDE.requestedPluginsData = new Array();
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=HIDE.js.map