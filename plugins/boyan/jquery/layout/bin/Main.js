(function ($hx_exports) { "use strict";
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
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,Main.load);
};
Main.load = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/jquery.layout-latest.min.js"],function() {
		Splitpane.createSplitPane();
		HIDE.loadCSS(Main.$name,["bin/includes/css/layout-default-latest.css","bin/includes/css/panel.css"],function() {
			Splitpane.activateSplitpane();
		});
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
var Splitpane = $hx_exports.Splitpane = function() { };
Splitpane.createSplitPane = function() {
	var _this = window.document;
	Splitpane.panel = _this.createElement("div");
	Splitpane.panel.id = "panel";
	Splitpane.panel.className = "ui-layout-container";
	Splitpane.panel.style.position = "absolute";
	Splitpane.panel.style.top = "51px";
	var outerCenterPanel = Splitpane.createComponent("outer","center");
	Splitpane.panel.appendChild(outerCenterPanel);
	var middleCenterPanel = Splitpane.createComponent("middle","center");
	outerCenterPanel.appendChild(middleCenterPanel);
	var middleCenterPanelContent = Splitpane.createContent();
	middleCenterPanel.appendChild(middleCenterPanelContent);
	var middleSouthPanel = Splitpane.createComponent("middle","south");
	outerCenterPanel.appendChild(middleSouthPanel);
	var middleSouthPanelContent = Splitpane.createContent();
	middleSouthPanel.appendChild(middleSouthPanelContent);
	var outerWestPanel = Splitpane.createComponent("outer","west");
	Splitpane.panel.appendChild(outerWestPanel);
	Splitpane.components.push(outerWestPanel);
	Splitpane.components.push(middleCenterPanelContent);
	Splitpane.components.push(middleSouthPanelContent);
	window.document.body.appendChild(Splitpane.panel);
};
Splitpane.activateSplitpane = function() {
	var layoutSettings = { center__paneSelector : ".outer-center", west__paneSelector : ".outer-west", west__size : 120, spacing_open : 8, spacing_closed : 12, center__childOptions : { center__paneSelector : ".middle-center", south__paneSelector : ".middle-south", south__size : 100, spacing_open : 8, spacing_closed : 12}};
	Splitpane.layout = $("#panel").layout(layoutSettings);
	var timer = new haxe.Timer(250);
	timer.run = function() {
		if(window.document.getElementById("tree-well").clientHeight < 100) {
			Splitpane.layout.resizeAll();
			new $(window).trigger("resize");
			console.log("layout.resizeAll()");
		} else timer.stop();
	};
};
Splitpane.activateStatePreserving = function() {
	var localStorage = js.Browser.getLocalStorage();
	var $window = js.Node.require("nw.gui").Window.get();
	$window.on("close",function(e) {
		var stateString = js.Node.stringify(Splitpane.layout.readState());
		localStorage.setItem("state",stateString);
		$window.close(true);
	});
	var state = localStorage.getItem("state");
	if(state != null) Splitpane.layout.loadState(js.Node.parse(state));
};
Splitpane.createComponent = function(layout,side) {
	var component;
	var _this = window.document;
	component = _this.createElement("div");
	component.className = layout + "-" + side + " " + "ui-layout-" + side;
	return component;
};
Splitpane.createContent = function() {
	var content;
	var _this = window.document;
	content = _this.createElement("div");
	content.className = "ui-layout-content";
	return content;
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var haxe = {};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
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
var js = {};
js.Browser = function() { };
js.Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
};
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
Main.$name = "boyan.jquery.layout";
Main.dependencies = ["boyan.jquery.ui"];
Splitpane.components = new Array();
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map