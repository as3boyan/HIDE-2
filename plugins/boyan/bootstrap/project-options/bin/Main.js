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
	ProjectOptions.textarea.onchange = function(e) {
		ProjectAccess.currentProject.args = ProjectOptions.textarea.value.split("\n");
	};
	page.appendChild(ProjectOptions.textarea);
	var list = js.Browser.document.createElement("select");
	var _g = 0, _g1 = ["Flash","JavaScript","Neko","PHP","C++","Java","C#"];
	while(_g < _g1.length) {
		var target = _g1[_g];
		++_g;
		list.appendChild(ProjectOptions.createListItem(target));
	}
	page.appendChild(list);
	Splitpane.components[3].appendChild(page);
}
ProjectOptions.createListItem = function(text) {
	var option = js.Browser.document.createElement("option");
	option.textContent = text;
	option.value = text;
	return option;
}
var js = {}
js.Browser = function() { }
Main.$name = "boyan.bootstrap.project-options";
Main.dependencies = ["boyan.bootstrap.script","boyan.jquery.layout","boyan.management.project-access"];
js.Browser.document = typeof window != "undefined" ? window.document : null;
Main.main();
})();

//@ sourceMappingURL=Main.js.map