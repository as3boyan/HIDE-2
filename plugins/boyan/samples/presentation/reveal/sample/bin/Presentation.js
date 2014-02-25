(function () { "use strict";
var HxOverrides = function() { }
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
var Presentation = function() { }
Presentation.main = function() {
	js.Browser.window.onload = function(e) {
		var reveal = js.Browser.document.createElement("div");
		reveal.className = "reveal";
		var slides = js.Browser.document.createElement("div");
		slides.className = "slides";
		reveal.appendChild(slides);
		slides.appendChild(Presentation.createSection("Single Horizontal Slide"));
		var section = Presentation.createSection();
		section.appendChild(Presentation.createSection("Vertical Slide 1"));
		section.appendChild(Presentation.createSection("Vertical Slide 2"));
		slides.appendChild(section);
		js.Browser.document.body.appendChild(reveal);
		Presentation.runRevealJS();
		var window = js.Node.require("nw.gui").Window.get();
		window.on("close",function(e1) {
			window.close(true);
		});
	};
}
Presentation.createSection = function(text) {
	var section = js.Browser.document.createElement("section");
	if(text != null) section.innerText = text;
	return section;
}
Presentation.runRevealJS = function() {
	var dependencies = [{ src : "includes/lib/js/classList.js", condition : function() {
		return js.Browser.document.body.classList == null;
	}},{ src : "includes/plugin/highlight/highlight.js", async : true, callback : function() {
		hljs.initHighlightingOnLoad();
	}},{ src : "includes/plugin/zoom-js/zoom.js", async : true, condition : function() {
		return js.Browser.document.body.classList != null;
	}},{ src : "includes/plugin/notes/notes.js", async : true, condition : function() {
		return js.Browser.document.body.classList != null;
	}}];
	Reveal.initialize({ controls : true, progress : true, history : true, center : true, theme : Reveal.getQueryHash().theme, dependencies : dependencies});
}
var Std = function() { }
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
var js = {}
js.Browser = function() { }
js.Node = function() { }
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
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
Presentation.main();
})();

//@ sourceMappingURL=Presentation.js.map