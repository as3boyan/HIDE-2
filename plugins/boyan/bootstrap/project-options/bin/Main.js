(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.jquery.layout","boyan.window.splitpane"],Main.load,true);
}
Main.load = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		ProjectOptions.create();
		HIDE.notifyLoadingComplete(Main.$name);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/project-options.css"]);
}
var ProjectOptions = function() { }
ProjectOptions.create = function() {
	var page = js.Browser.document.createElement("div");
	page.style.setProperty("user-select","none","");
	var projectOptionsText = js.Browser.document.createElement("p");
	projectOptionsText.id = "project-options-text";
	projectOptionsText.innerText = "Project arguments:";
	ProjectOptions.textarea = js.Browser.document.createElement("textarea");
	ProjectOptions.textarea.id = "project-options-textarea";
	ProjectOptions.textarea.onchange = function(e) {
		ProjectAccess.currentProject.args = ProjectOptions.textarea.value.split("\n");
	};
	var projectTargetText = js.Browser.document.createElement("p");
	projectTargetText.innerText = "Project target:";
	page.appendChild(projectTargetText);
	var projectTargetList = js.Browser.document.createElement("select");
	projectTargetList.id = "project-options-project-target";
	var openFLTargetList = js.Browser.document.createElement("select");
	openFLTargetList.id = "project-options-openfl-target";
	var openFLTargetText = js.Browser.document.createElement("p");
	openFLTargetText.innerText = "OpenFL target:";
	var _g = 0, _g1 = ["Flash","JavaScript","Neko","OpenFL","PHP","C++","Java","C#"];
	while(_g < _g1.length) {
		var target = _g1[_g];
		++_g;
		projectTargetList.appendChild(ProjectOptions.createListItem(target));
	}
	projectTargetList.onchange = function(e) {
		if(projectTargetList.selectedIndex == 3) {
			openFLTargetList.style.display = "";
			openFLTargetText.style.display = "";
			ProjectOptions.textarea.style.display = "none";
			projectOptionsText.style.display = "none";
		} else {
			openFLTargetList.style.display = "none";
			openFLTargetText.style.display = "none";
			ProjectOptions.textarea.style.display = "";
			projectOptionsText.style.display = "";
		}
	};
	page.appendChild(projectTargetList);
	page.appendChild(js.Browser.document.createElement("br"));
	page.appendChild(js.Browser.document.createElement("br"));
	page.appendChild(projectOptionsText);
	page.appendChild(ProjectOptions.textarea);
	page.appendChild(js.Browser.document.createElement("br"));
	page.appendChild(openFLTargetText);
	var _g = 0, _g1 = ["flash","html5","neko","android","blackberry","emscripten","webos","tizen","ios","windows","mac","linux"];
	while(_g < _g1.length) {
		var target = _g1[_g];
		++_g;
		openFLTargetList.appendChild(ProjectOptions.createListItem(target));
	}
	page.appendChild(openFLTargetList);
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
Main.dependencies = ["boyan.bootstrap.script","boyan.management.project-access"];
js.Browser.document = typeof window != "undefined" ? window.document : null;
Main.main();
})();

//@ sourceMappingURL=Main.js.map