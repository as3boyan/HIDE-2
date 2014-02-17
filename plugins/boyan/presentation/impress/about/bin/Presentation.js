(function () { "use strict";
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
var Presentation = function() { }
Presentation.__name__ = true;
Presentation.main = function() {
	js.Browser.window.onload = function(e) {
		Presentation.impressDiv = js.Browser.document.createElement("div");
		Presentation.impressDiv.id = "impress";
		var start = js.Browser.document.createElement("div");
		start.id = "start";
		start.className = "step";
		Presentation.impressDiv.appendChild(start);
		var p = js.Browser.document.createElement("p");
		p.style.width = "1000px";
		p.style.fontSize = "80px";
		p.style.textAlign = "center";
		p.innerText = "HIDE - cross platform extensible IDE for Haxe";
		start.appendChild(p);
		Presentation.slidesCount = 1;
		var slide;
		slide = Presentation.createSlide("'Feature request' perk backer and project sponsor");
		slide = Presentation.createSlide("Haxe Foundation ","http://haxe-foundation.org/","haxe-foundation.org","120px");
		slide = Presentation.createSlide("'Link to your website' perk backers");
		slide = Presentation.createSlide("FlashDevelop","http://www.flashdevelop.org/","www.flashdevelop.org","100px");
		slide = Presentation.createSlide("OpenFL","http://www.openfl.org/","www.openfl.org","100px");
		slide = Presentation.createSlide("Hypersurge","http://hypersurge.com/","hypersurge.com","100px");
		slide = Presentation.createSlide("Adrian Cowan","http://blog.othrayte.net/","blog.othrayte.net","100px");
		slide = Presentation.createSlide("Justin Donaldson","http://scwn.net/","scwn.net","100px");
		slide = Presentation.createSlide("Jonas Malaco Filho",null,null,"100px");
		slide = Presentation.createSlide("tommy62",null,null,"100px");
		slide = Presentation.createSlide("'Contributor' perk backers");
		var contributors = ["Allan Dowdeswell","Samuel Batista","JongChan Choi","Patric Vormstein","Harry.french","Vincent Blanchet","zaynyatyi","qzix13","free24speed","franco.ponticelli","william.shakour","frabbit","Nick Holder","fintanboyle","Katsuomi Kobayashi","grigoruk","jessetalavera","bradparks","pchertok","Masahiro Wakame","Stojan Ilic","Renaud Bardet","Filip Loster","MatejTyc","Tiago Ling Alexandre","Skial Bainn","lars.doucet","Ido Yehieli","Ronan Sandford","brutfood","Matan Uberstein","rcarcasses","vic.cvc","Richard Lovejoy","Tarwin Stroh-Spijer","obutovich","erik.escoffier","Robert Wahler","Louis Tovar","L Pope","Florian Landerl","shohei 909","Andy Li","dionjw","Aaron Spjut","sebpatu","brycedneal","Sam Twidale","Phillip Louderback","Mario Vormstein","deepnight","Daniel Freeman"];
		while(contributors.length > 0) slide = Presentation.createSlide(contributors.splice(Std.random(contributors.length),1)[0]);
		slide = Presentation.createSlide("Also there is anonymous contributors, people who helped us to spread the word and people who helped us through pull requests, bug reports and feature requests and by giving feedbacks");
		slide = Presentation.createSlide("Without your help, this would not have been possible to make it");
		slide = Presentation.createSlide("Thanks for your support!");
		slide = Presentation.createSlide("(in case if you want to change website or name, just let me know - AS3Boyan)");
		js.Browser.document.body.appendChild(Presentation.impressDiv);
		Presentation.runImpressJS();
		var window = js.Node.require("nw.gui").Window.get();
		window.on("close",function(e1) {
			window.close(true);
		});
	};
}
Presentation.createSlide = function(text,url,linkText,_fontSize) {
	if(_fontSize == null) _fontSize = "80px";
	Presentation.slidesCount++;
	var slide = js.Browser.document.createElement("div");
	slide.id = "slide" + Std.string(Presentation.slidesCount);
	slide.className = "step";
	console.log(slide.id);
	slide.setAttribute("data-rotate",Std.string(Std.random(360)));
	slide.setAttribute("data-scale",Std.string(Math.random() * 25 + 1));
	slide.setAttribute("data-x",Std.string(Math.random() * 100000));
	slide.setAttribute("data-y",Std.string(Math.random() * 100000));
	slide.setAttribute("data-z",Std.string(-Math.random() * 3000));
	slide.setAttribute("data-rotate-x",Std.string(Std.random(360)));
	slide.setAttribute("data-rotate-y",Std.string(Std.random(360)));
	var p = js.Browser.document.createElement("p");
	p.style.width = "1000px";
	p.style.fontSize = _fontSize;
	p.innerText = text;
	slide.appendChild(p);
	if(url != null) {
		p = js.Browser.document.createElement("p");
		p.className = "footnote";
		p.innerText = "Website: ";
		p.style.fontSize = "24px";
		slide.appendChild(p);
		var a = js.Browser.document.createElement("a");
		a.href = url;
		a.innerText = linkText;
		a.target = "_blank";
		p.appendChild(a);
	}
	Presentation.impressDiv.appendChild(slide);
	return slide;
}
Presentation.runImpressJS = function() {
	var impressInstance = impress();
	impressInstance.init();
	js.Browser.document.addEventListener("impress:stepenter",function(e) {
		if(Presentation.autoplay) {
			var duration = e.target.getAttribute("data-transition-duration") != null?e.target.getAttribute("data-transition-duration"):3000 + Std.random(2000);
			haxe.Timer.delay(function() {
				if(Presentation.autoplay) impressInstance.next();
			},duration);
		}
	});
	js.Browser.document.addEventListener("keyup",function(e) {
		Presentation.autoplay = false;
		if(Presentation.timer != null) {
			Presentation.timer.stop();
			Presentation.timer = null;
		}
		Presentation.timer = new haxe.Timer(15000);
		Presentation.timer.run = function() {
			Presentation.autoplay = true;
			impressInstance.next();
			Presentation.timer.stop();
			Presentation.timer = null;
		};
	});
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
Std.random = function(x) {
	return x <= 0?0:Math.floor(Math.random() * x);
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
js.Node = function() { }
js.Node.__name__ = true;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.__name__ = true;
Array.__name__ = true;
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
Presentation.autoplay = true;
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
Presentation.main();
})();

//@ sourceMappingURL=Presentation.js.map