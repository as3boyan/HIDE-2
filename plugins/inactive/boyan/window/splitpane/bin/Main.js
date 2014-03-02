(function () { "use strict";
var Main = function() { }
Main.main = function() {
	Splitpane.components = [];
	var _g = 0;
	while(_g < 5) {
		var i = _g++;
		var div = js.Browser.document.createElement("div");
		div.style.height = "100%";
		div.style["float"] = "left";
		Splitpane.components.push(div);
		js.Browser.document.body.appendChild(div);
	}
	Splitpane.components[0].style.width = "30%";
	Splitpane.components[1].style.width = "30%";
	Splitpane.components[2].style.width = "30%";
	Splitpane.components[3].style.width = "30%";
	Splitpane.components[4].style.width = "30%";
	HIDE.notifyLoadingComplete(Main.$name);
}
var Splitpane = function() { }
$hxExpose(Splitpane, "Splitpane");
var js = {}
js.Browser = function() { }
Main.$name = "boyan.window.splitpane";
Splitpane.components = new Array();
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