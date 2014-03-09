(function () { "use strict";
var HxOverrides = function() { };
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		window.document.addEventListener("mousewheel",function(e) {
			if(e.altKey) {
				if(e.wheelDeltaY < 0) {
					var fontSize = Std.parseInt(new $(".CodeMirror").css("font-size"));
					fontSize--;
					Main.setFontSize(fontSize);
					e.preventDefault();
					e.stopPropagation();
				} else if(e.wheelDeltaY > 0) {
					var fontSize1 = Std.parseInt(new $(".CodeMirror").css("font-size"));
					fontSize1++;
					Main.setFontSize(fontSize1);
					e.preventDefault();
					e.stopPropagation();
				}
			}
		});
		BootstrapMenu.getMenu("View").addMenuItem("Increase Font Size",10001,function() {
			var fontSize2 = Std.parseInt(new $(".CodeMirror").css("font-size"));
			fontSize2++;
			Main.setFontSize(fontSize2);
		},"Ctrl-+",187,true,false,false);
		BootstrapMenu.getMenu("View").addMenuItem("Decrease Font Size",10002,function() {
			var fontSize3 = Std.parseInt(new $(".CodeMirror").css("font-size"));
			fontSize3--;
			Main.setFontSize(fontSize3);
		},"Ctrl--",189,true,false,false);
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
Main.setFontSize = function(fontSize) {
	new $(".CodeMirror").css("font-size","" + fontSize + "px");
	new $(".CodeMirror-hint").css("font-size","" + (fontSize - 2) + "px");
	new $(".CodeMirror-hints").css("font-size","" + (fontSize - 2) + "px");
};
var Std = function() { };
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Main.$name = "boyan.codemirror.zoom";
Main.dependencies = ["boyan.bootstrap.menu"];
Main.main();
})();

//# sourceMappingURL=Main.js.map