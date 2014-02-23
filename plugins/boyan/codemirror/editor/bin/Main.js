(function ($hx_exports) { "use strict";
var CM = $hx_exports.CM = function() { };
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadCSS(Main.$name,["bin/includes/codemirror-3.18/lib/codemirror.css","bin/includes/codemirror-3.18/addon/hint/show-hint.css","bin/includes/codemirror-git/addon/dialog/dialog.css","bin/includes/codemirror-git/addon/tern/tern.css","bin/includes/css/editor.css"]);
		Main.loadThemes(["3024-day","3024-night","ambiance","base16-dark","base16-light","blackboard","cobalt","eclipse","elegant","erlang-dark","lesser-dark","midnight","monokai","neat","night","paraiso-dark","paraiso-light","rubyblue","solarized","the-matrix","tomorrow-night-eighties","twilight","vibrant-ink","xq-dark","xq-light"]);
		var modes = ["haxe/haxe.js","javascript/javascript.js","css/css.js","xml/xml.js","htmlmixed/htmlmixed.js","markdown/markdown.js","shell/shell.js","ocaml/ocaml.js"];
		var _g1 = 0;
		var _g = modes.length;
		while(_g1 < _g) {
			var i = _g1++;
			modes[i] = "bin/includes/codemirror-git/mode/" + modes[i];
		}
		HIDE.loadJS(Main.$name,["bin/includes/codemirror-git/lib/codemirror.js","bin/includes/codemirror/addon/hint/show-hint.js","bin/includes/codemirror-git/addon/edit/matchbrackets.js","bin/includes/codemirror-git/addon/edit/closebrackets.js","bin/includes/codemirror-git/addon/comment/comment.js","bin/includes/codemirror-git/addon/fold/foldcode.js","bin/includes/codemirror-git/addon/fold/foldgutter.js","bin/includes/codemirror-git/addon/fold/brace-fold.js","bin/includes/codemirror-git/addon/fold/comment-fold.js","bin/includes/codemirror-git/addon/selection/active-line.js","bin/includes/codemirror-git/addon/search/searchcursor.js","bin/includes/codemirror-git/addon/search/search.js","bin/includes/codemirror-git/addon/dialog/dialog.js","bin/includes/codemirror-3.18/addon/tern/tern.js"].concat(modes),function() {
			var textarea;
			var _this = window.document;
			textarea = _this.createElement("textarea");
			textarea.id = "code";
			Splitpane.components[1].appendChild(textarea);
			var editor = CodeMirror.fromTextArea(textarea,{ lineNumbers : true, matchBrackets : true, dragDrop : false, autoCloseBrackets : true, foldGutter : { rangeFinder : new CodeMirror.fold.combine(CodeMirror.fold.brace, CodeMirror.fold.comment)}, gutters : ["CodeMirror-linenumbers","CodeMirror-foldgutter"], indentUnit : 4, tabSize : 4, mode : "haxe"});
			editor.getWrapperElement().style.display = "none";
			CM.editor = editor;
			TabManager.editor = CM.editor;
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
};
Main.loadThemes = function(themes) {
	var _g = 0;
	while(_g < themes.length) {
		var theme = themes[_g];
		++_g;
		HIDE.loadCSS(Main.$name,["bin/includes/codemirror-git/theme/" + theme + ".css"]);
	}
};
Main.$name = "boyan.codemirror.editor";
Main.dependencies = ["boyan.jquery.layout","boyan.bootstrap.tab-manager"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map