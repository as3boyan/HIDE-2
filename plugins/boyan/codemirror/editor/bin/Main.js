(function ($hx_exports) { "use strict";
var CM = $hx_exports.CM = function() { };
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,Main.load,true);
};
Main.load = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.bootstrap.tab-manager","boyan.bootstrap.menu"],function() {
		HIDE.loadCSS(Main.$name,["bin/includes/codemirror-3.22/lib/codemirror.css","bin/includes/codemirror-3.22/addon/hint/show-hint.css","bin/includes/codemirror-3.22/addon/dialog/dialog.css","bin/includes/codemirror-3.22/addon/tern/tern.css","bin/includes/css/editor.css"]);
		Main.loadThemes(["3024-day","3024-night","ambiance","base16-dark","base16-light","blackboard","cobalt","eclipse","elegant","erlang-dark","lesser-dark","midnight","monokai","neat","night","paraiso-dark","paraiso-light","rubyblue","solarized","the-matrix","tomorrow-night-eighties","twilight","vibrant-ink","xq-dark","xq-light"],Main.loadTheme);
		var modes = ["haxe/haxe.js","javascript/javascript.js","css/css.js","xml/xml.js","htmlmixed/htmlmixed.js","markdown/markdown.js","shell/shell.js"];
		var _g1 = 0;
		var _g = modes.length;
		while(_g1 < _g) {
			var i = _g1++;
			modes[i] = "bin/includes/codemirror-3.22/mode/" + modes[i];
		}
		HIDE.loadJS(Main.$name,["bin/includes/codemirror-3.22/lib/codemirror.js","bin/includes/codemirror/addon/hint/show-hint.js","bin/includes/codemirror-3.22/addon/edit/matchbrackets.js","bin/includes/codemirror-3.22/addon/edit/closebrackets.js","bin/includes/codemirror-3.22/addon/comment/comment.js","bin/includes/codemirror-3.22/addon/fold/foldcode.js","bin/includes/codemirror-3.22/addon/fold/foldgutter.js","bin/includes/codemirror-3.22/addon/fold/brace-fold.js","bin/includes/codemirror-3.22/addon/fold/comment-fold.js","bin/includes/codemirror-3.22/addon/selection/active-line.js","bin/includes/codemirror-3.22/addon/search/searchcursor.js","bin/includes/codemirror-3.22/addon/search/search.js","bin/includes/codemirror-3.22/addon/dialog/dialog.js","bin/includes/codemirror-3.18/addon/tern/tern.js","bin/includes/codemirror-3.22/addon/search/match-highlighter.js"].concat(modes),function() {
			var textarea;
			var _this = window.document;
			textarea = _this.createElement("textarea");
			textarea.id = "code";
			Splitpane.components[1].appendChild(textarea);
			var editor = CodeMirror.fromTextArea(textarea,{ lineNumbers : true, matchBrackets : true, dragDrop : false, autoCloseBrackets : true, foldGutter : { rangeFinder : new CodeMirror.fold.combine(CodeMirror.fold.brace, CodeMirror.fold.comment)}, gutters : ["CodeMirror-linenumbers","CodeMirror-foldgutter"], indentUnit : 4, tabSize : 4, mode : "haxe", lineWrapping : true, highlightSelectionMatches : { showToken: /\w/}});
			editor.getWrapperElement().style.display = "none";
			CM.editor = editor;
			TabManager.editor = CM.editor;
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
};
Main.loadTheme = function() {
	var localStorage = js.Browser.getLocalStorage();
	if(localStorage != null) {
		var theme = localStorage.getItem("theme");
		if(theme != null) Main.setTheme(theme);
	}
};
Main.loadThemes = function(themes,onComplete) {
	var themesSubmenu = BootstrapMenu.getMenu("View").getSubmenu("Themes");
	var theme;
	var pathToThemeArray = new Array();
	themesSubmenu.addMenuItem("default",0,function() {
		return Main.setTheme("default");
	});
	var _g1 = 0;
	var _g = themes.length;
	while(_g1 < _g) {
		var i = _g1++;
		theme = themes[i];
		pathToThemeArray.push("bin/includes/codemirror-3.22/theme/" + theme + ".css");
		themesSubmenu.addMenuItem(theme,i + 1,(function(f,a1) {
			return function() {
				return f(a1);
			};
		})(Main.setTheme,theme));
	}
	HIDE.loadCSS(Main.$name,pathToThemeArray,onComplete);
};
Main.setTheme = function(theme) {
	CM.editor.setOption("theme",theme);
	js.Browser.getLocalStorage().setItem("theme",theme);
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
Main.$name = "boyan.codemirror.editor";
Main.dependencies = ["boyan.jquery.layout","boyan.window.splitpane"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map