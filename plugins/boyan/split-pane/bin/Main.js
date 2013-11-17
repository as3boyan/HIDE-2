(function ($hx_exports) { "use strict";
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.dependencies,Main.load);
	HIDE.loadCSS("../plugins/boyan/split-pane/bin/includes/css/split-pane.css");
};
Main.load = function() {
	HIDE.loadJS("../plugins/boyan/split-pane/bin/includes/js/split-pane.js",function() {
		var htmlElement;
		htmlElement = js.Boot.__cast(window.document.documentElement , HTMLHtmlElement);
		htmlElement.style.height = "100%";
		window.document.body.style.height = "100%";
		var splitPane = Splitpane.createSplitPane("left");
		splitPane.style.marginTop = "51px";
		var leftComponent = Splitpane.createComponent();
		leftComponent.style.width = "150px";
		splitPane.appendChild(leftComponent);
		var divider = Splitpane.createDivider();
		divider.style.left = "150px";
		splitPane.appendChild(divider);
		var rightComponent = Splitpane.createComponent();
		rightComponent.style.left = "150px";
		rightComponent.style.marginLeft = "5px";
		splitPane.appendChild(rightComponent);
		window.document.body.appendChild(splitPane);
		$('div.split-pane').splitPane();
		HIDE.plugins.push(Main.$name);
	});
};
var Splitpane = $hx_exports.Splitpane = function() { };
Splitpane.__name__ = true;
Splitpane.createSplitPane = function(fixedSide) {
	var splitPaneDiv;
	var _this = window.document;
	splitPaneDiv = _this.createElement("div");
	splitPaneDiv.className = "split-pane fixed-" + fixedSide;
	return splitPaneDiv;
};
Splitpane.createComponent = function() {
	var splitPaneComponent;
	var _this = window.document;
	splitPaneComponent = _this.createElement("div");
	splitPaneComponent.className = "split-pane-component";
	Splitpane.components.push(splitPaneComponent);
	return splitPaneComponent;
};
Splitpane.createDivider = function() {
	var divider;
	var _this = window.document;
	divider = _this.createElement("div");
	divider.className = "split-pane-divider";
	divider.style.background = "#aaa";
	divider.style.width = "5px";
	return divider;
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
Main.$name = "boyan.split-pane";
Main.dependencies = ["boyan.jquery"];
Splitpane.components = new Array();
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map