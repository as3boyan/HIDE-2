(function ($hx_exports) { "use strict";
var Alerts = $hx_exports.Alerts = function() { };
Alerts.showAlert = function(text) {
	var div;
	var _this = window.document;
	div = _this.createElement("div");
	div.className = "alert alert-success alert-dismissable";
	var button;
	var _this1 = window.document;
	button = _this1.createElement("button");
	button.type = "button";
	button.className = "close";
	button.setAttribute("data-dismiss","alert");
	button.setAttribute("aria-hidden","true");
	button.innerHTML = "&times;";
	div.appendChild(button);
	div.appendChild(window.document.createTextNode(text));
	window.document.body.appendChild(div);
};
var Main = function() { };
Main.main = function() {
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.bootstrap.alerts";
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map