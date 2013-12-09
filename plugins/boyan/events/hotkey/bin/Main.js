(function ($hx_exports) { "use strict";
var Hotkeys = $hx_exports.Hotkeys = function() { };
Hotkeys.prepare = function() {
	window.addEventListener("keydown",function(e) {
		var _g = 0;
		var _g1 = Hotkeys.hotkeys;
		while(_g < _g1.length) {
			var hotkey = _g1[_g];
			++_g;
			if(hotkey.keyCode == e.keyCode && hotkey.ctrl == e.ctrlKey && hotkey.shift == e.shiftKey && hotkey.alt == e.altKey) hotkey.onKeyDown();
		}
		console.log(e.keyCode);
	});
};
Hotkeys.addHotkey = function(keyCode,ctrl,shift,alt,onKeyDown) {
	Hotkeys.hotkeys.push({ keyCode : keyCode, ctrl : ctrl, shift : shift, alt : alt, onKeyDown : onKeyDown});
};
var Main = function() { };
Main.main = function() {
	Hotkeys.prepare();
	HIDE.notifyLoadingComplete(Main.$name);
};
Hotkeys.hotkeys = new Array();
Main.$name = "boyan.events.hotkey";
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map