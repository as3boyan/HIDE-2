(function () { "use strict";
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	HIDE.loadCSS(Main.$name,["bin/includes/css/tabs.css"]);
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,["boyan.jquery.split-pane","boyan.jquery.layout"],Main.load,true);
};
Main.load = function() {
	TabManager.init();
	HIDE.notifyLoadingComplete(Main.$name);
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
var TabManager = function() { };
TabManager.__name__ = true;
TabManager.init = function() {
	var _this = window.document;
	TabManager.tabs = _this.createElement("ul");
	TabManager.tabs.className = "tabs";
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
	TabManager.createNewTab("test");
	Splitpane.components[1].appendChild(TabManager.tabs);
};
TabManager.createNewTab = function(name) {
	var li;
	var _this = window.document;
	li = _this.createElement("li");
	li.innerText = name + "\t";
	var span;
	var _this = window.document;
	span = _this.createElement("span");
	span.style.position = "relative";
	span.style.top = "2px";
	span.onclick = function(e) {
	};
	var span2;
	var _this = window.document;
	span2 = _this.createElement("span");
	span2.className = "glyphicon glyphicon-remove-circle";
	span.appendChild(span2);
	li.appendChild(span);
	TabManager.tabs.appendChild(li);
};
TabManager.selectDoc = function(pos) {
	var _g1 = 0;
	var _g = TabManager.tabs.childNodes.length;
	while(_g1 < _g) {
		var i = _g1++;
		var child;
		child = js.Boot.__cast(TabManager.tabs.childNodes[i] , Element);
		if(pos == i) child.className = "selected"; else child.className = "";
	}
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
Main.$name = "boyan.bootstrap.tabmanager";
Main.main();
})();

//# sourceMappingURL=Main.js.map