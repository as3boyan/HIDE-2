(function ($hx_exports) { "use strict";
var Alerts = $hx_exports.Alerts = function() { };
Alerts.showAlert = function(text) {
	var div;
	var _this = window.document;
	div = _this.createElement("div");
	div.className = "alert alert-success alert-dismissable";
	div.style.position = "fixed";
	div.style.zIndex = "10000";
	div.style.top = "50%";
	div.style.left = "50%";
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
	div.style.marginTop = "" + (-div.clientHeight / 2 | 0) + "px";
	div.style.marginLeft = "" + (-div.clientWidth / 2 | 0) + "px";
	haxe.Timer.delay(function() {
		if(div.parentElement != null) new $(div).fadeOut(500,null,function() {
			window.document.body.removeChild(div);
		});
	},1500);
};
var Main = function() { };
Main.main = function() {
	HIDE.notifyLoadingComplete(Main.$name);
};
var haxe = {};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
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
Main.$name = "boyan.bootstrap.alerts";
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map