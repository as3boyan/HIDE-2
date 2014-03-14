(function () { "use strict";
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
		var $window = nodejs.webkit.Window.get();
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
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Menu = nodejs.webkit.$ui.Menu;
nodejs.webkit.MenuItem = nodejs.webkit.$ui.MenuItem;
nodejs.webkit.Window = nodejs.webkit.$ui.Window;
Presentation.main();
})();

//# sourceMappingURL=Presentation.js.map