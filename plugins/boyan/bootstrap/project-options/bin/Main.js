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
$hxExpose(ProjectOptions, "ProjectOptions");
ProjectOptions.create = function() {
	var page = js.Browser.document.createElement("div");
	ProjectOptions.projectOptionsText = js.Browser.document.createElement("p");
	ProjectOptions.projectOptionsText.id = "project-options-text";
	ProjectOptions.projectOptionsText.innerText = "Project arguments:";
	ProjectOptions.textarea = js.Browser.document.createElement("textarea");
	ProjectOptions.textarea.id = "project-options-textarea";
	ProjectOptions.textarea.onchange = function(e) {
		ProjectAccess.currentProject.args = ProjectOptions.textarea.value.split("\n");
	};
	ProjectOptions.projectTargetText = js.Browser.document.createElement("p");
	ProjectOptions.projectTargetText.innerText = "Project target:";
	page.appendChild(ProjectOptions.projectTargetText);
	ProjectOptions.projectTargetList = js.Browser.document.createElement("select");
	ProjectOptions.projectTargetList.id = "project-options-project-target";
	ProjectOptions.openFLTargetList = js.Browser.document.createElement("select");
	ProjectOptions.openFLTargetList.id = "project-options-openfl-target";
	ProjectOptions.openFLTargetText = js.Browser.document.createElement("p");
	ProjectOptions.openFLTargetText.innerText = "OpenFL target:";
	var _g = 0, _g1 = ["Flash","JavaScript","Neko","OpenFL","PHP","C++","Java","C#"];
	while(_g < _g1.length) {
		var target = _g1[_g];
		++_g;
		ProjectOptions.projectTargetList.appendChild(ProjectOptions.createListItem(target));
	}
	ProjectOptions.projectTargetList.disabled = true;
	ProjectOptions.projectTargetList.onchange = ProjectOptions.update;
	page.appendChild(ProjectOptions.projectTargetList);
	page.appendChild(js.Browser.document.createElement("br"));
	page.appendChild(js.Browser.document.createElement("br"));
	page.appendChild(ProjectOptions.projectOptionsText);
	page.appendChild(ProjectOptions.textarea);
	page.appendChild(js.Browser.document.createElement("br"));
	page.appendChild(ProjectOptions.openFLTargetText);
	var openFLTargets = ["flash","html5","neko","android","blackberry","emscripten","webos","tizen","ios","windows","mac","linux"];
	var _g = 0;
	while(_g < openFLTargets.length) {
		var target = openFLTargets[_g];
		++_g;
		ProjectOptions.openFLTargetList.appendChild(ProjectOptions.createListItem(target));
	}
	ProjectOptions.openFLTargetList.onchange = function(_) {
		ProjectAccess.currentProject.openFLTarget = openFLTargets[ProjectOptions.openFLTargetList.selectedIndex];
	};
	page.appendChild(ProjectOptions.openFLTargetList);
	Splitpane.components[3].appendChild(page);
}
ProjectOptions.getProjectArguments = function() {
	return ProjectOptions.textarea.value;
}
ProjectOptions.update = function(_) {
	if(ProjectOptions.projectTargetList.selectedIndex == 3) {
		ProjectOptions.openFLTargetList.style.display = "";
		ProjectOptions.openFLTargetText.style.display = "";
		ProjectOptions.textarea.style.display = "none";
		ProjectOptions.projectOptionsText.style.display = "none";
	} else {
		ProjectOptions.openFLTargetList.style.display = "none";
		ProjectOptions.openFLTargetText.style.display = "none";
		ProjectOptions.textarea.style.display = "";
		ProjectOptions.projectOptionsText.style.display = "";
	}
}
ProjectOptions.updateProjectOptions = function() {
	if(ProjectAccess.currentProject.type == 1) ProjectOptions.projectTargetList.selectedIndex = 3; else {
		var _g = ProjectAccess;
		switch(_g.currentProject.target) {
		case 0:
			ProjectOptions.projectTargetList.selectedIndex = 0;
			break;
		case 1:
			ProjectOptions.projectTargetList.selectedIndex = 1;
			break;
		case 6:
			ProjectOptions.projectTargetList.selectedIndex = 2;
			break;
		case 2:
			ProjectOptions.projectTargetList.selectedIndex = 4;
			break;
		case 3:
			ProjectOptions.projectTargetList.selectedIndex = 5;
			break;
		case 4:
			ProjectOptions.projectTargetList.selectedIndex = 6;
			break;
		case 5:
			ProjectOptions.projectTargetList.selectedIndex = 7;
			break;
		default:
		}
	}
	ProjectOptions.update(null);
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
function $hxExpose(src, path) {
	var o = typeof window != "undefined" ? window : exports;
	var parts = path.split(".");
	for(var ii = 0; ii < parts.length-1; ++ii) {
		var p = parts[ii];
		if(typeof o[p] == "undefined") o[p] = {};
		o = o[p];
	}
	o[parts[parts.length-1]] = src;
}
})();

//@ sourceMappingURL=Main.js.map