(function () { "use strict";
var FileDialog = function() { }
$hxExpose(FileDialog, "FileDialog");
FileDialog.create = function() {
	FileDialog.input = js.Browser.document.createElement("input");
	FileDialog.input.type = "file";
	FileDialog.input.style.display = "none";
	FileDialog.input.addEventListener("change",function(e) {
		var value = FileDialog.input.value;
		if(value != "") FileDialog.onClick(value);
	});
	js.Browser.document.body.appendChild(FileDialog.input);
}
FileDialog.openFile = function(_onClick) {
	FileDialog.input.value = "";
	FileDialog.onClick = _onClick;
	if(FileDialog.input.hasAttribute("nwsaveas")) FileDialog.input.removeAttribute("nwsaveas");
	if(FileDialog.input.hasAttribute("nwdirectory")) FileDialog.input.removeAttribute("nwdirectory");
	FileDialog.input.click();
}
FileDialog.saveFile = function(_onClick,_name) {
	FileDialog.input.value = "";
	FileDialog.onClick = _onClick;
	if(_name == null) _name = "";
	if(FileDialog.input.hasAttribute("nwdirectory")) FileDialog.input.removeAttribute("nwdirectory");
	FileDialog.input.setAttribute("nwsaveas",_name);
	FileDialog.input.click();
}
FileDialog.openFolder = function(_onClick) {
	FileDialog.input.value = "";
	FileDialog.onClick = _onClick;
	if(FileDialog.input.hasAttribute("nwsaveas")) FileDialog.input.removeAttribute("nwsaveas");
	FileDialog.input.setAttribute("nwdirectory","");
	FileDialog.input.click();
}
var Main = function() { }
Main.main = function() {
	FileDialog.create();
	HIDE.notifyLoadingComplete(Main.$name);
}
var js = {}
js.Browser = function() { }
Main.$name = "boyan.window.file-dialog";
js.Browser.document = typeof window != "undefined" ? window.document : null;
Main.main();
function $hxExpose(src, path) {
	var o = typeof window != "undefined" ? window : exports;
	var parts = path.split(".");
	for(var ii = 0; ii < parts.length-1; ++ii) {
		var p = parts[ii];
		if(typeof o[p] == "undefined") o[p] = {};
		o = o[p];
	}
	o[parts[parts.length-1]] = src;
}
})();

//@ sourceMappingURL=Main.js.map