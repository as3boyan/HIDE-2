(function ($hx_exports) { "use strict";
var HxOverrides = function() { };
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
};
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.jquery.layout","boyan.window.splitpane"],Main.load,true);
};
Main.load = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		ProjectOptions.create();
		HIDE.notifyLoadingComplete(Main.$name);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/project-options.css"]);
};
var ProjectOptions = $hx_exports.ProjectOptions = function() { };
ProjectOptions.create = function() {
	var page;
	var _this = window.document;
	page = _this.createElement("div");
	var _this1 = window.document;
	ProjectOptions.projectOptionsText = _this1.createElement("p");
	ProjectOptions.projectOptionsText.id = "project-options-text";
	ProjectOptions.projectOptionsText.className = "custom-font-size";
	ProjectOptions.projectOptionsText.innerText = "Project arguments:";
	var _this2 = window.document;
	ProjectOptions.textarea = _this2.createElement("textarea");
	ProjectOptions.textarea.id = "project-options-textarea";
	ProjectOptions.textarea.className = "custom-font-size";
	ProjectOptions.textarea.onchange = function(e) {
		ProjectAccess.currentProject.args = ProjectOptions.textarea.value.split("\n");
		ProjectAccess.save();
	};
	var _this3 = window.document;
	ProjectOptions.projectTargetText = _this3.createElement("p");
	ProjectOptions.projectTargetText.innerText = "Project target:";
	ProjectOptions.projectTargetText.className = "custom-font-size";
	page.appendChild(ProjectOptions.projectTargetText);
	var _this4 = window.document;
	ProjectOptions.projectTargetList = _this4.createElement("select");
	ProjectOptions.projectTargetList.id = "project-options-project-target";
	ProjectOptions.projectTargetList.className = "custom-font-size";
	ProjectOptions.projectTargetList.style.width = "100%";
	var _this5 = window.document;
	ProjectOptions.openFLTargetList = _this5.createElement("select");
	ProjectOptions.openFLTargetList.id = "project-options-openfl-target";
	ProjectOptions.openFLTargetList.className = "custom-font-size";
	ProjectOptions.openFLTargetList.style.width = "100%";
	var _this6 = window.document;
	ProjectOptions.openFLTargetText = _this6.createElement("p");
	ProjectOptions.openFLTargetText.innerText = "OpenFL target:";
	ProjectOptions.openFLTargetText.className = "custom-font-size";
	var _g = 0;
	var _g1 = ["Flash","JavaScript","Neko","OpenFL","PHP","C++","Java","C#"];
	while(_g < _g1.length) {
		var target = _g1[_g];
		++_g;
		ProjectOptions.projectTargetList.appendChild(ProjectOptions.createListItem(target));
	}
	ProjectOptions.projectTargetList.disabled = true;
	ProjectOptions.projectTargetList.onchange = ProjectOptions.update;
	ProjectOptions.openFLTargets = ["flash","html5","neko","android","blackberry","emscripten","webos","tizen","ios","windows","mac","linux"];
	var _g2 = 0;
	var _g11 = ProjectOptions.openFLTargets;
	while(_g2 < _g11.length) {
		var target1 = _g11[_g2];
		++_g2;
		ProjectOptions.openFLTargetList.appendChild(ProjectOptions.createListItem(target1));
	}
	ProjectOptions.openFLTargetList.onchange = function(_) {
		ProjectAccess.currentProject.openFLTarget = ProjectOptions.openFLTargets[ProjectOptions.openFLTargetList.selectedIndex];
		ProjectAccess.currentProject.buildActionCommand = ["haxelib","run","openfl","build",HIDE.surroundWithQuotes(js.Node.require("path").join(ProjectAccess.currentProject.path,"project.xml")),ProjectAccess.currentProject.openFLTarget].join(" ");
		ProjectAccess.currentProject.runActionType = 2;
		ProjectAccess.currentProject.runActionText = ["haxelib","run","openfl","test",HIDE.surroundWithQuotes(js.Node.require("path").join(ProjectAccess.currentProject.path,"project.xml")),ProjectAccess.currentProject.openFLTarget].join(" ");
		ProjectOptions.updateProjectOptions();
	};
	var _this7 = window.document;
	ProjectOptions.runActionDescription = _this7.createElement("p");
	ProjectOptions.runActionDescription.className = "custom-font-size";
	ProjectOptions.runActionDescription.innerText = "Run action:";
	var _this8 = window.document;
	ProjectOptions.runActionTextAreaDescription = _this8.createElement("p");
	ProjectOptions.runActionTextAreaDescription.innerText = "URL:";
	ProjectOptions.runActionTextAreaDescription.className = "custom-font-size";
	var actions = ["Open URL","Open File","Run command"];
	var _this9 = window.document;
	ProjectOptions.runActionList = _this9.createElement("select");
	ProjectOptions.runActionList.style.width = "100%";
	ProjectOptions.runActionList.onchange = ProjectOptions.update;
	var _g3 = 0;
	while(_g3 < actions.length) {
		var action = actions[_g3];
		++_g3;
		ProjectOptions.runActionList.appendChild(ProjectOptions.createListItem(action));
	}
	var _this10 = window.document;
	ProjectOptions.actionTextArea = _this10.createElement("textarea");
	ProjectOptions.actionTextArea.id = "project-options-action-textarea";
	ProjectOptions.actionTextArea.className = "custom-font-size";
	ProjectOptions.actionTextArea.onchange = function(e1) {
		ProjectAccess.currentProject.runActionText = ProjectOptions.actionTextArea.value;
		ProjectAccess.save();
	};
	var _this11 = window.document;
	ProjectOptions.buildActionDescription = _this11.createElement("p");
	ProjectOptions.buildActionDescription.className = "custom-font-size";
	ProjectOptions.buildActionDescription.innerText = "Build command:";
	var _this12 = window.document;
	ProjectOptions.buildActionTextArea = _this12.createElement("textarea");
	ProjectOptions.buildActionTextArea.id = "project-options-build-action-textarea";
	ProjectOptions.buildActionTextArea.className = "custom-font-size";
	ProjectOptions.buildActionTextArea.onchange = function(e2) {
		ProjectAccess.currentProject.buildActionCommand = ProjectOptions.buildActionTextArea.value;
		ProjectAccess.save();
	};
	page.appendChild(ProjectOptions.projectTargetList);
	page.appendChild((function($this) {
		var $r;
		var _this13 = window.document;
		$r = _this13.createElement("br");
		return $r;
	}(this)));
	page.appendChild((function($this) {
		var $r;
		var _this14 = window.document;
		$r = _this14.createElement("br");
		return $r;
	}(this)));
	page.appendChild(ProjectOptions.buildActionDescription);
	page.appendChild(ProjectOptions.buildActionTextArea);
	page.appendChild((function($this) {
		var $r;
		var _this15 = window.document;
		$r = _this15.createElement("br");
		return $r;
	}(this)));
	page.appendChild((function($this) {
		var $r;
		var _this16 = window.document;
		$r = _this16.createElement("br");
		return $r;
	}(this)));
	page.appendChild(ProjectOptions.projectOptionsText);
	page.appendChild(ProjectOptions.textarea);
	page.appendChild((function($this) {
		var $r;
		var _this17 = window.document;
		$r = _this17.createElement("br");
		return $r;
	}(this)));
	page.appendChild(ProjectOptions.openFLTargetText);
	page.appendChild(ProjectOptions.openFLTargetList);
	page.appendChild((function($this) {
		var $r;
		var _this18 = window.document;
		$r = _this18.createElement("br");
		return $r;
	}(this)));
	page.appendChild((function($this) {
		var $r;
		var _this19 = window.document;
		$r = _this19.createElement("br");
		return $r;
	}(this)));
	page.appendChild(ProjectOptions.runActionDescription);
	page.appendChild(ProjectOptions.runActionList);
	page.appendChild((function($this) {
		var $r;
		var _this20 = window.document;
		$r = _this20.createElement("br");
		return $r;
	}(this)));
	page.appendChild((function($this) {
		var $r;
		var _this21 = window.document;
		$r = _this21.createElement("br");
		return $r;
	}(this)));
	page.appendChild(ProjectOptions.runActionTextAreaDescription);
	page.appendChild(ProjectOptions.actionTextArea);
	Splitpane.components[3].appendChild(page);
};
ProjectOptions.getProjectArguments = function() {
	return ProjectOptions.textarea.value;
};
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
	if(ProjectAccess.currentProject.type == 2) {
		ProjectOptions.openFLTargetList.style.display = "none";
		ProjectOptions.openFLTargetText.style.display = "none";
		ProjectOptions.textarea.style.display = "none";
		ProjectOptions.projectOptionsText.style.display = "none";
		ProjectOptions.buildActionTextArea.style.display = "none";
		ProjectOptions.buildActionDescription.style.display = "none";
		ProjectOptions.runActionTextAreaDescription.style.display = "none";
		ProjectOptions.runActionList.style.display = "none";
		ProjectOptions.runActionDescription.style.display = "none";
		ProjectOptions.projectTargetList.style.display = "none";
		ProjectOptions.projectTargetText.style.display = "none";
		ProjectOptions.actionTextArea.style.display = "none";
	} else {
		ProjectOptions.buildActionTextArea.style.display = "";
		ProjectOptions.buildActionDescription.style.display = "";
		ProjectOptions.runActionTextAreaDescription.style.display = "";
		ProjectOptions.runActionList.style.display = "";
		ProjectOptions.runActionDescription.style.display = "";
		ProjectOptions.projectTargetList.style.display = "";
		ProjectOptions.projectTargetText.style.display = "";
		ProjectOptions.actionTextArea.style.display = "";
	}
	var _g = ProjectOptions.runActionList.selectedIndex;
	switch(_g) {
	case 0:
		ProjectOptions.runActionTextAreaDescription.innerText = "URL: ";
		ProjectAccess.currentProject.runActionType = 0;
		break;
	case 1:
		ProjectOptions.runActionTextAreaDescription.innerText = "Path: ";
		ProjectAccess.currentProject.runActionType = 1;
		break;
	case 2:
		ProjectOptions.runActionTextAreaDescription.innerText = "Command: ";
		ProjectAccess.currentProject.runActionType = 2;
		break;
	default:
	}
	ProjectAccess.save();
};
ProjectOptions.updateProjectOptions = function() {
	if(ProjectAccess.currentProject.type == 1) {
		ProjectOptions.projectTargetList.selectedIndex = 3;
		var i = Lambda.indexOf(ProjectOptions.openFLTargets,ProjectAccess.currentProject.openFLTarget);
		if(i != -1) ProjectOptions.openFLTargetList.selectedIndex = i; else ProjectOptions.openFLTargetList.selectedIndex = 0;
	} else {
		var _g = ProjectAccess.currentProject.target;
		switch(_g) {
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
		ProjectOptions.textarea.value = ProjectAccess.currentProject.args.join("\n");
	}
	ProjectOptions.buildActionTextArea.value = ProjectAccess.currentProject.buildActionCommand;
	var _g1 = ProjectAccess.currentProject.runActionType;
	switch(_g1) {
	case 0:
		ProjectOptions.runActionList.selectedIndex = 0;
		break;
	case 1:
		ProjectOptions.runActionList.selectedIndex = 1;
		break;
	case 2:
		ProjectOptions.runActionList.selectedIndex = 2;
		break;
	default:
	}
	ProjectOptions.actionTextArea.value = ProjectAccess.currentProject.runActionText;
	ProjectOptions.update(null);
};
ProjectOptions.createListItem = function(text) {
	var option;
	var _this = window.document;
	option = _this.createElement("option");
	option.textContent = text;
	option.value = text;
	return option;
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var js = {};
js.Node = function() { };
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
var module, setImmediate, clearImmediate;
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
var version = HxOverrides.substr(js.Node.process.version,1,null).split(".").map(Std.parseInt);
if(version[0] > 0 || version[1] >= 9) {
	js.Node.setImmediate = setImmediate;
	js.Node.clearImmediate = clearImmediate;
}
Main.$name = "boyan.bootstrap.project-options";
Main.dependencies = ["boyan.bootstrap.script","boyan.management.project-access"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map