(function () { "use strict";
var Hotkeys = function() { }
$hxExpose(Hotkeys, "Hotkeys");
Hotkeys.prepare = function() {
	js.Browser.window.addEventListener("keydown",function(e) {
		var _g = 0, _g1 = Hotkeys.hotkeys;
		while(_g < _g1.length) {
			var hotkey = _g1[_g];
			++_g;
			if(hotkey.keyCode == e.keyCode && hotkey.ctrl == e.ctrlKey && hotkey.shift == e.shiftKey && hotkey.alt == e.altKey) hotkey.onKeyDown();
		}
		console.log(e.keyCode);
	});
}
Hotkeys.addHotkey = function(keyCode,ctrl,shift,alt,onKeyDown) {
	Hotkeys.hotkeys.push({ keyCode : keyCode, ctrl : ctrl, shift : shift, alt : alt, onKeyDown : onKeyDown});
}
var Main = function() { }
Main.main = function() {
	Hotkeys.prepare();
	HIDE.notifyLoadingComplete(Main.$name);
}
var js = {}
js.Browser = function() { }
Hotkeys.hotkeys = new Array();
Main.$name = "boyan.events.hotkey";
js.Browser.window = typeof window != "undefined" ? window : null;
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