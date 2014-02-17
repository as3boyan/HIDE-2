(function () { "use strict";
var Alerts = function() { }
$hxExpose(Alerts, "Alerts");
Alerts.showAlert = function(text) {
	var div = js.Browser.document.createElement("div");
	div.className = "alert alert-success alert-dismissable";
	var button = js.Browser.document.createElement("button");
	button.type = "button";
	button.className = "close";
	button.setAttribute("data-dismiss","alert");
	button.setAttribute("aria-hidden","true");
	button.innerHTML = "&times;";
	div.appendChild(button);
	div.appendChild(js.Browser.document.createTextNode(text));
	js.Browser.document.body.appendChild(div);
}
var Main = function() { }
Main.main = function() {
	HIDE.notifyLoadingComplete(Main.$name);
}
var js = {}
js.Browser = function() { }
Main.$name = "boyan.bootstrap.alerts";
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