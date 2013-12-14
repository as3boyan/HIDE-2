(function ($hx_exports) { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
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
HIDE.openPageInNewWindow = function(name,url,params) {
	var $window = js.Node.require("nw.gui").Window.open(js.Node.require("path").join(HIDE.getPluginPath(name),url),params);
	HIDE.windows.push($window);
	$window.on("close",function(e) {
		HxOverrides.remove(HIDE.windows,$window);
		$window.close(true);
	});
	return $window;
};
HIDE.compilePlugins = function(onComplete,onFailed) {
	var pluginCount = Lambda.count(HIDE.pathToPlugins);
	var compiledPluginCount = 0;
	var relativePathToPlugin;
	var absolutePathToPlugin;
	var $it0 = HIDE.pathToPlugins.keys();
	while( $it0.hasNext() ) {
		var name = $it0.next();
		relativePathToPlugin = HIDE.pathToPlugins.get(name);
		absolutePathToPlugin = js.Node.require("path").resolve(relativePathToPlugin);
		Main.compilePlugin(name,absolutePathToPlugin,function() {
			compiledPluginCount++;
			if(compiledPluginCount == pluginCount) onComplete();
		},onFailed);
	}
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
	} else if(Lambda.count(HIDE.pathToPlugins) == HIDE.plugins.length) {
		console.log("all plugins loaded");
		var delta = new Date().getTime() - Main.currentTime;
		console.log("Loading took: " + Std.string(delta) + " ms");
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
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
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
	var gui = js.Node.require("nw.gui");
	var $window = gui.Window.get();
	$window.showDevTools();
	window.addEventListener("load",function(e) {
		$window.show();
		Main.currentTime = new Date().getTime();
		Main.loadPlugins();
	});
	$window.on("close",function(e) {
		var _g = 0;
		var _g1 = HIDE.windows;
		while(_g < _g1.length) {
			var window1 = _g1[_g];
			++_g;
			window1.close(true);
		}
	});
};
Main.loadPlugins = function(compile) {
	if(compile == null) compile = true;
	var pathToPlugins = js.Node.require("path").join("..","plugins");
	Main.readDir(pathToPlugins,"",function(path,pathToPlugin) {
		var pluginName = StringTools.replace(pathToPlugin,js.Node.require("path").sep,".");
		var relativePathToPlugin = js.Node.require("path").join(path,pathToPlugin);
		HIDE.pathToPlugins.set(pluginName,relativePathToPlugin);
		var absolutePathToPlugin = js.Node.require("path").resolve(relativePathToPlugin);
		if(compile) Main.compilePlugin(pluginName,absolutePathToPlugin,Main.loadPlugin); else Main.loadPlugin(absolutePathToPlugin);
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
							if(error1 != null) {
							} else {
								var pluginName = StringTools.replace(pathToPlugin,js.Node.require("path").sep,".");
								if(stat.isDirectory()) Main.readDir(path,js.Node.require("path").join(pathToPlugin,item[0]),onLoad); else if(item[0] == "plugin.hxml" && !Lambda.has(HIDE.inactivePlugins,pluginName)) {
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
Main.compilePlugin = function(name,pathToPlugin,onSuccess,onFailed) {
	var haxeCompilerProcess = js.Node.require("child_process").spawn("haxe",["--cwd",pathToPlugin,"plugin.hxml"]);
	var stderrData = "";
	haxeCompilerProcess.stderr.on("data",function(data) {
		stderrData += data;
		console.log(pathToPlugin + " stderr: " + data);
	});
	haxeCompilerProcess.on("close",function(code) {
		if(code == 0) onSuccess(pathToPlugin); else {
			console.log("can't load " + name + " plugin, compilation failed");
			if(onFailed != null) onFailed(stderrData);
		}
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
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
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
haxe.io = {};
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
haxe.io.Bytes.__name__ = true;
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
};
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var _g1 = 0;
	var _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = s.cca(i);
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
};
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
};
haxe.io.Bytes.prototype = {
	get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		if(b1 == b2 && pos > srcpos) {
			var i = len;
			while(i > 0) {
				i--;
				b1[i + pos] = b2[i + srcpos];
			}
			return;
		}
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b1[i + pos] = b2[i + srcpos];
		}
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len;
		if(this.length < other.length) len = this.length; else len = other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c2 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,toString: function() {
		return this.readString(0,this.length);
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0;
		var _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g1 = 0;
		var _g = this.length;
		while(_g1 < _g) {
			var i = _g1++;
			var c = this.b[i];
			s.b += String.fromCharCode(chars[c >> 4]);
			s.b += String.fromCharCode(chars[c & 15]);
		}
		return s.b;
	}
	,getData: function() {
		return this.b;
	}
};
haxe.io.Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; };
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
js.NodeC = function() { };
js.NodeC.__name__ = true;
js.Node = function() { };
js.Node.__name__ = true;
js.Node.get_assert = function() {
	return js.Node.require("assert");
};
js.Node.get_childProcess = function() {
	return js.Node.require("child_process");
};
js.Node.get_cluster = function() {
	return js.Node.require("cluster");
};
js.Node.get_crypto = function() {
	return js.Node.require("crypto");
};
js.Node.get_dgram = function() {
	return js.Node.require("dgram");
};
js.Node.get_dns = function() {
	return js.Node.require("dns");
};
js.Node.get_fs = function() {
	return js.Node.require("fs");
};
js.Node.get_http = function() {
	return js.Node.require("http");
};
js.Node.get_https = function() {
	return js.Node.require("https");
};
js.Node.get_net = function() {
	return js.Node.require("net");
};
js.Node.get_os = function() {
	return js.Node.require("os");
};
js.Node.get_path = function() {
	return js.Node.require("path");
};
js.Node.get_querystring = function() {
	return js.Node.require("querystring");
};
js.Node.get_repl = function() {
	return js.Node.require("repl");
};
js.Node.get_tls = function() {
	return js.Node.require("tls");
};
js.Node.get_url = function() {
	return js.Node.require("url");
};
js.Node.get_util = function() {
	return js.Node.require("util");
};
js.Node.get_vm = function() {
	return js.Node.require("vm");
};
js.Node.get___filename = function() {
	return __filename;
};
js.Node.get___dirname = function() {
	return __dirname;
};
js.Node.newSocket = function(options) {
	return new js.Node.net.Socket(options);
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
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
HIDE.inactivePlugins = ["boyan.ace.editor","boyan.jquery.split-pane","boyan.bootstrap.themes.topcoat"];
HIDE.requestedPluginsData = new Array();
HIDE.windows = [];
js.NodeC.UTF8 = "utf8";
js.NodeC.ASCII = "ascii";
js.NodeC.BINARY = "binary";
js.NodeC.BASE64 = "base64";
js.NodeC.HEX = "hex";
js.NodeC.EVENT_EVENTEMITTER_NEWLISTENER = "newListener";
js.NodeC.EVENT_EVENTEMITTER_ERROR = "error";
js.NodeC.EVENT_STREAM_DATA = "data";
js.NodeC.EVENT_STREAM_END = "end";
js.NodeC.EVENT_STREAM_ERROR = "error";
js.NodeC.EVENT_STREAM_CLOSE = "close";
js.NodeC.EVENT_STREAM_DRAIN = "drain";
js.NodeC.EVENT_STREAM_CONNECT = "connect";
js.NodeC.EVENT_STREAM_SECURE = "secure";
js.NodeC.EVENT_STREAM_TIMEOUT = "timeout";
js.NodeC.EVENT_STREAM_PIPE = "pipe";
js.NodeC.EVENT_PROCESS_EXIT = "exit";
js.NodeC.EVENT_PROCESS_UNCAUGHTEXCEPTION = "uncaughtException";
js.NodeC.EVENT_PROCESS_SIGINT = "SIGINT";
js.NodeC.EVENT_PROCESS_SIGUSR1 = "SIGUSR1";
js.NodeC.EVENT_CHILDPROCESS_EXIT = "exit";
js.NodeC.EVENT_HTTPSERVER_REQUEST = "request";
js.NodeC.EVENT_HTTPSERVER_CONNECTION = "connection";
js.NodeC.EVENT_HTTPSERVER_CLOSE = "close";
js.NodeC.EVENT_HTTPSERVER_UPGRADE = "upgrade";
js.NodeC.EVENT_HTTPSERVER_CLIENTERROR = "clientError";
js.NodeC.EVENT_HTTPSERVERREQUEST_DATA = "data";
js.NodeC.EVENT_HTTPSERVERREQUEST_END = "end";
js.NodeC.EVENT_CLIENTREQUEST_RESPONSE = "response";
js.NodeC.EVENT_CLIENTRESPONSE_DATA = "data";
js.NodeC.EVENT_CLIENTRESPONSE_END = "end";
js.NodeC.EVENT_NETSERVER_CONNECTION = "connection";
js.NodeC.EVENT_NETSERVER_CLOSE = "close";
js.NodeC.FILE_READ = "r";
js.NodeC.FILE_READ_APPEND = "r+";
js.NodeC.FILE_WRITE = "w";
js.NodeC.FILE_WRITE_APPEND = "a+";
js.NodeC.FILE_READWRITE = "a";
js.NodeC.FILE_READWRITE_APPEND = "a+";
Main.main();
})(typeof window != "undefined" ? window : exports);
