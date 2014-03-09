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
		var reveal;
		var _this = window.document;
		reveal = _this.createElement("div");
		reveal.className = "reveal";
		var slides;
		var _this1 = window.document;
		slides = _this1.createElement("div");
		slides.className = "slides";
		reveal.appendChild(slides);
		slides.appendChild(Presentation.createSection("How to develop plugins for HIDE"));
		var section = Presentation.createSection();
		section.appendChild(Presentation.createSection("HIDE API"));
		section.appendChild(Presentation.createSection("loadJS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void;"));
		section.appendChild(Presentation.createSection("loadCSS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void;"));
		section.appendChild(Presentation.createSection("waitForDependentPluginsToBeLoaded(name:String, plugins:Array<String>, onLoaded:Void->Void, ?callOnLoadWhenAtLeastOnePluginLoaded:Bool = false):Void;"));
		section.appendChild(Presentation.createSection("notifyLoadingComplete(name:String):Void;"));
		section.appendChild(Presentation.createSection("openPageInNewWindow(name:String, url:String, ?params:Dynamic):Void;"));
		section.appendChild(Presentation.createSection("compilePlugins(?onComplete:Dynamic, ?onFailed:Dynamic):Void;"));
		slides.appendChild(section);
		section = Presentation.createSection();
		section.appendChild(Presentation.createSection("Plugin structure"));
		section.appendChild(Presentation.createSection("Each plugin must have plugin.hxml"));
		section.appendChild(Presentation.createSection("Plugin should compile to bin/Main.js"));
		slides.appendChild(section);
		window.document.body.appendChild(reveal);
		Presentation.runRevealJS();
		var $window = js.Node.require("nw.gui").Window.get();
		$window.on("close",function(e1) {
			$window.close(true);
		});
	};
};
Presentation.createSection = function(text) {
	var section = window.document.createElement("section");
	if(text != null) section.innerText = text;
	return section;
};
Presentation.runRevealJS = function() {
	var dependencies = [{ src : "includes/lib/js/classList.js", condition : function() {
		return window.document.body.classList == null;
	}},{ src : "includes/plugin/highlight/highlight.js", async : true, callback : function() {
		hljs.initHighlightingOnLoad();
	}},{ src : "includes/plugin/zoom-js/zoom.js", async : true, condition : function() {
		return window.document.body.classList != null;
	}},{ src : "includes/plugin/notes/notes.js", async : true, condition : function() {
		return window.document.body.classList != null;
	}}];
	Reveal.initialize({ controls : true, progress : true, history : true, center : true, theme : Reveal.getQueryHash().theme, dependencies : dependencies});
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