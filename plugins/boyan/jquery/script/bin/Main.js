(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.loadJS(Main.$name,["bin/includes/js/jquery/jquery-2.0.3.min.js"],function() {
		HIDE.plugins.push(Main.$name);
	});
};
Main.$name = "boyan.jquery.script";
Main.main();
})();

//# sourceMappingURL=Main.js.map