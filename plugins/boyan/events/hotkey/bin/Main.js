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
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
};
var Hotkeys = $hx_exports.Hotkeys = function() { };
Hotkeys.prepare = function() {
	Hotkeys.pathToData = js.Node.require("path").join(HIDE.getPluginPath(Main.$name),"config.json");
	Hotkeys.parseData();
	var options = { };
	options.interval = 1500;
	js.Node.require("fs").watchFile(Hotkeys.pathToData,options,function(curr,prev) {
		if(curr.mtime != prev.mtime) {
			Hotkeys.parseData();
			Hotkeys.hotkeys = new Array();
			var $it0 = Hotkeys.commandMap.keys();
			while( $it0.hasNext() ) {
				var key = $it0.next();
				Hotkeys.addHotkey(key);
			}
		}
	});
	window.addEventListener("keyup",function(e) {
		var _g = 0;
		var _g1 = Hotkeys.hotkeys;
		while(_g < _g1.length) {
			var hotkey = _g1[_g];
			++_g;
			if(hotkey.keyCode == e.keyCode && hotkey.ctrl == e.ctrlKey && hotkey.shift == e.shiftKey && hotkey.alt == e.altKey) hotkey.onKeyDown();
		}
	});
};
Hotkeys.add = function(menuItem,hotkeyText,span,onKeyDown) {
	Hotkeys.commandMap.set(menuItem,onKeyDown);
	if(span != null) Hotkeys.spanMap.set(menuItem,span);
	Hotkeys.addHotkey(menuItem,hotkeyText);
};
Hotkeys.addHotkey = function(menuItem,hotkeyText) {
	if(hotkeyText == null) hotkeyText = "";
	if(Object.prototype.hasOwnProperty.call(Hotkeys.data,menuItem)) hotkeyText = Reflect.field(Hotkeys.data,menuItem); else {
		Hotkeys.data[menuItem] = hotkeyText;
		var data = HIDE.stringifyAndFormat(Hotkeys.data);
		js.Node.require("fs").writeFileSync(js.Node.require("path").join(HIDE.getPluginPath(Main.$name),"config.json"),data,"utf8");
	}
	var keyCode = null;
	var ctrl = null;
	var shift = null;
	var alt = null;
	if(hotkeyText != "") {
		var hotkey = Hotkeys.parseHotkey(hotkeyText);
		if(hotkey.keyCode != 0) {
			keyCode = hotkey.keyCode;
			ctrl = hotkey.ctrl;
			shift = hotkey.shift;
			alt = hotkey.alt;
		} else window.console.warn("can't assign hotkey " + hotkeyText + " for " + menuItem);
	}
	if(Hotkeys.spanMap.exists(menuItem)) Hotkeys.spanMap.get(menuItem).innerText = hotkeyText;
	if(keyCode != null) Hotkeys.hotkeys.push({ keyCode : keyCode, ctrl : ctrl, shift : shift, alt : alt, onKeyDown : Hotkeys.commandMap.get(menuItem)});
};
Hotkeys.parseData = function() {
	var options = { };
	options.encoding = "utf8";
	Hotkeys.data = JSON.parse(js.Node.require("fs").readFileSync(Hotkeys.pathToData,options));
};
Hotkeys.parseHotkey = function(hotkey) {
	var keys = hotkey.split("-");
	var ctrl = false;
	var shift = false;
	var alt = false;
	var keyCode = 0;
	var _g = 0;
	while(_g < keys.length) {
		var key = keys[_g];
		++_g;
		var _g1 = key.toLowerCase();
		switch(_g1) {
		case "ctrl":
			ctrl = true;
			break;
		case "shift":
			shift = true;
			break;
		case "alt":
			alt = true;
			break;
		case "f1":
			keyCode = 112;
			break;
		case "f2":
			keyCode = 113;
			break;
		case "f3":
			keyCode = 114;
			break;
		case "f4":
			keyCode = 115;
			break;
		case "f5":
			keyCode = 116;
			break;
		case "f6":
			keyCode = 117;
			break;
		case "f7":
			keyCode = 118;
			break;
		case "f8":
			keyCode = 119;
			break;
		case "f9":
			keyCode = 120;
			break;
		case "f10":
			keyCode = 121;
			break;
		case "f11":
			keyCode = 122;
			break;
		case "f12":
			keyCode = 123;
			break;
		case "tab":
			keyCode = 9;
			break;
		case "enter":
			keyCode = 13;
			break;
		case "esc":
			keyCode = 27;
			break;
		case "space":
			keyCode = 32;
			break;
		case "+":
			keyCode = 187;
			break;
		case "":
			keyCode = 189;
			break;
		default:
			if(key.length == 1) keyCode = HxOverrides.cca(key,0);
		}
	}
	return { keyCode : keyCode, ctrl : ctrl, shift : shift, alt : alt};
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
var Main = function() { };
Main.main = function() {
	Hotkeys.prepare();
	HIDE.notifyLoadingComplete(Main.$name);
};
var Reflect = function() { };
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
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
Hotkeys.hotkeys = new Array();
Hotkeys.commandMap = new haxe.ds.StringMap();
Hotkeys.spanMap = new haxe.ds.StringMap();
Main.$name = "boyan.events.hotkey";
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map