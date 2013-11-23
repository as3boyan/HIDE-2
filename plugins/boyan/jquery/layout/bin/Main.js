(function ($hx_exports) { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,Main.load);
	HIDE.loadCSS(Main.$name,["bin/includes/css/layout-default-latest.css"]);
};
Main.load = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/jquery.layout-latest.min.js"],function() {
		Splitpane.createSplitPane();
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
var Splitpane = $hx_exports.Splitpane = function() { };
Splitpane.createSplitPane = function() {
	var panel;
	var _this = window.document;
	panel = _this.createElement("div");
	panel.id = "panel";
	panel.className = "ui-layout-container";
	panel.style.position = "absolute";
	panel.style.top = "51px";
	var outerCenterPanel = Splitpane.createComponent("outer","center");
	panel.appendChild(outerCenterPanel);
	var middleCenterPanel = Splitpane.createComponent("middle","center");
	outerCenterPanel.appendChild(middleCenterPanel);
	var middleCenterPanelContent = Splitpane.createContent();
	middleCenterPanel.appendChild(middleCenterPanelContent);
	var middleSouthPanel = Splitpane.createComponent("middle","south");
	outerCenterPanel.appendChild(middleSouthPanel);
	var middleSouthPanelContent = Splitpane.createContent();
	middleSouthPanel.appendChild(middleSouthPanelContent);
	var outerWestPanel = Splitpane.createComponent("outer","west");
	panel.appendChild(outerWestPanel);
	Splitpane.components.push(outerWestPanel);
	Splitpane.components.push(middleCenterPanelContent);
	window.document.body.appendChild(panel);
	haxe.Timer.delay(function() {
		Splitpane.activateSplitpane();
	},10000);
};
Splitpane.activateSplitpane = function() {
	Splitpane.layout = new $("#panel").layout({ center__paneSelector : ".outer-center", west__paneSelector : ".outer-west", west__size : 120, spacing_open : 8, spacing_closed : 12, center__childOptions : { center__paneSelector : ".middle-center", south__paneSelector : ".middle-south", south__size : 100, spacing_open : 8, spacing_closed : 12}, animatePaneSizing : true, stateManagement__enabled : true});
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
Main.$name = "boyan.jquery.layout";
Main.dependencies = ["boyan.jquery.ui"];
Splitpane.components = new Array();
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map