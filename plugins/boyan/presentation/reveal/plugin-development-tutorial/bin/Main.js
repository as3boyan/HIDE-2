(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.openPageInNewWindow(Main.$name,"bin/index.html",{ toolbar : false});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.presentation.reveal.plugin-development-tutorial";
Main.main();
})();

//# sourceMappingURL=Main.js.map