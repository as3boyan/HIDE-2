(function () { "use strict";
var IMap = function() { }
IMap.__name__ = true;
var haxe = {}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
var BootstrapMenu = function() { }
$hxExpose(BootstrapMenu, "BootstrapMenu");
BootstrapMenu.__name__ = true;
BootstrapMenu.createMenuBar = function() {
	js.Browser.document.body.style.overflow = "hidden";
	var navbar = js.Browser.document.createElement("div");
	navbar.className = "navbar navbar-default navbar-inverse navbar-fixed-top";
	var navbarHeader = js.Browser.document.createElement("div");
	navbarHeader.className = "navbar-header";
	navbar.appendChild(navbarHeader);
	var a = js.Browser.document.createElement("a");
	a.className = "navbar-brand";
	a.href = "#";
	a.innerText = "HIDE";
	navbarHeader.appendChild(a);
	var div = js.Browser.document.createElement("div");
	div.className = "navbar-collapse collapse";
	var ul = js.Browser.document.createElement("ul");
	ul.id = "position-navbar";
	ul.className = "nav navbar-nav";
	div.appendChild(ul);
	navbar.appendChild(div);
	js.Browser.document.body.appendChild(navbar);
}
BootstrapMenu.getMenu = function(name,position) {
	var menu;
	if(!BootstrapMenu.menus.exists(name)) {
		menu = new ui.menu.basic.Menu(name);
		menu.setPosition(position);
		BootstrapMenu.addMenuToDocument(menu);
		BootstrapMenu.menus.set(name,menu);
	} else {
		menu = BootstrapMenu.menus.get(name);
		if(position != null && menu.position != position) {
			menu.removeFromDocument();
			BootstrapMenu.menus.remove(name);
			menu.setPosition(position);
			BootstrapMenu.addMenuToDocument(menu);
			BootstrapMenu.menus.set(name,menu);
		}
	}
	return menu;
}
BootstrapMenu.addMenuToDocument = function(menu) {
	var div = js.Boot.__cast(js.Browser.document.getElementById("position-navbar") , Element);
	if(menu.position != null && BootstrapMenu.menuArray.length > 0 && div.childNodes.length > 0) {
		var currentMenu;
		var added = false;
		var _g1 = 0, _g = BootstrapMenu.menuArray.length;
		while(_g1 < _g) {
			var i = _g1++;
			currentMenu = BootstrapMenu.menuArray[i];
			if(currentMenu != menu && currentMenu.position == null || menu.position < currentMenu.position) {
				div.insertBefore(menu.getElement(),currentMenu.getElement());
				BootstrapMenu.menuArray.splice(i,0,menu);
				added = true;
				break;
			}
		}
		if(!added) {
			menu.addToDocument();
			BootstrapMenu.menuArray.push(menu);
		}
	} else {
		menu.addToDocument();
		BootstrapMenu.menuArray.push(menu);
	}
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
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
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,Main.load);
}
Main.load = function() {
	BootstrapMenu.createMenuBar();
	HIDE.loadCSS(Main.$name,["bin/includes/css/menu.css"]);
	HIDE.notifyLoadingComplete(Main.$name);
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
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
var ui = {}
ui.menu = {}
ui.menu.basic = {}
ui.menu.basic.MenuItem = function() { }
ui.menu.basic.MenuItem.__name__ = true;
ui.menu.basic.MenuButtonItem = function(_text,_onClickFunction,_hotkey,_keyCode,_ctrl,_shift,_alt) {
	var _g = this;
	var span = null;
	if(_hotkey != null) {
		span = js.Browser.document.createElement("span");
		span.style.color = "silver";
		span.style["float"] = "right";
		span.innerText = _hotkey;
	}
	this.li = js.Browser.document.createElement("li");
	var a = js.Browser.document.createElement("a");
	a.style.left = "0";
	a.setAttribute("text",_text);
	if(_onClickFunction != null) {
		a.onclick = function(e) {
			if(_g.li.className != "disabled") _onClickFunction();
		};
		if(_hotkey != null && _keyCode != null) Hotkeys.addHotkey(_keyCode,_ctrl,_shift,_alt,_onClickFunction);
	}
	a.innerText = _text;
	if(span != null) a.appendChild(span);
	this.li.appendChild(a);
};
ui.menu.basic.MenuButtonItem.__name__ = true;
ui.menu.basic.MenuButtonItem.__interfaces__ = [ui.menu.basic.MenuItem];
ui.menu.basic.MenuButtonItem.prototype = {
	getElement: function() {
		return this.li;
	}
	,__class__: ui.menu.basic.MenuButtonItem
}
ui.menu.basic.Separator = function() {
	this.li = js.Browser.document.createElement("li");
	this.li.className = "divider";
};
ui.menu.basic.Separator.__name__ = true;
ui.menu.basic.Separator.__interfaces__ = [ui.menu.basic.MenuItem];
ui.menu.basic.Separator.prototype = {
	getElement: function() {
		return this.li;
	}
	,__class__: ui.menu.basic.Separator
}
ui.menu.basic.Menu = function(_text,_headerText) {
	this.li = js.Browser.document.createElement("li");
	this.li.className = "dropdown";
	var a = js.Browser.document.createElement("a");
	a.href = "#";
	a.className = "dropdown-toggle";
	a.setAttribute("data-toggle","dropdown");
	a.innerText = _text;
	this.li.appendChild(a);
	this.ul = js.Browser.document.createElement("ul");
	this.ul.className = "dropdown-menu";
	this.ul.classList.add("dropdown-menu-form");
	if(_headerText != null) {
		var li_header = js.Browser.document.createElement("li");
		li_header.className = "dropdown-header";
		li_header.innerText = _headerText;
		this.ul.appendChild(li_header);
	}
	this.li.appendChild(this.ul);
	this.items = new Array();
};
$hxExpose(ui.menu.basic.Menu, "ui.menu.basic.Menu");
ui.menu.basic.Menu.__name__ = true;
ui.menu.basic.Menu.prototype = {
	getElement: function() {
		return this.li;
	}
	,setMenuEnabled: function(enabled) {
		var childNodes = this.ul.childNodes;
		var _g1 = 0, _g = childNodes.length;
		while(_g1 < _g) {
			var i = _g1++;
			var child = js.Boot.__cast(childNodes[i] , Element);
			if(child.className != "divider") {
				if(enabled) child.className = ""; else child.className = "disabled";
			}
		}
	}
	,setDisabled: function(menuItemNames) {
		var childNodes = this.ul.childNodes;
		var _g1 = 0, _g = childNodes.length;
		while(_g1 < _g) {
			var i = _g1++;
			var child = js.Boot.__cast(childNodes[i] , Element);
			if(child.className != "divider") {
				var a = js.Boot.__cast(child.firstChild , HTMLAnchorElement);
				if(Lambda.indexOf(menuItemNames,a.getAttribute("text")) == -1) child.className = ""; else child.className = "disabled";
			}
		}
	}
	,setPosition: function(_position) {
		this.position = _position;
	}
	,removeFromDocument: function() {
		this.li.remove();
	}
	,addToDocument: function() {
		var div = js.Boot.__cast(js.Browser.document.getElementById("position-navbar") , Element);
		div.appendChild(this.li);
	}
	,addSeparator: function() {
		this.ul.appendChild(new ui.menu.basic.Separator().getElement());
	}
	,addMenuItem: function(_text,_position,_onClickFunction,_hotkey,_keyCode,_ctrl,_shift,_alt) {
		if(_alt == null) _alt = false;
		if(_shift == null) _shift = false;
		if(_ctrl == null) _ctrl = false;
		var menuButtonItem = new ui.menu.basic.MenuButtonItem(_text,_onClickFunction,_hotkey,_keyCode,_ctrl,_shift,_alt);
		menuButtonItem.position = _position;
		if(menuButtonItem.position != null && this.items.length > 0 && this.ul.childNodes.length > 0) {
			var currentMenuButtonItem;
			var added = false;
			var _g1 = 0, _g = this.items.length;
			while(_g1 < _g) {
				var i = _g1++;
				currentMenuButtonItem = this.items[i];
				if(currentMenuButtonItem != menuButtonItem && currentMenuButtonItem.position == null || menuButtonItem.position < currentMenuButtonItem.position) {
					this.ul.insertBefore(menuButtonItem.getElement(),currentMenuButtonItem.getElement());
					this.items.splice(i,0,menuButtonItem);
					added = true;
					break;
				}
			}
			if(!added) {
				this.ul.appendChild(menuButtonItem.getElement());
				this.items.push(menuButtonItem);
			}
		} else {
			this.ul.appendChild(menuButtonItem.getElement());
			this.items.push(menuButtonItem);
		}
	}
	,__class__: ui.menu.basic.Menu
}
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
BootstrapMenu.menus = new haxe.ds.StringMap();
BootstrapMenu.menuArray = new Array();
Main.$name = "boyan.bootstrap.menu";
Main.dependencies = ["boyan.bootstrap.script","boyan.events.hotkey"];
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