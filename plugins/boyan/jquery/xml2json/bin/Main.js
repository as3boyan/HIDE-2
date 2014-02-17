(function () { "use strict";
var Main = function() { }
Main.main = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/jquery.xml2json.js"],function() {
		HIDE.notifyLoadingComplete(Main.$name);
	});
}
Main.$name = "boyan.jquery.xml2json";
Main.main();
})();

//@ sourceMappingURL=Main.js.map