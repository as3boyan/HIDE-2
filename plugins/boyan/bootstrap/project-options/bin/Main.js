(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		ProjectOptions.create();
		HIDE.notifyLoadingComplete(Main.$name);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/project-options.css"]);
}
var ProjectOptions = function() { }
ProjectOptions.create = function() {
	var page = js.Browser.document.createElement("div");
	var p = js.Browser.document.createElement("p");
	p.id = "project-options-text";
	p.innerText = "Project arguments:";
	page.appendChild(p);
	ProjectOptions.textarea = js.Browser.document.createElement("textarea");
	ProjectOptions.textarea.id = "project-options-textarea";
	page.appendChild(ProjectOptions.textarea);
	Splitpane.components[3].appendChild(page);
}
var js = {}
js.Browser = function() { }
Main.$name = "boyan.bootstrap.project-options";
Main.dependencies = ["boyan.bootstrap.script","boyan.jquery.layout"];
js.Browser.document = typeof window != "undefined" ? window.document : null;
Main.main();
})();

//@ sourceMappingURL=Main.js.map