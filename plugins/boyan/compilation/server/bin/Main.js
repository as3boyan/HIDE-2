(function () { "use strict";
var HaxeServer = function() { }
$hxExpose(HaxeServer, "HaxeServer");
HaxeServer.start = function() {
	HaxeServer.haxeCompletionServer = js.Node.require("child_process").spawn("haxe",["--wait","6001"]);
	HaxeServer.haxeCompletionServer.stdout.setEncoding("utf8");
	HaxeServer.haxeCompletionServer.stdout.on("data",function(data) {
		console.log("stdout: " + data);
	});
	HaxeServer.haxeCompletionServer.stderr.setEncoding("utf8");
	HaxeServer.haxeCompletionServer.stderr.on("data",function(data) {
		var str = data.toString();
		var lines = str.split("\n");
		console.log("ERROR: " + lines.join(""));
		HaxeServer.processStarted = false;
	});
	HaxeServer.haxeCompletionServer.on("close",function(code) {
		if(code != null) console.log("haxeCompletionServer process exit code " + code);
	});
	js.Node.require("nw.gui").Window.get().on("close",function(e) {
		HaxeServer.terminate();
	});
}
HaxeServer.terminate = function() {
	if(HaxeServer.processStarted) HaxeServer.haxeCompletionServer.kill();
}
var HxOverrides = function() { }
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
Main.main = function() {
	HaxeServer.start();
	HIDE.notifyLoadingComplete(Main.$name);
}
var Std = function() { }
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
var js = {}
js.Node = function() { }
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
HaxeServer.processStarted = true;
Main.$name = "boyan.compilation.server";
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