(function () { "use strict";
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var about = {};
about.Presentation = function() { };
about.Presentation.__name__ = true;
about.Presentation.main = function() {
	window.onload = function(e) {
		var _this = window.document;
		about.Presentation.impressDiv = _this.createElement("div");
		about.Presentation.impressDiv.id = "impress";
		var start;
		var _this1 = window.document;
		start = _this1.createElement("div");
		start.id = "start";
		start.className = "step";
		start.setAttribute("data-transition-duration","1000");
		about.Presentation.impressDiv.appendChild(start);
		var p;
		var _this2 = window.document;
		p = _this2.createElement("p");
		p.style.width = "1000px";
		p.style.fontSize = "80px";
		p.style.textAlign = "center";
		p.innerText = "HIDE - cross platform extensible IDE for Haxe";
		start.appendChild(p);
		about.Presentation.slidesCount = 1;
		var slide;
		slide = about.Presentation.createSlide("'Feature request' perk backer and project sponsor");
		slide = about.Presentation.createSlide("Haxe Foundation ","http://haxe-foundation.org/","haxe-foundation.org","120px");
		slide = about.Presentation.createSlide("'Link to your website' perk backers");
		slide = about.Presentation.createSlide("FlashDevelop","http://www.flashdevelop.org/","www.flashdevelop.org","100px");
		slide = about.Presentation.createSlide("OpenFL","http://www.openfl.org/","www.openfl.org","100px");
		slide = about.Presentation.createSlide("Hypersurge","http://hypersurge.com/","hypersurge.com","100px");
		slide = about.Presentation.createSlide("Adrian Cowan","http://blog.othrayte.net/","blog.othrayte.net","100px");
		slide = about.Presentation.createSlide("Justin Donaldson","http://scwn.net/","scwn.net","100px");
		slide = about.Presentation.createSlide("Jonas Malaco Filho",null,null,"100px");
		slide = about.Presentation.createSlide("tommy62",null,null,"100px");
		slide = about.Presentation.createSlide("'Contributor' perk backers");
		var contributors = ["Allan Dowdeswell","Samuel Batista","JongChan Choi","Patric Vormstein","Harry.french","Vincent Blanchet","zaynyatyi","qzix13","free24speed","franco.ponticelli","william.shakour","frabbit","Nick Holder","fintanboyle","Katsuomi Kobayashi","grigoruk","jessetalavera","bradparks","pchertok","Masahiro Wakame","Stojan Ilic","Renaud Bardet","Filip Loster","MatejTyc","Tiago Ling Alexandre","Skial Bainn","lars.doucet","Ido Yehieli","Ronan Sandford","brutfood","Matan Uberstein","rcarcasses","vic.cvc","Richard Lovejoy","Tarwin Stroh-Spijer","obutovich","erik.escoffier","Robert Wahler","Louis Tovar","L Pope","Florian Landerl","shohei 909","Andy Li","dionjw","Aaron Spjut","sebpatu","brycedneal","Sam Twidale","Phillip Louderback","Mario Vormstein","deepnight","Daniel Freeman"];
		while(contributors.length > 0) slide = about.Presentation.createSlide(contributors.splice(Std.random(contributors.length),1)[0]);
		slide = about.Presentation.createSlide("Also there is anonymous contributors, people who helped us to spread the word and people who helped us through pull requests, bug reports and feature requests and by giving feedbacks");
		slide = about.Presentation.createSlide("Without your help, this would not have been possible to make it");
		slide = about.Presentation.createSlide("Thanks for your support!");
		slide = about.Presentation.createSlide("(in case if you want to change website or name, just let me know - AS3Boyan)");
		window.document.body.appendChild(about.Presentation.impressDiv);
		about.Presentation.runImpressJS();
		var $window = nodejs.webkit.Window.get();
		$window.on("close",function(e1) {
			$window.close(true);
		});
	};
};
about.Presentation.createSlide = function(text,url,linkText,_fontSize) {
	if(_fontSize == null) _fontSize = "80px";
	about.Presentation.slidesCount++;
	var slide;
	var _this = window.document;
	slide = _this.createElement("div");
	slide.id = "slide" + Std.string(about.Presentation.slidesCount);
	slide.className = "step";
	console.log(slide.id);
	slide.setAttribute("data-rotate",Std.string(Std.random(360)));
	slide.setAttribute("data-scale",Std.string(Math.random() * 25 + 1));
	slide.setAttribute("data-x",Std.string(Math.random() * 100000));
	slide.setAttribute("data-y",Std.string(Math.random() * 100000));
	slide.setAttribute("data-z",Std.string(-Math.random() * 3000));
	slide.setAttribute("data-rotate-x",Std.string(Std.random(360)));
	slide.setAttribute("data-rotate-y",Std.string(Std.random(360)));
	var p;
	var _this1 = window.document;
	p = _this1.createElement("p");
	p.style.width = "1000px";
	p.style.fontSize = _fontSize;
	p.innerText = text;
	slide.appendChild(p);
	if(url != null) {
		var _this2 = window.document;
		p = _this2.createElement("p");
		p.className = "footnote";
		p.innerText = "Website: ";
		p.style.fontSize = "24px";
		slide.appendChild(p);
		var a;
		var _this3 = window.document;
		a = _this3.createElement("a");
		a.href = url;
		a.innerText = linkText;
		a.target = "_blank";
		p.appendChild(a);
	}
	about.Presentation.impressDiv.appendChild(slide);
	return slide;
};
about.Presentation.runImpressJS = function() {
	var impressInstance = impress();
	impressInstance.init();
	window.document.addEventListener("impress:stepenter",function(e) {
		if(about.Presentation.autoplay) {
			var duration;
			if(e.target.getAttribute("data-transition-duration") != null) duration = e.target.getAttribute("data-transition-duration"); else duration = 2500 + Std.random(1500);
			haxe.Timer.delay(function() {
				if(about.Presentation.autoplay) impressInstance.next();
			},duration);
		}
	});
	window.document.addEventListener("keyup",function(e1) {
		about.Presentation.autoplay = false;
		if(about.Presentation.timer != null) {
			about.Presentation.timer.stop();
			about.Presentation.timer = null;
		}
		about.Presentation.timer = new haxe.Timer(15000);
		about.Presentation.timer.run = function() {
			about.Presentation.autoplay = true;
			impressInstance.next();
			about.Presentation.timer.stop();
			about.Presentation.timer = null;
		};
	});
};
var haxe = {};
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
};
haxe.Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
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
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
nodejs.webkit.$ui.__name__ = true;
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.__name__ = true;
Array.__name__ = true;
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Menu = nodejs.webkit.$ui.Menu;
nodejs.webkit.MenuItem = nodejs.webkit.$ui.MenuItem;
nodejs.webkit.Window = nodejs.webkit.$ui.Window;
about.Presentation.autoplay = true;
about.Presentation.main();
})();
