(function ($hx_exports) { "use strict";
$hx_exports.ui = {menu:{basic:{}}};
var IMap = function() { };
IMap.__name__ = true;
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
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,__class__: haxe.ds.StringMap
};
var BootstrapMenu = $hx_exports.BootstrapMenu = function() { };
BootstrapMenu.__name__ = true;
BootstrapMenu.createMenuBar = function() {
	window.document.body.style.overflow = "hidden";
	var navbar;
	var _this = window.document;
	navbar = _this.createElement("div");
	navbar.className = "navbar navbar-default navbar-inverse navbar-fixed-top";
	var navbarHeader;
	var _this = window.document;
	navbarHeader = _this.createElement("div");
	navbarHeader.className = "navbar-header";
	navbar.appendChild(navbarHeader);
	var a;
	var _this = window.document;
	a = _this.createElement("a");
	a.className = "navbar-brand";
	a.href = "#";
	a.innerText = "HIDE";
	navbarHeader.appendChild(a);
	var div;
	var _this = window.document;
	div = _this.createElement("div");
	div.className = "navbar-collapse collapse";
	var ul;
	var _this = window.document;
	ul = _this.createElement("ul");
	ul.id = "position-navbar";
	ul.className = "nav navbar-nav";
	div.appendChild(ul);
	navbar.appendChild(div);
	window.document.body.appendChild(navbar);
};
BootstrapMenu.getMenu = function(name) {
	if(!BootstrapMenu.menus.exists(name)) {
		var menu = new ui.menu.basic.Menu(name);
		menu.addToDocument();
		BootstrapMenu.menus.set(name,menu);
	}
	return BootstrapMenu.menus.get(name);
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
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
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,Main.load);
};
Main.load = function() {
	BootstrapMenu.createMenuBar();
	HIDE.plugins.push(Main.$name);
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
var js = {};
js.Boot = function() { };
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
				var _g1 = 2;
				var _g = o.length;
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
		for( var k in o ) {
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
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
var ui = {};
ui.menu = {};
ui.menu.basic = {};
ui.menu.basic.MenuItem = function() { };
ui.menu.basic.MenuItem.__name__ = true;
ui.menu.basic.MenuButtonItem = function(_text,_onClickFunction,_hotkey) {
	var _g = this;
	var span = null;
	if(_hotkey != null) {
		var _this = window.document;
		span = _this.createElement("span");
		span.style.color = "silver";
		span.style.float = "right";
		span.innerText = _hotkey;
	}
	var _this = window.document;
	this.li = _this.createElement("li");
	var a;
	var _this = window.document;
	a = _this.createElement("a");
	a.style.left = "0";
	a.setAttribute("text",_text);
	if(_onClickFunction != null) a.onclick = function(e) {
		if(_g.li.className != "disabled") {
		}
	};
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
};
ui.menu.basic.Separator = function() {
	var _this = window.document;
	this.li = _this.createElement("li");
	this.li.className = "divider";
};
ui.menu.basic.Separator.__name__ = true;
ui.menu.basic.Separator.__interfaces__ = [ui.menu.basic.MenuItem];
ui.menu.basic.Separator.prototype = {
	getElement: function() {
		return this.li;
	}
	,__class__: ui.menu.basic.Separator
};
ui.menu.basic.Menu = $hx_exports.ui.menu.basic.Menu = function(_text,_headerText) {
	var _this = window.document;
	this.li = _this.createElement("li");
	this.li.className = "dropdown";
	var a;
	var _this = window.document;
	a = _this.createElement("a");
	a.href = "#";
	a.className = "dropdown-toggle";
	a.setAttribute("data-toggle","dropdown");
	a.innerText = _text;
	this.li.appendChild(a);
	var _this = window.document;
	this.ul = _this.createElement("ul");
	this.ul.className = "dropdown-menu";
	this.ul.style.minWidth = "300px";
	if(_headerText != null) {
		var li_header;
		var _this = window.document;
		li_header = _this.createElement("li");
		li_header.className = "dropdown-header";
		li_header.innerText = _headerText;
		this.ul.appendChild(li_header);
	}
	this.li.appendChild(this.ul);
};
ui.menu.basic.Menu.__name__ = true;
ui.menu.basic.Menu.prototype = {
	addMenuItem: function(_text,_onClickFunction,_hotkey) {
		this.ul.appendChild(new ui.menu.basic.MenuButtonItem(_text,_onClickFunction,_hotkey).getElement());
	}
	,addSeparator: function() {
		this.ul.appendChild(new ui.menu.basic.Separator().getElement());
	}
	,addToDocument: function() {
		var div;
		div = js.Boot.__cast(window.document.getElementById("position-navbar") , Element);
		div.appendChild(this.li);
	}
	,setDisabled: function(menuItemNames) {
		var childNodes = this.ul.childNodes;
		var _g1 = 0;
		var _g = childNodes.length;
		while(_g1 < _g) {
			var i = _g1++;
			var child;
			child = js.Boot.__cast(childNodes[i] , Element);
			if(child.className != "divider") {
				var a;
				a = js.Boot.__cast(child.firstChild , HTMLAnchorElement);
				if(Lambda.indexOf(menuItemNames,a.getAttribute("text")) == -1) child.className = ""; else child.className = "disabled";
			}
		}
	}
	,setMenuEnabled: function(enabled) {
		var childNodes = this.ul.childNodes;
		var _g1 = 0;
		var _g = childNodes.length;
		while(_g1 < _g) {
			var i = _g1++;
			var child;
			child = js.Boot.__cast(childNodes[i] , Element);
			if(child.className != "divider") {
				if(enabled) child.className = ""; else child.className = "disabled";
			}
		}
	}
	,__class__: ui.menu.basic.Menu
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
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
Main.$name = "boyan.bootstrap.menu";
Main.dependencies = ["boyan.bootstrap.script"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map