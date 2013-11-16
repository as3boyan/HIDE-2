(function () { "use strict";
var Main = function() { };
Main.main = function() {
	console.log("Hello World");
	HIDE.plugins.push(Main.$name);
};
Main.$name = "boyan.helloworld";
Main.dependencies = [];
Main.main();
})();
