(function () { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		window.addEventListener("dragover",function(e) {
			e.preventDefault();
			e.stopPropagation();
			return false;
		});
		window.addEventListener("drop",function(e1) {
			e1.preventDefault();
			e1.stopPropagation();
			var _g1 = 0;
			var _g = e1.dataTransfer.files.length;
			while(_g1 < _g) {
				var i = _g1++;
				TabManager.openFileInNewTab(e1.dataTransfer.files[i].path);
			}
			return false;
		});
		HIDE.notifyLoadingComplete(Main.$name);
	});
};
Main.$name = "boyan.window.drag-and-drop";
Main.dependencies = ["boyan.bootstrap.tab-manager"];
Main.main();
})();

//# sourceMappingURL=Main.js.map