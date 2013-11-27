(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadCSS(Main.$name,["bin/includes/css/lib/codemirror.css","bin/includes/css/editor.css"]);
		HIDE.loadJS(Main.$name,["bin/includes/js/lib/codemirror.js"],function() {
			var textarea;
			var _this = window.document;
			textarea = _this.createElement("textarea");
			textarea.id = "code";
			Splitpane.components[1].appendChild(textarea);
			var editor = CodeMirror.fromTextArea(textarea,{ lineNumbers : true, dragDrop : false});
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
};
Main.$name = "boyan.codemirror.editor";
Main.dependencies = ["boyan.jquery.layout","boyan.bootstrap.tab-manager"];
Main.main();
})();

//# sourceMappingURL=Main.js.map