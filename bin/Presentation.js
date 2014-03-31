(function () { "use strict";
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	r: null
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
};
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
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var List = function() { };
List.__name__ = true;
List.prototype = {
	h: null
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,__class__: List
};
var IMap = function() { };
IMap.__name__ = true;
IMap.prototype = {
	get: null
	,keys: null
	,__class__: IMap
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && v.__enum__ == null || t == "function" && (v.__name__ || v.__ename__) != null;
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
Std.parseFloat = function(x) {
	return parseFloat(x);
};
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	b: null
	,add: function(x) {
		this.b += Std.string(x);
	}
	,__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var Type = function() { };
Type.__name__ = true;
Type.getClass = function(o) {
	if(o == null) return null;
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
};
var about = {};
about.Presentation = function() { };
about.Presentation.__name__ = true;
about.Presentation.main = function() {
	window.onload = function(e) {
		watchers.SettingsWatcher.load();
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
		p.setAttribute("localeString","HIDE - cross platform extensible IDE for Haxe");
		p.textContent = watchers.LocaleWatcher.getStringSync("HIDE - cross platform extensible IDE for Haxe");
		start.appendChild(p);
		about.Presentation.slidesCount = 1;
		var slide;
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("'Feature request' perk backer and project sponsor"));
		slide = about.Presentation.createSlide("Haxe Foundation ","http://haxe-foundation.org/","haxe-foundation.org","120px");
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("'Link to your website' perk backers"));
		slide = about.Presentation.createSlide("FlashDevelop","http://www.flashdevelop.org/","www.flashdevelop.org","100px");
		slide = about.Presentation.createSlide("OpenFL","http://www.openfl.org/","www.openfl.org","100px");
		slide = about.Presentation.createSlide("Hypersurge","http://hypersurge.com/","hypersurge.com","100px");
		slide = about.Presentation.createSlide("Adrian Cowan","http://blog.othrayte.net/","blog.othrayte.net","100px");
		slide = about.Presentation.createSlide("Justin Donaldson","http://scwn.net/","scwn.net","100px");
		slide = about.Presentation.createSlide("Jonas Malaco Filho",null,null,"100px");
		slide = about.Presentation.createSlide("tommy62",null,null,"100px");
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("'Contributor' perk backers"));
		var contributors = ["Allan Dowdeswell","Samuel Batista","JongChan Choi","Patric Vormstein","Harry.french","Vincent Blanchet","zaynyatyi","qzix13","free24speed","franco.ponticelli","william.shakour","frabbit","Nick Holder","fintanboyle","Katsuomi Kobayashi","grigoruk","jessetalavera","bradparks","pchertok","Masahiro Wakame","Stojan Ilic","Renaud Bardet","Filip Loster","MatejTyc","Tiago Ling Alexandre","Skial Bainn","lars.doucet","Ido Yehieli","Ronan Sandford","brutfood","Matan Uberstein","rcarcasses","vic.cvc","Richard Lovejoy","Tarwin Stroh-Spijer","obutovich","erik.escoffier","Robert Wahler","Louis Tovar","L Pope","Florian Landerl","shohei 909","Andy Li","dionjw","Aaron Spjut","sebpatu","brycedneal","Sam Twidale","Phillip Louderback","Mario Vormstein","deepnight","Daniel Freeman"];
		while(contributors.length > 0) slide = about.Presentation.createSlide(contributors.splice(Std.random(contributors.length),1)[0]);
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("Also there is anonymous contributors, people who helped us to spread the word and people who helped us through pull requests, bug reports and feature requests and by giving feedbacks"));
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("Without your help, this would not have been possible to make it"));
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("Thanks for your support!"));
		slide = about.Presentation.createSlide(watchers.LocaleWatcher.getStringSync("(in case if you want to change website or name, just let me know - AS3Boyan)"));
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
		p.innerText = watchers.LocaleWatcher.getStringSync("Website: ");
		p.setAttribute("localeString","Website: ");
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
	id: null
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
};
haxe.Utf8 = function(size) {
	this.__b = "";
};
haxe.Utf8.__name__ = true;
haxe.Utf8.prototype = {
	__b: null
	,__class__: haxe.Utf8
};
haxe.ds = {};
haxe.ds.StringMap = function() { };
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	h: null
	,get: function(key) {
		return this.h["$" + key];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe.ds.StringMap
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
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
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
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
js.Node = function() { };
js.Node.__name__ = true;
var nodejs = {};
nodejs.webkit = {};
nodejs.webkit.$ui = function() { };
nodejs.webkit.$ui.__name__ = true;
var tjson = {};
tjson.TJSON = function() { };
tjson.TJSON.__name__ = true;
tjson.TJSON.parse = function(json,fileName,stringProcessor) {
	if(fileName == null) fileName = "JSON Data";
	tjson.TJSON.floatRegex = new EReg("^-?[0-9]*\\.[0-9]+$","");
	tjson.TJSON.intRegex = new EReg("^-?[0-9]+$","");
	tjson.TJSON.json = json;
	tjson.TJSON.fileName = fileName;
	tjson.TJSON.currentLine = 1;
	tjson.TJSON.pos = 0;
	if(stringProcessor == null) tjson.TJSON.strProcessor = tjson.TJSON.defaultStringProcessor; else tjson.TJSON.strProcessor = stringProcessor;
	try {
		return tjson.TJSON.doParse();
	} catch( e ) {
		if( js.Boot.__instanceof(e,String) ) {
			throw fileName + " on line " + tjson.TJSON.currentLine + ": " + e;
		} else throw(e);
	}
	return null;
};
tjson.TJSON.encode = function(obj,style) {
	if(!Reflect.isObject(obj)) throw "Provided object is not an object.";
	var st;
	if(js.Boot.__instanceof(style,tjson.EncodeStyle)) st = style; else if(style == "fancy") st = new tjson.FancyStyle(); else st = new tjson.SimpleStyle();
	var buffer = new StringBuf();
	if((obj instanceof Array) && obj.__enum__ == null || js.Boot.__instanceof(obj,List)) tjson.TJSON.encodeIterable(buffer,obj,st,0); else if(js.Boot.__instanceof(obj,haxe.ds.StringMap)) tjson.TJSON.encodeMap(buffer,obj,st,0); else tjson.TJSON.encodeObject(buffer,obj,st,0);
	return buffer.b;
};
tjson.TJSON.defaultStringProcessor = function(str) {
	return str;
};
tjson.TJSON.doParse = function() {
	var s = tjson.TJSON.getNextSymbol();
	if(s == "{") return tjson.TJSON.doObject();
	if(s == "[") return tjson.TJSON.doArray();
	return null;
};
tjson.TJSON.doObject = function() {
	var o = { };
	var val = "";
	var key;
	while(tjson.TJSON.pos < tjson.TJSON.json.length) {
		key = tjson.TJSON.getNextSymbol();
		if(key == "," && !tjson.TJSON.lastSymbolQuoted) continue;
		if(key == "}" && !tjson.TJSON.lastSymbolQuoted) return o;
		var seperator = tjson.TJSON.getNextSymbol();
		if(seperator != ":") throw "Expected ':' but got '" + seperator + "' instead.";
		var v = tjson.TJSON.getNextSymbol();
		if(v == "{" && !tjson.TJSON.lastSymbolQuoted) val = tjson.TJSON.doObject(); else if(v == "[" && !tjson.TJSON.lastSymbolQuoted) val = tjson.TJSON.doArray(); else val = tjson.TJSON.convertSymbolToProperType(v);
		o[key] = val;
	}
	throw "Unexpected end of file. Expected '}'";
};
tjson.TJSON.doArray = function() {
	var a = new Array();
	var val;
	while(tjson.TJSON.pos < tjson.TJSON.json.length) {
		val = tjson.TJSON.getNextSymbol();
		if(val == "," && !tjson.TJSON.lastSymbolQuoted) continue; else if(val == "]" && !tjson.TJSON.lastSymbolQuoted) return a; else if(val == "{" && !tjson.TJSON.lastSymbolQuoted) val = tjson.TJSON.doObject(); else if(val == "[" && !tjson.TJSON.lastSymbolQuoted) val = tjson.TJSON.doArray(); else val = tjson.TJSON.convertSymbolToProperType(val);
		a.push(val);
	}
	throw "Unexpected end of file. Expected ']'";
};
tjson.TJSON.convertSymbolToProperType = function(symbol) {
	if(tjson.TJSON.lastSymbolQuoted) return symbol;
	if(tjson.TJSON.looksLikeFloat(symbol)) return Std.parseFloat(symbol);
	if(tjson.TJSON.looksLikeInt(symbol)) return Std.parseInt(symbol);
	if(symbol.toLowerCase() == "true") return true;
	if(symbol.toLowerCase() == "false") return false;
	if(symbol.toLowerCase() == "null") return null;
	return symbol;
};
tjson.TJSON.looksLikeFloat = function(s) {
	return tjson.TJSON.floatRegex.match(s);
};
tjson.TJSON.looksLikeInt = function(s) {
	return tjson.TJSON.intRegex.match(s);
};
tjson.TJSON.getNextSymbol = function() {
	tjson.TJSON.lastSymbolQuoted = false;
	var c = "";
	var inQuote = false;
	var quoteType = "";
	var symbol = "";
	var inEscape = false;
	var inSymbol = false;
	var inLineComment = false;
	var inBlockComment = false;
	while(tjson.TJSON.pos < tjson.TJSON.json.length) {
		c = tjson.TJSON.json.charAt(tjson.TJSON.pos++);
		if(c == "\n" && !inSymbol) tjson.TJSON.currentLine++;
		if(inLineComment) {
			if(c == "\n" || c == "\r") {
				inLineComment = false;
				tjson.TJSON.pos++;
			}
			continue;
		}
		if(inBlockComment) {
			if(c == "*" && tjson.TJSON.json.charAt(tjson.TJSON.pos) == "/") {
				inBlockComment = false;
				tjson.TJSON.pos++;
			}
			continue;
		}
		if(inQuote) {
			if(inEscape) {
				inEscape = false;
				if(c == "'" || c == "\"") {
					symbol += c;
					continue;
				}
				if(c == "t") {
					symbol += "\t";
					continue;
				}
				if(c == "n") {
					symbol += "\n";
					continue;
				}
				if(c == "\\") {
					symbol += "\\";
					continue;
				}
				if(c == "r") {
					symbol += "\r";
					continue;
				}
				if(c == "/") {
					symbol += "/";
					continue;
				}
				if(c == "u") {
					var hexValue = 0;
					var _g = 0;
					while(_g < 4) {
						var i = _g++;
						if(tjson.TJSON.pos >= tjson.TJSON.json.length) throw "Unfinished UTF8 character";
						var nc;
						var index = tjson.TJSON.pos++;
						nc = HxOverrides.cca(tjson.TJSON.json,index);
						hexValue = hexValue << 4;
						if(nc >= 48 && nc <= 57) hexValue += nc - 48; else if(nc >= 65 && nc <= 70) hexValue += 10 + nc - 65; else if(nc >= 97 && nc <= 102) hexValue += 10 + nc - 95; else throw "Not a hex digit";
					}
					var utf = new haxe.Utf8();
					utf.__b += String.fromCharCode(hexValue);
					symbol += utf.__b;
					continue;
				}
				throw "Invalid escape sequence '\\" + c + "'";
			} else {
				if(c == "\\") {
					inEscape = true;
					continue;
				}
				if(c == quoteType) return symbol;
				symbol += c;
				continue;
			}
		} else if(c == "/") {
			var c2 = tjson.TJSON.json.charAt(tjson.TJSON.pos);
			if(c2 == "/") {
				inLineComment = true;
				tjson.TJSON.pos++;
				continue;
			} else if(c2 == "*") {
				inBlockComment = true;
				tjson.TJSON.pos++;
				continue;
			}
		}
		if(inSymbol) {
			if(c == " " || c == "\n" || c == "\r" || c == "\t" || c == "," || c == ":" || c == "}" || c == "]") {
				tjson.TJSON.pos--;
				return symbol;
			} else {
				symbol += c;
				continue;
			}
		} else {
			if(c == " " || c == "\t" || c == "\n" || c == "\r") continue;
			if(c == "{" || c == "}" || c == "[" || c == "]" || c == "," || c == ":") return c;
			if(c == "'" || c == "\"") {
				inQuote = true;
				quoteType = c;
				tjson.TJSON.lastSymbolQuoted = true;
				continue;
			} else {
				inSymbol = true;
				symbol = c;
				continue;
			}
		}
	}
	if(inQuote) throw "Unexpected end of data. Expected ( " + quoteType + " )";
	return symbol;
};
tjson.TJSON.encodeObject = function(buffer,obj,style,depth) {
	buffer.add(style.beginObject(depth));
	var fieldCount = 0;
	var fields;
	var cls = Type.getClass(obj);
	if(cls != null) fields = Type.getInstanceFields(cls); else fields = Reflect.fields(obj);
	var _g = 0;
	while(_g < fields.length) {
		var field = fields[_g];
		++_g;
		if(fieldCount++ > 0) buffer.add(style.entrySeperator(depth)); else buffer.add(style.firstEntry(depth));
		var value = Reflect.field(obj,field);
		buffer.add("\"" + field + "\"" + style.keyValueSeperator(depth));
		tjson.TJSON.encodeValue(buffer,value,style,depth);
	}
	buffer.add(style.endObject(depth));
};
tjson.TJSON.encodeMap = function(buffer,obj,style,depth) {
	buffer.add(style.beginObject(depth));
	var fieldCount = 0;
	var $it0 = obj.keys();
	while( $it0.hasNext() ) {
		var field = $it0.next();
		if(fieldCount++ > 0) buffer.add(style.entrySeperator(depth)); else buffer.add(style.firstEntry(depth));
		var value = obj.get(field);
		buffer.add("\"" + field + "\"" + style.keyValueSeperator(depth));
		tjson.TJSON.encodeValue(buffer,value,style,depth);
	}
	buffer.add(style.endObject(depth));
};
tjson.TJSON.encodeIterable = function(buffer,obj,style,depth) {
	buffer.add(style.beginArray(depth));
	var fieldCount = 0;
	var $it0 = $iterator(obj)();
	while( $it0.hasNext() ) {
		var value = $it0.next();
		if(fieldCount++ > 0) buffer.add(style.entrySeperator(depth)); else buffer.add(style.firstEntry(depth));
		tjson.TJSON.encodeValue(buffer,value,style,depth);
	}
	buffer.add(style.endArray(depth));
};
tjson.TJSON.encodeValue = function(buffer,value,style,depth) {
	if(((value | 0) === value) || typeof(value) == "number") buffer.add(value); else if((value instanceof Array) && value.__enum__ == null || js.Boot.__instanceof(value,List)) {
		var v = value;
		tjson.TJSON.encodeIterable(buffer,v,style,depth + 1);
	} else if(js.Boot.__instanceof(value,List)) {
		var v1 = value;
		tjson.TJSON.encodeIterable(buffer,v1,style,depth + 1);
	} else if(js.Boot.__instanceof(value,haxe.ds.StringMap)) tjson.TJSON.encodeMap(buffer,value,style,depth + 1); else if(typeof(value) == "string") buffer.add("\"" + StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(Std.string(value),"\\","\\\\"),"\n","\\n"),"\r","\\r"),"\"","\\\"") + "\""); else if(typeof(value) == "boolean") buffer.add(value); else if(Reflect.isObject(value)) tjson.TJSON.encodeObject(buffer,value,style,depth + 1); else if(value == null) buffer.b += "null"; else throw "Unsupported field type: " + Std.string(value);
};
tjson.EncodeStyle = function() { };
tjson.EncodeStyle.__name__ = true;
tjson.EncodeStyle.prototype = {
	beginObject: null
	,endObject: null
	,beginArray: null
	,endArray: null
	,firstEntry: null
	,entrySeperator: null
	,keyValueSeperator: null
	,__class__: tjson.EncodeStyle
};
tjson.SimpleStyle = function() {
};
tjson.SimpleStyle.__name__ = true;
tjson.SimpleStyle.__interfaces__ = [tjson.EncodeStyle];
tjson.SimpleStyle.prototype = {
	beginObject: function(depth) {
		return "{";
	}
	,endObject: function(depth) {
		return "}";
	}
	,beginArray: function(depth) {
		return "[";
	}
	,endArray: function(depth) {
		return "]";
	}
	,firstEntry: function(depth) {
		return "";
	}
	,entrySeperator: function(depth) {
		return ",";
	}
	,keyValueSeperator: function(depth) {
		return ":";
	}
	,__class__: tjson.SimpleStyle
};
tjson.FancyStyle = function(tab) {
	if(tab == null) tab = "    ";
	this.tab = tab;
	this.charTimesNCache = [""];
};
tjson.FancyStyle.__name__ = true;
tjson.FancyStyle.__interfaces__ = [tjson.EncodeStyle];
tjson.FancyStyle.prototype = {
	tab: null
	,beginObject: function(depth) {
		return "{\n";
	}
	,endObject: function(depth) {
		return "\n" + this.charTimesN(depth) + "}";
	}
	,beginArray: function(depth) {
		return "[\n";
	}
	,endArray: function(depth) {
		return "\n" + this.charTimesN(depth) + "]";
	}
	,firstEntry: function(depth) {
		return this.charTimesN(depth + 1) + " ";
	}
	,entrySeperator: function(depth) {
		return "\n" + this.charTimesN(depth + 1) + ",";
	}
	,keyValueSeperator: function(depth) {
		return " : ";
	}
	,charTimesNCache: null
	,charTimesN: function(n) {
		if(n < this.charTimesNCache.length) return this.charTimesNCache[n]; else return this.charTimesNCache[n] = this.charTimesN(n - 1) + this.tab;
	}
	,__class__: tjson.FancyStyle
};
var watchers = {};
watchers.LocaleWatcher = function() { };
watchers.LocaleWatcher.__name__ = true;
watchers.LocaleWatcher.load = function() {
	if(watchers.LocaleWatcher.watcher != null) watchers.LocaleWatcher.watcher.close();
	watchers.LocaleWatcher.parse();
	watchers.Watcher.watchFileForUpdates(watchers.SettingsWatcher.settings.locale,function() {
		watchers.LocaleWatcher.parse();
		watchers.LocaleWatcher.processHtmlElements();
	},1000);
	watchers.LocaleWatcher.processHtmlElements();
	if(!watchers.LocaleWatcher.listenerAdded) {
		nodejs.webkit.Window.get().on("close",function(e) {
			if(watchers.LocaleWatcher.watcher != null) watchers.LocaleWatcher.watcher.close();
		});
		watchers.LocaleWatcher.listenerAdded = true;
	}
};
watchers.LocaleWatcher.parse = function() {
	var options = { };
	options.encoding = "utf8";
	var data = js.Node.require("fs").readFileSync(watchers.SettingsWatcher.settings.locale,options);
	watchers.LocaleWatcher.localeData = tjson.TJSON.parse(data);
};
watchers.LocaleWatcher.getStringSync = function(name) {
	var value = name;
	if(Object.prototype.hasOwnProperty.call(watchers.LocaleWatcher.localeData,name)) value = Reflect.field(watchers.LocaleWatcher.localeData,name); else {
		watchers.LocaleWatcher.localeData[name] = name;
		var data = tjson.TJSON.encode(watchers.LocaleWatcher.localeData,"fancy");
		js.Node.require("fs").writeFileSync(watchers.SettingsWatcher.settings.locale,data,"utf8");
	}
	return value;
};
watchers.LocaleWatcher.processHtmlElements = function() {
	var element;
	var value;
	var _g = 0;
	var _g1 = window.document.getElementsByTagName("*");
	while(_g < _g1.length) {
		var node = _g1[_g];
		++_g;
		element = js.Boot.__cast(node , Element);
		value = element.getAttribute("localeString");
		if(value != null) element.textContent = watchers.LocaleWatcher.getStringSync(value);
	}
};
watchers.SettingsWatcher = function() { };
watchers.SettingsWatcher.__name__ = true;
watchers.SettingsWatcher.load = function() {
	watchers.Watcher.watchFileForUpdates("settings.json",watchers.SettingsWatcher.parse,3000);
	watchers.SettingsWatcher.parse();
	nodejs.webkit.Window.get().on("close",function(e) {
		if(watchers.SettingsWatcher.watcher != null) watchers.SettingsWatcher.watcher.close();
	});
};
watchers.SettingsWatcher.parse = function() {
	var options = { };
	options.encoding = "utf8";
	var data = js.Node.require("fs").readFileSync("settings.json",options);
	watchers.SettingsWatcher.settings = tjson.TJSON.parse(data);
	watchers.ThemeWatcher.load();
	watchers.LocaleWatcher.load();
};
watchers.ThemeWatcher = function() { };
watchers.ThemeWatcher.__name__ = true;
watchers.ThemeWatcher.load = function() {
	if(watchers.ThemeWatcher.watcher != null) watchers.ThemeWatcher.watcher.close();
	watchers.Watcher.watchFileForUpdates(watchers.SettingsWatcher.settings.theme,function() {
		new $("#theme").attr("href",watchers.SettingsWatcher.settings.theme);
	},1000);
	if(!watchers.ThemeWatcher.listenerAdded) {
		nodejs.webkit.Window.get().on("close",function(e) {
			if(watchers.ThemeWatcher.watcher != null) watchers.ThemeWatcher.watcher.close();
		});
		watchers.ThemeWatcher.listenerAdded = true;
	}
};
watchers.Watcher = function() { };
watchers.Watcher.__name__ = true;
watchers.Watcher.watchFileForUpdates = function(_path,onUpdate,_interval) {
	var config = { path : _path, listener : function(changeType,filePath,fileCurrentStat,filePreviousStat) {
		if(changeType == "update") onUpdate();
	}};
	if(_interval != null) config.interval = _interval;
	var watcher = Watchr.watch(config);
	return watcher;
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
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
var Watchr = js.Node.require("watchr");
nodejs.webkit.$ui = require('nw.gui');
nodejs.webkit.Menu = nodejs.webkit.$ui.Menu;
nodejs.webkit.MenuItem = nodejs.webkit.$ui.MenuItem;
nodejs.webkit.Window = nodejs.webkit.$ui.Window;
about.Presentation.autoplay = true;
watchers.LocaleWatcher.listenerAdded = false;
watchers.ThemeWatcher.listenerAdded = false;
about.Presentation.main();
})();
