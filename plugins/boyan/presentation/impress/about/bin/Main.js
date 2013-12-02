(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.openPageInNewWindow(Main.$name,"bin/index.html",{ toolbar : true});
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.presentation.impress.about";
Main.main();
})();

//# sourceMappingURL=Main.js.map