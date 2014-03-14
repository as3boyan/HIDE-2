(function () { "use strict";
var Presentation = function() { };
Presentation.main = function() {
	window.onload = function(e) {
		var _this = window.document;
		Presentation.impressDiv = _this.createElement("div");
		Presentation.impressDiv.id = "impress";
		var start;
		var _this1 = window.document;
		start = _this1.createElement("div");
		start.id = "start";
		start.className = "step";
		start.setAttribute("data-transition-duration","1000");
		Presentation.impressDiv.appendChild(start);
		var p;
		var _this2 = window.document;
		p = _this2.createElement("p");
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
		window.document.body.appendChild(Presentation.impressDiv);
		Presentation.runImpressJS();
		var $window = nodejs.webkit.Window.get();
		$window.on("close",function(e1) {
			$window.close();
		});
	};
};
Presentation.createSlide = function(text,url,linkText,_fontSize) {
	if(_fontSize == null) _fontSize = "80px";
	Presentation.slidesCount++;
	var slide;
	var _this = window.document;
	slide = _this.createElement("div");
	slide.id = "slide" + ("" + Presentation.slidesCount);
	slide.className = "step";
	console.log(slide.id);
	slide.setAttribute("data-rotate","" + Std.random(360));
	slide.setAttribute("data-scale","" + (Math.random() * 25 + 1));
	slide.setAttribute("data-x","" + Math.random() * 100000);
	slide.setAttribute("data-y","" + Math.random() * 100000);
	slide.setAttribute("data-z","" + -Math.random() * 3000);
	slide.setAttribute("data-rotate-x","" + Std.random(360));
	slide.setAttribute("data-rotate-y","" + Std.random(360));
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
	Presentation.impressDiv.appendChild(slide);
	return slide;
};
Presentation.runImpressJS = function() {
	var impressInstance = impress();
	impressInstance.init();
	window.document.addEventListener("impress:stepenter",function(e) {
		if(Presentation.autoplay) {
			var duration;
			if(e.target.getAttribute("data-transition-duration") != null) duration = e.target.getAttribute("data-transition-duration"); else duration = 2500 + Std.random(1500);
			haxe.Timer.delay(function() {
				if(Presentation.autoplay) impressInstance.next();
			},duration);
		}
	});
	window.document.addEventListener("keyup",function(e1) {
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
};
var Std = function() { };
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var haxe = {};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
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
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Menu = nodejs.webkit.$ui.Menu;
nodejs.webkit.MenuItem = nodejs.webkit.$ui.MenuItem;
nodejs.webkit.Window = nodejs.webkit.$ui.Window;
Presentation.autoplay = true;
Presentation.main();
})();

//# sourceMappingURL=Presentation.js.map