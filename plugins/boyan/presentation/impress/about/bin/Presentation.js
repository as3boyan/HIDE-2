(function () { "use strict";
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
var Presentation = function() { };
Presentation.__name__ = true;
Presentation.main = function() {
	window.onload = function(e) {
		var _this = window.document;
		Presentation.impressDiv = _this.createElement("div");
		Presentation.impressDiv.id = "impress";
		var start;
		var _this = window.document;
		start = _this.createElement("div");
		start.id = "start";
		start.className = "step";
		Presentation.impressDiv.appendChild(start);
		var p;
		var _this = window.document;
		p = _this.createElement("p");
		p.style.width = "1000px";
		p.style.fontSize = "80px";
		p.style.textAlign = "center";
		p.innerText = "HIDE - cross platform extensible IDE for Haxe";
		start.appendChild(p);
		Presentation.slidesCount = 1;
		var slide;
		slide = Presentation.createSlide("'Feature request' perk backer and project sponsor");
		slide.setAttribute("data-x","-3200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Haxe Foundation ","http://haxe-foundation.org/","haxe-foundation.org");
		slide.setAttribute("data-x","-5200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("'Link to your website' perk backers");
		slide.setAttribute("data-x","-7200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("FlashDevelop","http://www.flashdevelop.org/","www.flashdevelop.org");
		slide.setAttribute("data-x","-9200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("OpenFL","http://www.openfl.org/","www.openfl.org");
		slide.setAttribute("data-x","-11200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Hypersurge","http://hypersurge.com/","hypersurge.com");
		slide.setAttribute("data-x","-13200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Adrian Cowan","http://blog.othrayte.net/","blog.othrayte.net");
		slide.setAttribute("data-x","-15500");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Justin Donaldson","http://scwn.net/","scwn.net");
		slide.setAttribute("data-x","-17200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Jonas Malaco Filho");
		slide.setAttribute("data-x","-19800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("tommy62");
		slide.setAttribute("data-x","-21800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("'Contributor ' perk backers");
		slide.setAttribute("data-x","-23200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Allan Dowdeswell");
		slide.setAttribute("data-x","-24800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Samuel Batista");
		slide.setAttribute("data-x","-26800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("JongChan Choi");
		slide.setAttribute("data-x","-28800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Patric Vormstein");
		slide.setAttribute("data-x","-30800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Harry.french");
		slide.setAttribute("data-x","-32800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Vincent Blanchet");
		slide.setAttribute("data-x","-34800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("zaynyatyi");
		slide.setAttribute("data-x","-36800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("qzix13");
		slide.setAttribute("data-x","-38800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("free24speed");
		slide.setAttribute("data-x","-41800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("franco.ponticelli");
		slide.setAttribute("data-x","-43800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("william.shakour");
		slide.setAttribute("data-x","-45800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("frabbit");
		slide.setAttribute("data-x","-47800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Nick Holder");
		slide.setAttribute("data-x","-49800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("fintanboyle");
		slide.setAttribute("data-x","-51800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Katsuomi Kobayashi");
		slide.setAttribute("data-x","-53800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("grigoruk");
		slide.setAttribute("data-x","-55800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("jessetalavera");
		slide.setAttribute("data-x","-57800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("bradparks");
		slide.setAttribute("data-x","-59800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("pchertok");
		slide.setAttribute("data-x","-61800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Masahiro Wakame");
		slide.setAttribute("data-x","-63800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Stojan Ilic");
		slide.setAttribute("data-x","-65800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Renaud Bardet");
		slide.setAttribute("data-x","-67800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Filip Loster");
		slide.setAttribute("data-x","-69800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("MatejTyc");
		slide.setAttribute("data-x","-71800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Tiago Ling Alexandre");
		slide.setAttribute("data-x","-73800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Skial Bainn");
		slide.setAttribute("data-x","-75800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("lars.doucet");
		slide.setAttribute("data-x","-77800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Ido Yehieli");
		slide.setAttribute("data-x","-79800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Ronan Sandford");
		slide.setAttribute("data-x","-81800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("brutfood");
		slide.setAttribute("data-x","-83800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Matan Uberstein");
		slide.setAttribute("data-x","-85800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("rcarcasses");
		slide.setAttribute("data-x","-87800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("vic.cvc");
		slide.setAttribute("data-x","-89800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Richard Lovejoy");
		slide.setAttribute("data-x","-91800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Tarwin Stroh-Spijer");
		slide.setAttribute("data-x","-93800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("obutovich");
		slide.setAttribute("data-x","-95800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("erik.escoffier");
		slide.setAttribute("data-x","-97800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Robert Wahler");
		slide.setAttribute("data-x","-99800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Louis Tovar");
		slide.setAttribute("data-x","-101800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("L Pope");
		slide.setAttribute("data-x","-103800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Florian Landerl");
		slide.setAttribute("data-x","-105800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("shohei 909");
		slide.setAttribute("data-x","-107800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Andy Li");
		slide.setAttribute("data-x","-109800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("dionjw");
		slide.setAttribute("data-x","-111800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Aaron Spjut");
		slide.setAttribute("data-x","-115800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("sebpatu");
		slide.setAttribute("data-x","-117800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("brycedneal");
		slide.setAttribute("data-x","-119800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Sam Twidale");
		slide.setAttribute("data-x","-121800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Phillip Louderback");
		slide.setAttribute("data-x","-123800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Mario Vormstein");
		slide.setAttribute("data-x","-125800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("deepnight");
		slide.setAttribute("data-x","-127800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Daniel Freeman");
		slide.setAttribute("data-x","-129800");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Also there is anonymous contributors, people who helped us to spread the word and people who helped us through pull requests, bug reports and feature requests");
		slide.setAttribute("data-x","-131200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Without your help, this would not have been possible to make it");
		slide.setAttribute("data-x","-133200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("Thanks for your support!");
		slide.setAttribute("data-x","-135200");
		slide.setAttribute("data-y","0");
		slide = Presentation.createSlide("(in case if you want to change website or name, just let me know - AS3Boyan)");
		slide.setAttribute("data-x","-137200");
		slide.setAttribute("data-y","0");
		window.document.body.appendChild(Presentation.impressDiv);
		Presentation.runImpressJS();
		var $window = js.Node.require("nw.gui").Window.get();
		$window.on("close",function(e1) {
			$window.close(true);
		});
	};
};
Presentation.createSlide = function(text,url,linkText) {
	Presentation.slidesCount++;
	var slide;
	var _this = window.document;
	slide = _this.createElement("div");
	slide.id = "slide" + Std.string(Presentation.slidesCount);
	slide.className = "step";
	console.log(slide.id);
	var p;
	var _this = window.document;
	p = _this.createElement("p");
	p.style.width = "1000px";
	p.style.fontSize = "80px";
	p.innerText = text;
	slide.appendChild(p);
	if(url != null) {
		var _this = window.document;
		p = _this.createElement("p");
		p.className = "footnote";
		p.innerText = "Website: ";
		p.style.fontSize = "24px";
		slide.appendChild(p);
		var a;
		var _this = window.document;
		a = _this.createElement("a");
		a.href = url;
		a.innerText = linkText;
		a.target = "_blank";
		p.appendChild(a);
	}
	Presentation.impressDiv.appendChild(slide);
	return slide;
};
Presentation.runImpressJS = function() {
	impress().init();
};
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
js.Node = function() { };
js.Node.__name__ = true;
String.__name__ = true;
Array.__name__ = true;
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
Presentation.main();
})();

//# sourceMappingURL=Presentation.js.map