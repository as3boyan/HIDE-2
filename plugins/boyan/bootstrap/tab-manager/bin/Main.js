(function () { "use strict";
var CMDoc = function(_name,_doc,_path) {
	this.name = _name;
	this.doc = _doc;
	this.path = _path;
};
CMDoc.__name__ = true;
CMDoc.prototype = {
	__class__: CMDoc
}
var ContextMenu = function() { }
ContextMenu.__name__ = true;
ContextMenu.createContextMenu = function() {
	var contextMenu = js.Browser.document.createElement("div");
	contextMenu.className = "dropdown";
	contextMenu.style.position = "absolute";
	contextMenu.style.display = "none";
	js.Browser.document.onclick = function(e) {
		contextMenu.style.display = "none";
	};
	var ul = js.Browser.document.createElement("ul");
	ul.className = "dropdown-menu";
	ul.style.display = "block";
	ul.appendChild(ContextMenu.createContextMenuItem("New File...",TabManager.createFileInNewTab));
	var li = js.Browser.document.createElement("li");
	li.className = "divider";
	ul.appendChild(li);
	ul.appendChild(ContextMenu.createContextMenuItem("Close",function() {
		TabManager.closeTab(contextMenu.getAttribute("path"));
	}));
	ul.appendChild(ContextMenu.createContextMenuItem("Close All",function() {
		TabManager.closeAll();
	}));
	ul.appendChild(ContextMenu.createContextMenuItem("Close Other",function() {
		var path = contextMenu.getAttribute("path");
		TabManager.closeOthers(path);
	}));
	contextMenu.appendChild(ul);
	js.Browser.document.body.appendChild(contextMenu);
	TabManager.tabs.addEventListener("contextmenu",function(ev) {
		ev.preventDefault();
		var clickedOnTab = false;
		var _g = 0, _g1 = TabManager.tabs.childNodes;
		while(_g < _g1.length) {
			var li1 = _g1[_g];
			++_g;
			if(ev.target == li1) {
				clickedOnTab = true;
				break;
			}
		}
		if(clickedOnTab) {
			var li1 = js.Boot.__cast(ev.target , HTMLLIElement);
			contextMenu.setAttribute("path",li1.getAttribute("path"));
			contextMenu.style.display = "block";
			contextMenu.style.left = Std.string(ev.pageX) + "px";
			contextMenu.style.top = Std.string(ev.pageY) + "px";
		}
		return false;
	});
}
ContextMenu.createContextMenuItem = function(text,onClick) {
	var li = js.Browser.document.createElement("li");
	li.onclick = function(e) {
		onClick();
	};
	var a = js.Browser.document.createElement("a");
	a.href = "#";
	a.textContent = text;
	li.appendChild(a);
	return li;
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
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Lambda = function() { }
Lambda.__name__ = true;
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
var Main = function() { }
Main.__name__ = true;
Main.main = function() {
	HIDE.loadCSS(Main.$name,["bin/includes/css/tabs.css"]);
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.jquery.layout"],Main.load);
}
Main.load = function() {
	TabManager.init();
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.bootstrap.file-tree","boyan.events.hotkey"],function() {
		FileTree.onFileClick = TabManager.openFileInNewTab;
		Hotkeys.addHotkey(9,true,false,false,TabManager.showNextTab);
		Hotkeys.addHotkey(9,true,true,false,TabManager.showPreviousTab);
		Hotkeys.addHotkey(87,true,false,false,TabManager.closeActiveTab);
	});
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
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
var TabManager = function() { }
$hxExpose(TabManager, "TabManager");
TabManager.__name__ = true;
TabManager.init = function() {
	TabManager.tabs = js.Browser.document.createElement("ul");
	TabManager.tabs.className = "tabs no-select";
	TabManager.tabs.onclick = function(e) {
		var target = e.target || e.srcElement;
		if(target.nodeName.toLowerCase() != "li") return;
		var i = 0;
		var c = target.parentNode.firstChild;
		if(c == target) return TabManager.selectDoc(0); else while(true) {
			i++;
			c = c.nextSibling;
			if(c == target) return TabManager.selectDoc(i);
		}
	};
	ContextMenu.createContextMenu();
	TabManager.docs = [];
	Splitpane.components[1].appendChild(TabManager.tabs);
}
TabManager.createNewTab = function(name,path) {
	var li = js.Browser.document.createElement("li");
	li.title = path;
	li.innerText = name + "\t";
	li.setAttribute("path",path);
	var span = js.Browser.document.createElement("span");
	span.style.position = "relative";
	span.style.top = "2px";
	span.onclick = function(e) {
		TabManager.closeTab(path);
	};
	var span2 = js.Browser.document.createElement("span");
	span2.className = "glyphicon glyphicon-remove-circle";
	span.appendChild(span2);
	li.appendChild(span);
	TabManager.tabs.appendChild(li);
}
TabManager.openFileInNewTab = function(path) {
	path = StringTools.replace(path,"\\",js.Node.require("path").sep);
	if(TabManager.isAlreadyOpened(path)) return;
	js.Node.require("fs").readFile(path,"utf8",function(error,code) {
		if(error != null) console.log(error);
		var mode = TabManager.getMode(path);
		var name = js.Node.require("path").basename(path);
		TabManager.docs.push(new CMDoc(name,new CodeMirror.Doc(code,mode),path));
		TabManager.createNewTab(name,path);
		TabManager.selectDoc(TabManager.docs.length - 1);
		TabManager.checkTabsCount();
	});
}
TabManager.createFileInNewTab = function() {
	FileDialog.saveFile(function(path) {
		var name = js.Node.require("path").basename(path);
		var mode = TabManager.getMode(name);
		var code = "";
		if(js.Node.require("path").extname(name) == ".hx") {
			path = HxOverrides.substr(path,0,path.length - name.length) + HxOverrides.substr(name,0,1).toUpperCase() + HxOverrides.substr(name,1,null);
			code = "package ;\n\nclass " + js.Node.require("path").basename(name) + "\n{\n\n}";
		}
		TabManager.docs.push(new CMDoc(name,new CodeMirror.Doc(code,mode),path));
		TabManager.createNewTab(name,path);
		TabManager.selectDoc(TabManager.docs.length - 1);
		TabManager.checkTabsCount();
	});
}
TabManager.checkTabsCount = function() {
	if(TabManager.editor != null) {
		if(TabManager.editor.getWrapperElement().style.display == "none" && TabManager.docs.length > 0) {
			TabManager.editor.getWrapperElement().style.display = "block";
			TabManager.editor.refresh();
		}
	}
}
TabManager.closeAll = function() {
	var _g1 = 0, _g = TabManager.docs.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(TabManager.docs[i] != null) TabManager.closeTab(TabManager.docs[i].path,false);
	}
	if(TabManager.docs.length > 0) haxe.Timer.delay(function() {
		TabManager.closeAll();
	},30);
}
TabManager.closeOthers = function(path) {
	var _g1 = 0, _g = TabManager.docs.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(TabManager.docs[i] != null && path != TabManager.docs[i].path) TabManager.closeTab(TabManager.docs[i].path,false);
	}
	if(TabManager.docs.length > 1) haxe.Timer.delay(function() {
		TabManager.closeOthers(path);
	},30); else TabManager.showNextTab();
}
TabManager.closeTab = function(path,switchToTab) {
	if(switchToTab == null) switchToTab = true;
	var _g1 = 0, _g = TabManager.docs.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(TabManager.docs[i] != null && TabManager.docs[i].path == path) {
			TabManager.docs.splice(i,1);
			(js.Boot.__cast(TabManager.tabs.children.item(i) , Element)).remove();
		}
	}
	if(TabManager.docs.length > 0) {
		if(switchToTab) TabManager.showPreviousTab();
	} else if(TabManager.editor != null) TabManager.editor.getWrapperElement().style.display = "none";
}
TabManager.closeActiveTab = function() {
	var n = Lambda.indexOf(TabManager.docs,TabManager.curDoc);
	TabManager.docs.splice(n,1);
	(js.Boot.__cast(TabManager.tabs.children.item(n) , Element)).remove();
	if(TabManager.docs.length > 0) TabManager.showPreviousTab(); else if(TabManager.editor != null) TabManager.editor.getWrapperElement().style.display = "none";
}
TabManager.showNextTab = function() {
	var n = Lambda.indexOf(TabManager.docs,TabManager.curDoc);
	n++;
	if(n > TabManager.docs.length - 1) n = 0;
	TabManager.selectDoc(n);
}
TabManager.showPreviousTab = function() {
	var n = Lambda.indexOf(TabManager.docs,TabManager.curDoc);
	n--;
	if(n < 0) n = TabManager.docs.length - 1;
	TabManager.selectDoc(n);
}
TabManager.isAlreadyOpened = function(path) {
	var opened = false;
	var _g1 = 0, _g = TabManager.docs.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(TabManager.docs[i].path == path) {
			TabManager.selectDoc(i);
			opened = true;
			break;
		}
	}
	return opened;
}
TabManager.getMode = function(path) {
	var mode = "haxe";
	var _g = js.Node.require("path").extname(path);
	switch(_g) {
	case ".js":
		mode = "javascript";
		break;
	case ".css":
		mode = "css";
		break;
	case ".xml":
		mode = "xml";
		break;
	case ".html":
		mode = "text/html";
		break;
	case ".md":
		mode = "markdown";
		break;
	case ".sh":case ".bat":
		mode = "shell";
		break;
	case ".ml":
		mode = "ocaml";
		break;
	default:
	}
	return mode;
}
TabManager.selectDoc = function(pos) {
	var _g1 = 0, _g = TabManager.tabs.childNodes.length;
	while(_g1 < _g) {
		var i = _g1++;
		var child = js.Boot.__cast(TabManager.tabs.childNodes[i] , Element);
		if(pos == i) child.className = "selected"; else child.className = "";
	}
	TabManager.curDoc = TabManager.docs[pos];
	if(TabManager.editor != null) TabManager.editor.swapDoc(TabManager.curDoc.doc);
}
TabManager.getCurrentDocumentPath = function() {
	var path = null;
	if(TabManager.curDoc != null) path = TabManager.curDoc.path;
	return path;
}
var haxe = {}
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = true;
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.prototype = {
	run: function() {
		console.log("run");
	}
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,__class__: haxe.Timer
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
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
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
Main.$name = "boyan.bootstrap.tab-manager";
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