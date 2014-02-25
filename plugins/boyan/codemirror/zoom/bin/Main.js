(function () { "use strict";
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
var Main = function() { }
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		js.Browser.document.addEventListener("mousewheel",function(e) {
			if(e.altKey) {
				if(e.wheelDeltaY < 0) {
					var fontSize = Std.parseInt(new $(".CodeMirror").css("font-size"));
					fontSize--;
					Main.setFontSize(fontSize);
					e.preventDefault();
					e.stopPropagation();
				} else if(e.wheelDeltaY > 0) {
					var fontSize = Std.parseInt(new $(".CodeMirror").css("font-size"));
					fontSize++;
					Main.setFontSize(fontSize);
					e.preventDefault();
					e.stopPropagation();
				}
			}
		});
		BootstrapMenu.getMenu("View").addMenuItem("Increase Font Size",10001,function() {
			var fontSize = Std.parseInt(new $(".CodeMirror").css("font-size"));
			fontSize++;
			Main.setFontSize(fontSize);
		},"Ctrl-+",187,true,false,false);
		BootstrapMenu.getMenu("View").addMenuItem("Decrease Font Size",10002,function() {
			var fontSize = Std.parseInt(new $(".CodeMirror").css("font-size"));
			fontSize--;
			Main.setFontSize(fontSize);
		},"Ctrl--",189,true,false,false);
		HIDE.notifyLoadingComplete(Main.$name);
	});
}
Main.setFontSize = function(fontSize) {
	new $(".CodeMirror").css("font-size",Std.string(fontSize) + "px");
	new $(".CodeMirror-hint").css("font-size",Std.string(fontSize - 2) + "px");
	new $(".CodeMirror-hints").css("font-size",Std.string(fontSize - 2) + "px");
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
js.Browser = function() { }
js.Browser.__name__ = true;
String.__name__ = true;
Array.__name__ = true;
Main.$name = "boyan.codemirror.zoom";
Main.dependencies = ["boyan.bootstrap.menu"];
js.Browser.document = typeof window != "undefined" ? window.document : null;
Main.main();
})();

//@ sourceMappingURL=Main.js.map