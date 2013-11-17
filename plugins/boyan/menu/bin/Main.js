(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.dependencies,Main.load);
};
Main.load = function() {
	HIDE.plugins.push(Main.$name);
};
Main.$name = "boyan.menu";
Main.dependencies = ["boyan.bootstrap"];
Main.main();
})();

//# sourceMappingURL=Main.js.map