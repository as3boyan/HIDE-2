(function ($hx_exports) { "use strict";
var ContextMenu = function() { };
ContextMenu.__name__ = true;
ContextMenu.createContextMenu = function() {
	var contextMenu;
	var _this = window.document;
	contextMenu = _this.createElement("div");
	contextMenu.className = "dropdown";
	contextMenu.style.position = "absolute";
	contextMenu.style.display = "none";
	window.document.addEventListener("click",function(e) {
		contextMenu.style.display = "none";
	});
	var ul;
	var _this1 = window.document;
	ul = _this1.createElement("ul");
	ul.className = "dropdown-menu";
	ul.style.display = "block";
	ContextMenu.menuItems = new haxe.ds.StringMap();
	ContextMenu.addContextMenuItemToStringMap("New File...",function() {
		Bootbox.prompt("Filename:","New.hx",function(result) {
			var filename = result;
			var template = "";
			if(filename != null) {
				var extname = js.Node.require("path").extname(filename);
				var pathToFile;
				if(extname == ".hx") {
					var name = js.Node.require("path").basename(filename,extname);
					name = HxOverrides.substr(name,0,1).toUpperCase() + HxOverrides.substr(name,1,null).toLowerCase();
					name = StringTools.replace(name," ","");
					template = "package ;\n\nclass " + name + "\n{\n    public function new()\n    {\n\n    }\n}";
					pathToFile = js.Node.require("path").join(ContextMenu.path,name + ".hx");
				} else pathToFile = js.Node.require("path").join(ContextMenu.path,filename);
				js.Node.require("fs").writeFile(pathToFile,template,"utf8",function(error) {
					FileTree.onFileClick(pathToFile);
					FileTree.load();
				});
			}
		});
	});
	ContextMenu.addContextMenuItemToStringMap("New Folder...",function() {
		Bootbox.prompt("Folder name:","New Folder",function(result1) {
			var dirname = result1;
			if(dirname != null) js.Node.require("fs").mkdir(js.Node.require("path").join(ContextMenu.path,dirname),null,function(error1) {
				FileTree.load();
			});
		});
	});
	ContextMenu.addContextMenuItemToStringMap("Open File",function() {
		FileTree.onFileClick(ContextMenu.path);
	});
	ContextMenu.addContextMenuItemToStringMap("Open using OS",function() {
		nodejs.webkit.Shell.openItem(ContextMenu.path);
	});
	ContextMenu.addContextMenuItemToStringMap("Show Item In Folder",function() {
		nodejs.webkit.Shell.showItemInFolder(ContextMenu.path);
	});
	ContextMenu.addContextMenuItemToStringMap("Refresh",FileTree.load);
	ul.appendChild(ContextMenu.menuItems.get("New File..."));
	ul.appendChild(ContextMenu.menuItems.get("New Folder..."));
	ul.appendChild(ContextMenu.menuItems.get("Open File"));
	ul.appendChild(ContextMenu.menuItems.get("Open using OS"));
	ul.appendChild(ContextMenu.menuItems.get("Show Item In Folder"));
	ul.appendChild(ContextMenu.menuItems.get("Refresh"));
	contextMenu.appendChild(ul);
	window.document.body.appendChild(contextMenu);
	FileTree.treeWell.addEventListener("contextmenu",function(ev) {
		ContextMenu.itemType = (js.Boot.__cast(ev.target , Element)).getAttribute("itemType");
		ContextMenu.path = (js.Boot.__cast(ev.target , Element)).getAttribute("path");
		ContextMenu.menuItems.get("New File...").style.display = "none";
		ContextMenu.menuItems.get("New Folder...").style.display = "none";
		ContextMenu.menuItems.get("Open File").style.display = "none";
		ContextMenu.menuItems.get("Open using OS").style.display = "none";
		ContextMenu.menuItems.get("Show Item In Folder").style.display = "none";
		if(ContextMenu.itemType != null) {
			var _g = ContextMenu.itemType;
			switch(_g) {
			case "file":
				ContextMenu.menuItems.get("Open File").style.display = "";
				ContextMenu.menuItems.get("Open using OS").style.display = "";
				ContextMenu.menuItems.get("Show Item In Folder").style.display = "";
				break;
			case "folder":
				ContextMenu.menuItems.get("New File...").style.display = "";
				ContextMenu.menuItems.get("New Folder...").style.display = "";
				ContextMenu.menuItems.get("Show Item In Folder").style.display = "";
				break;
			default:
			}
		}
		ev.preventDefault();
		contextMenu.style.display = "block";
		contextMenu.style.left = "" + ev.pageX + "px";
		contextMenu.style.top = "" + ev.pageY + "px";
		return false;
	});
};
ContextMenu.createContextMenuItem = function(text,onClick) {
	var li;
	var _this = window.document;
	li = _this.createElement("li");
	li.onclick = function(e) {
		onClick();
	};
	var a;
	var _this1 = window.document;
	a = _this1.createElement("a");
	a.href = "#";
	a.textContent = text;
	li.appendChild(a);
	return li;
};
ContextMenu.addContextMenuItemToStringMap = function(text,onClick) {
	ContextMenu.menuItems.set(text,ContextMenu.createContextMenuItem(text,onClick));
};
var FileTree = $hx_exports.FileTree = function() { };
FileTree.__name__ = true;
FileTree.init = function() {
	var splitPaneComponent;
	splitPaneComponent = js.Boot.__cast(Splitpane.components[0] , HTMLDivElement);
	var _this = window.document;
	FileTree.treeWell = _this.createElement("div");
	FileTree.treeWell.id = "tree-well";
	FileTree.treeWell.className = "well";
	var tree;
	var _this1 = window.document;
	tree = _this1.createElement("ul");
	tree.className = "nav nav-list";
	tree.id = "tree";
	tree.style.padding = "5px 0px";
	FileTree.treeWell.appendChild(tree);
	splitPaneComponent.appendChild(FileTree.treeWell);
	FileTree.load("HIDE","../");
	ContextMenu.createContextMenu();
};
FileTree.load = function(projectName,path) {
	if(projectName == null) projectName = FileTree.lastProjectName;
	if(path == null) path = FileTree.lastProjectPath;
	var tree;
	tree = js.Boot.__cast(window.document.getElementById("tree") , HTMLUListElement);
	new $(tree).children().remove();
	var rootTreeElement = FileTree.createDirectoryElement(projectName,path);
	tree.appendChild(rootTreeElement);
	FileTree.readDir(path,rootTreeElement);
	FileTree.lastProjectName = projectName;
	FileTree.lastProjectPath = path;
};
FileTree.createDirectoryElement = function(text,path) {
	var directoryElement;
	var _this = window.document;
	directoryElement = _this.createElement("li");
	var a;
	var _this1 = window.document;
	a = _this1.createElement("a");
	a.className = "tree-toggler nav-header";
	a.href = "#";
	a.setAttribute("path",path);
	a.setAttribute("itemType","folder");
	var span;
	var _this2 = window.document;
	span = _this2.createElement("span");
	span.className = "glyphicon glyphicon-folder-open";
	span.setAttribute("path",path);
	span.setAttribute("itemType","folder");
	a.appendChild(span);
	var _this3 = window.document;
	span = _this3.createElement("span");
	span.textContent = text;
	span.style.marginLeft = "5px";
	span.setAttribute("path",path);
	span.setAttribute("itemType","folder");
	a.appendChild(span);
	a.onclick = function(e) {
		new $(directoryElement).children("ul.tree").toggle(300);
	};
	directoryElement.appendChild(a);
	var ul;
	var _this4 = window.document;
	ul = _this4.createElement("ul");
	ul.className = "nav nav-list tree";
	directoryElement.appendChild(ul);
	return directoryElement;
};
FileTree.readDir = function(path,topElement) {
	js.Node.require("fs").readdir(path,function(error,files) {
		if(files != null) {
			var foldersCount = 0;
			var _g = 0;
			while(_g < files.length) {
				var file = [files[_g]];
				++_g;
				var filePath = [js.Node.require("path").join(path,file[0])];
				js.Node.require("fs").stat(filePath[0],(function(filePath,file) {
					return function(error1,stat) {
						if(stat.isFile()) {
							var li;
							var _this = window.document;
							li = _this.createElement("li");
							var a;
							var _this1 = window.document;
							a = _this1.createElement("a");
							a.href = "#";
							a.textContent = file[0];
							a.title = filePath[0];
							a.setAttribute("path",filePath[0]);
							a.setAttribute("itemType","file");
							a.onclick = (function(filePath) {
								return function(e) {
									if(FileTree.onFileClick != null) FileTree.onFileClick(filePath[0]);
								};
							})(filePath);
							if(StringTools.endsWith(file[0],".hx")) a.style.fontWeight = "bold"; else if(StringTools.endsWith(file[0],".hxml")) {
								a.style.fontWeight = "bold";
								a.style.color = "gray";
							} else a.style.color = "gray";
							li.appendChild(a);
							var ul;
							ul = js.Boot.__cast(topElement.getElementsByTagName("ul")[0] , HTMLUListElement);
							ul.appendChild(li);
						} else if(!StringTools.startsWith(file[0],".")) {
							var ul1;
							ul1 = js.Boot.__cast(topElement.getElementsByTagName("ul")[0] , HTMLUListElement);
							var directoryElement = FileTree.createDirectoryElement(file[0],filePath[0]);
							directoryElement.onclick = (function(filePath) {
								return function(e1) {
									if(directoryElement.getElementsByTagName("ul")[0].childNodes.length == 0) {
										FileTree.readDir(filePath[0],directoryElement);
										e1.stopPropagation();
										e1.preventDefault();
										directoryElement.onclick = null;
									}
								};
							})(filePath);
							ul1.appendChild(directoryElement);
							ul1.insertBefore(directoryElement,ul1.childNodes[foldersCount]);
							foldersCount++;
						}
					};
				})(filePath,file));
			}
			new $(topElement).children("ul.tree").show(300);
		}
	});
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
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
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.jquery.layout","boyan.jquery.split-pane","boyan.window.splitpane"],Main.load,true);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/file-tree.css"]);
};
Main.load = function() {
	FileTree.init();
	HIDE.notifyLoadingComplete(Main.$name);
};
var IMap = function() { };
IMap.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var haxe = {};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,__class__: haxe.ds.StringMap
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
js.Node = function() { };
js.Node.__name__ = true;
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
nodejs.webkit.$ui.__name__ = true;
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
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
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Shell = nodejs.webkit.$ui.Shell;
Main.$name = "boyan.bootstrap.file-tree";
Main.dependencies = ["boyan.bootstrap.script","boyan.bootstrap.bootbox"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map