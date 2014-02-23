(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		ProjectOptions.create();
		HIDE.notifyLoadingComplete(Main.$name);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/project-options.css"]);
};
var ProjectOptions = function() { };
ProjectOptions.create = function() {
	var page;
	var _this = window.document;
	page = _this.createElement("div");
	var p;
	var _this = window.document;
	p = _this.createElement("p");
	p.id = "project-options-text";
	p.innerText = "Project arguments:";
	page.appendChild(p);
	var _this = window.document;
	ProjectOptions.textarea = _this.createElement("textarea");
	ProjectOptions.textarea.id = "project-options-textarea";
	ProjectOptions.textarea.onchange = function(e) {
		ProjectAccess.currentProject.args = ProjectOptions.textarea.value.split("\n");
	};
	page.appendChild(ProjectOptions.textarea);
	Splitpane.components[3].appendChild(page);
};
Main.$name = "boyan.bootstrap.project-options";
Main.dependencies = ["boyan.bootstrap.script","boyan.jquery.layout","boyan.management.project-access"];
Main.main();
})();

//# sourceMappingURL=Main.js.map