(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/jquery-2.0.3.min.js"],function() {
		HIDE.notifyLoadingComplete(Main.$name);
	});
}
Main.$name = "boyan.jquery.script";
Main.main();
})();

//@ sourceMappingURL=Main.js.map