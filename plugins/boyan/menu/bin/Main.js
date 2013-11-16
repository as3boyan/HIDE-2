(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.plugins.push(Main.$name);
};
Main.$name = "boyan.menu";
Main.dependencies = ["boyan.bootstrap"];
Main.main();
})();
