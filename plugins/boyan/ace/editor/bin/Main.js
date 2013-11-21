(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.dependencies,function() {
		var pre;
		var _this = window.document;
		pre = _this.createElement("pre");
		pre.id = "editor";
		Splitpane.components[1].appendChild(pre);
		HIDE.loadJS(Main.$name,"bin/includes/js/ace.js",function() {
			var editor = ace.edit("editor");
			editor.setTheme("ace/theme/monokai");
			editor.getSession().setMode("ace/mode/haxe");
		});
	});
	HIDE.plugins.push(Main.$name);
};
Main.$name = "boyan.ace.editor";
Main.dependencies = ["boyan.jquery.split-pane","boyan.bootstrap.tabmanager"];
Main.main();
})();

//# sourceMappingURL=Main.js.map