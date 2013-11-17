(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.dependencies,Main.load);
	HIDE.plugins.push(Main.$name);
};
Main.load = function() {
	console.log("Ready to use split-pane");
};
Main.$name = "boyan.split-pane";
Main.dependencies = ["boyan.jquery"];
Main.main();
})();

//# sourceMappingURL=Main.js.map