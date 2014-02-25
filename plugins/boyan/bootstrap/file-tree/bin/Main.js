(function () { "use strict";
var FileTree = function() { }
$hxExpose(FileTree, "FileTree");
FileTree.__name__ = true;
FileTree.init = function() {
	var splitPaneComponent = js.Boot.__cast(Splitpane.components[0] , HTMLDivElement);
	var treeWell = js.Browser.document.createElement("div");
	treeWell.id = "tree-well";
	treeWell.className = "well";
	treeWell.style.overflow = "auto";
	treeWell.style.padding = "0";
	treeWell.style.margin = "0";
	treeWell.style.width = "100%";
	treeWell.style.height = "100%";
	treeWell.style.fontSize = "10pt";
	treeWell.style.lineHeight = "1";
	var tree = js.Browser.document.createElement("ul");
	tree.className = "nav nav-list";
	tree.id = "tree";
	tree.style.padding = "5px 0px";
	treeWell.appendChild(tree);
	splitPaneComponent.appendChild(treeWell);
	FileTree.load("HIDE");
}
FileTree.load = function(projectName,path) {
	if(path == null) path = "./";
	var tree = js.Boot.__cast(js.Browser.document.getElementById("tree") , HTMLUListElement);
	new $(tree).children().remove();
	var rootTreeElement = FileTree.createDirectoryElement(projectName);
	tree.appendChild(rootTreeElement);
	FileTree.readDir(path,rootTreeElement);
}
FileTree.createDirectoryElement = function(text) {
	var directoryElement = js.Browser.document.createElement("li");
	var a = js.Browser.document.createElement("a");
	a.className = "tree-toggler nav-header";
	a.href = "#";
	var span = js.Browser.document.createElement("span");
	span.className = "glyphicon glyphicon-folder-open";
	a.appendChild(span);
	span = js.Browser.document.createElement("span");
	span.textContent = text;
	span.style.marginLeft = "5px";
	a.appendChild(span);
	a.onclick = function(e) {
		new $(directoryElement).children("ul.tree").toggle(300);
	};
	directoryElement.appendChild(a);
	var ul = js.Browser.document.createElement("ul");
	ul.className = "nav nav-list tree";
	directoryElement.appendChild(ul);
	return directoryElement;
}
FileTree.readDir = function(path,topElement) {
	js.Node.require("fs").readdir(path,function(error,files) {
		var foldersCount = 0;
		var _g = 0;
		while(_g < files.length) {
			var file = [files[_g]];
			++_g;
			var filePath = [js.Node.require("path").join(path,file[0])];
			js.Node.require("fs").stat(filePath[0],(function(filePath,file) {
				return function(error1,stat) {
					if(stat.isFile()) {
						var li = js.Browser.document.createElement("li");
						var a = js.Browser.document.createElement("a");
						a.href = "#";
						a.textContent = file[0];
						a.title = filePath[0];
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
						var ul = js.Boot.__cast(topElement.getElementsByTagName("ul")[0] , HTMLUListElement);
						ul.appendChild(li);
					} else if(!StringTools.startsWith(file[0],".")) {
						var ul = js.Boot.__cast(topElement.getElementsByTagName("ul")[0] , HTMLUListElement);
						var directoryElement = FileTree.createDirectoryElement(file[0]);
						directoryElement.onclick = (function(filePath) {
							return function(e) {
								if(directoryElement.getElementsByTagName("ul")[0].childNodes.length == 0) {
									FileTree.readDir(filePath[0],directoryElement);
									e.stopPropagation();
									e.preventDefault();
									directoryElement.onclick = null;
								}
							};
						})(filePath);
						ul.appendChild(directoryElement);
						ul.insertBefore(directoryElement,ul.childNodes[foldersCount]);
						foldersCount++;
					}
				};
			})(filePath,file));
		}
		new $(topElement).children("ul.tree").show(300);
	});
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
var Main = function() { }
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.jquery.layout","boyan.jquery.split-pane"],Main.load,true);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/file-tree.css"]);
}
Main.load = function() {
	FileTree.init();
	HIDE.notifyLoadingComplete(Main.$name);
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
var StringTools = function() { }
StringTools.__name__ = true;
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
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
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
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
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
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
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Browser = function() { }
js.Browser.__name__ = true;
js.Node = function() { }
js.Node.__name__ = true;
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
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
Main.$name = "boyan.bootstrap.file-tree";
Main.dependencies = ["boyan.bootstrap.script"];
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