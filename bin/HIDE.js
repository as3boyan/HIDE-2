(function ($hx_exports) { "use strict";
var HIDE = $hx_exports.HIDE = function() { };
HIDE.loadJS = function(url,onLoad) {
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
HIDE.loadCSS = function(url) {
	var link;
	var _this = window.document;
	link = _this.createElement("link");
	link.href = url;
	link.type = "text/css";
	link.rel = "stylesheet";
	window.document.head.appendChild(link);
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
var Main = function() { };
Main.main = function() {
	js.Node.require("nw.gui").Window.get().showDevTools();
	window.onload = function(e) {
		js.Node.require("nw.gui").Window.get().show();
		var pathToPlugins = js.Node.require("path").join("..","plugins");
		js.Node.require("fs").readdir(pathToPlugins,function(error,folders) {
			var _g = 0;
			while(_g < folders.length) {
				var folder = folders[_g];
				++_g;
				var path = [js.Node.require("path").join(pathToPlugins,folder)];
				js.Node.require("fs").readdir(path[0],(function(path) {
					return function(error1,subfolders) {
						var _g1 = 0;
						while(_g1 < subfolders.length) {
							var subfolder = [subfolders[_g1]];
							++_g1;
							var pathToPlugin = [js.Node.require("path").join(path[0],subfolder[0])];
							pathToPlugin[0] = js.Node.require("path").resolve(pathToPlugin[0]);
							var haxeCompilerProcess = js.Node.require("child_process").spawn("haxe",["--cwd",pathToPlugin[0],"plugin.hxml"]);
							haxeCompilerProcess.stderr.on("data",(function(pathToPlugin) {
								return function(data) {
									console.log(pathToPlugin[0] + " stderr: " + data);
								};
							})(pathToPlugin));
							haxeCompilerProcess.on("close",(function(subfolder,path) {
								return function(code) {
									console.log(code);
									var pathToMain = js.Node.require("path").join(path[0],subfolder[0],"bin");
									pathToMain = js.Node.require("path").join(pathToMain,"Main.js");
									HIDE.loadJS(pathToMain);
								};
							})(subfolder,path));
						}
					};
				})(path));
			}
		});
	};
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
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
HIDE.plugins = new Array();
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=HIDE.js.map