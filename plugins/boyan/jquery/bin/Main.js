(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.loadJS("../plugins/boyan/jquery/bin/includes/js/jquery/jquery-2.0.3.min.js",function() {
		HIDE.plugins.push("boyan.jquery");
	});
};
Main.main();
})();
