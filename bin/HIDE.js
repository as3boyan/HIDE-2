(function ($hx_exports) { "use strict";
var IMap = function() { };
var haxe = {};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
};
var HIDE = $hx_exports.HIDE = function() { };
HIDE.loadJS = function(name,url,onLoad) {
	if(name != null) url = js.Node.require("path").join(HIDE.pathToPlugins.get(name),url);
	var script;
	var _this = window.document;
	script = _this.createElement("script");
	script.src = url;
	script.onload = function(e) {
		console.log(url + " loaded");
		if(onLoad != null) onLoad();
	};
	window.document.head.appendChild(script);
};
HIDE.loadCSS = function(name,url) {
	if(name != null) url = js.Node.require("path").join(HIDE.pathToPlugins.get(name),url);
	var link;
	var _this = window.document;
	link = _this.createElement("link");
	link.href = url;
	link.type = "text/css";
	link.rel = "stylesheet";
	window.document.head.appendChild(link);
};
HIDE.waitForDependentPluginsToBeLoaded = function(plugins,onLoaded) {
	var time = 0;
	var timer = new haxe.Timer(100);
	timer.run = function() {
		var pluginsLoaded = Lambda.foreach(plugins,function(plugin) {
			return Lambda.has(HIDE.plugins,plugin);
		});
		if(pluginsLoaded) {
			onLoaded();
			timer.stop();
		} else if(time < 3000) time += 100; else {
			console.log("can't load plugin, required plugins is not found");
			timer.stop();
		}
	};
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
var Main = function() { };
Main.main = function() {
	js.Node.require("nw.gui").Window.get().showDevTools();
	window.onload = function(e) {
		js.Node.require("nw.gui").Window.get().show();
		Main.loadPlugins();
	};
};
Main.loadPlugins = function() {
	var pathToPlugins = js.Node.require("path").join("..","plugins");
	Main.readDir(pathToPlugins,"",function(path,pathToPlugin) {
		var pluginName = StringTools.replace(pathToPlugin,js.Node.require("path").sep,".");
		var relativePathToPlugin = js.Node.require("path").join(path,pathToPlugin);
		HIDE.pathToPlugins.set(pluginName,relativePathToPlugin);
		Main.compilePlugin(pluginName,js.Node.require("path").resolve(relativePathToPlugin),Main.loadPlugin);
	});
};
Main.readDir = function(path,pathToPlugin,onLoad) {
	var pathToFolder;
	js.Node.require("fs").readdir(js.Node.require("path").join(path,pathToPlugin),function(error,folders) {
		if(error != null) console.log(error); else {
			var _g = 0;
			while(_g < folders.length) {
				var item = [folders[_g]];
				++_g;
				pathToFolder = js.Node.require("path").join(path,pathToPlugin,item[0]);
				js.Node.require("fs").stat(pathToFolder,(function(item) {
					return function(error1,stat) {
						if(error1 != null) console.log(error1); else if(stat.isDirectory()) Main.readDir(path,js.Node.require("path").join(pathToPlugin,item[0]),onLoad); else if(item[0] == "plugin.hxml") {
							onLoad(path,pathToPlugin);
							return;
						}
					};
				})(item));
			}
		}
	});
};
Main.loadPlugin = function(pathToPlugin) {
	var pathToMain = js.Node.require("path").join(pathToPlugin,"bin","Main.js");
	HIDE.loadJS(null,pathToMain);
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
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
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
js.Node = function() { };
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
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
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=HIDE.js.map