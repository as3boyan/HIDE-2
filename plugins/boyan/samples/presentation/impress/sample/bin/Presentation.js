(function () { "use strict";
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
var Presentation = function() { };
Presentation.main = function() {
	window.onload = function(e) {
		var impress;
		var _this = window.document;
		impress = _this.createElement("div");
		impress.id = "impress";
		var start;
		var _this = window.document;
		start = _this.createElement("div");
		start.id = "start";
		start.className = "step";
		impress.appendChild(start);
		var p;
		var _this = window.document;
		p = _this.createElement("p");
		p.style.width = "1000px";
		p.style.fontSize = "80px";
		p.style.textAlign = "center";
		p.innerText = "Creating Stunning Visualizations";
		start.appendChild(p);
		var _this = window.document;
		p = _this.createElement("p");
		p.innerText = "Impress.js";
		start.appendChild(p);
		var slide2;
		var _this = window.document;
		slide2 = _this.createElement("div");
		slide2.id = "slide2";
		slide2.setAttribute("data-x","-1200");
		slide2.setAttribute("data-y","0");
		slide2.className = "step";
		impress.appendChild(slide2);
		var _this = window.document;
		p = _this.createElement("p");
		p.style.width = "1000px";
		p.style.fontSize = "80px";
		p.innerText = "First Slide Moves From Left To Right";
		slide2.appendChild(p);
		var _this = window.document;
		p = _this.createElement("p");
		p.innerText = "Impress.js";
		slide2.appendChild(p);
		window.document.body.appendChild(impress);
		Presentation.runImpressJS();
		var $window = js.Node.require("nw.gui").Window.get();
		$window.on("close",function(e1) {
			$window.close(true);
		});
	};
};
Presentation.runImpressJS = function() {
	impress().init();
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
Presentation.main();
})();

//# sourceMappingURL=Presentation.js.map