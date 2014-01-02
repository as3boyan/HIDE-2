(function ($hx_exports) { "use strict";
var Main = function() { };
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		HIDE.loadJS(Main.$name,["bin/includes/acorn/acorn.js","bin/includes/acorn/acorn_loose.js","bin/includes/acorn/util/walk.js","bin/includes/tern/doc/demo/polyfill.js","bin/includes/tern/lib/signal.js","bin/includes/tern/lib/tern.js","bin/includes/tern/lib/def.js","bin/includes/tern/lib/comment.js","bin/includes/tern/lib/infer.js","bin/includes/tern/plugin/doc_comment.js"],function() {
			var server = new CodeMirror.TernServer({ defs : [], plugins : { doc_comment : true}, workerDeps : [], workerScript : "bin/includes/codemirror-3.18/addon/tern/worker.js", useWorker : false});
			CM.editor.on("cursorActivity",function(cm) {
				server.updateArgHints(cm);
			});
			TS.server = server;
			HIDE.notifyLoadingComplete(Main.$name);
		});
	});
};
var TS = $hx_exports.TS = function() { };
Main.$name = "boyan.tern.server";
Main.dependencies = ["boyan.codemirror.editor"];
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map