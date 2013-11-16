(function () { "use strict";
var HxOverrides = function() { };
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
};
var Main = function() { };
Main.main = function() {
	window.document.body.style.overflow = "hidden";
	var time = 0;
	var timer = new haxe.Timer(100);
	timer.run = function() {
		if(Lambda.has(HIDE.plugins,"boyan.jquery")) {
			Main.loadBootstrap();
			timer.stop();
		} else if(time < 3000) time += 100; else console.log("can't load plugin, dependecies are not found");
	};
	HIDE.loadCSS("../plugins/boyan/bootstrap/bin/includes/css/bootstrap.min.css");
	HIDE.loadCSS("../plugins/boyan/bootstrap/bin/includes/css/bootstrap-glyphicons.css");
};
Main.loadBootstrap = function() {
	HIDE.loadJS("../plugins/boyan/bootstrap/bin/includes/js/bootstrap/bootstrap.min.js",function() {
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
	});
};
var haxe = {};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
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
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Main.main();
})();
