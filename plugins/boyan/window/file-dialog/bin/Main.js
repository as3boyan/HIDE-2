(function ($hx_exports) { "use strict";
var FileDialog = $hx_exports.FileDialog = function() { };
FileDialog.create = function() {
	var _this = window.document;
	FileDialog.input = _this.createElement("input");
	FileDialog.input.type = "file";
	FileDialog.input.style.display = "none";
	FileDialog.input.addEventListener("change",function(e) {
		var value = FileDialog.input.value;
		if(value != "") FileDialog.onClick(value);
	});
	window.document.body.appendChild(FileDialog.input);
};
FileDialog.openFile = function(_onClick) {
	FileDialog.input.value = "";
	FileDialog.onClick = _onClick;
	if(FileDialog.input.hasAttribute("nwsaveas")) FileDialog.input.removeAttribute("nwsaveas");
	if(FileDialog.input.hasAttribute("nwdirectory")) FileDialog.input.removeAttribute("nwdirectory");
	FileDialog.input.click();
};
FileDialog.saveFile = function(_onClick,_name) {
	FileDialog.input.value = "";
	FileDialog.onClick = _onClick;
	if(_name == null) _name = "";
	if(FileDialog.input.hasAttribute("nwdirectory")) FileDialog.input.removeAttribute("nwdirectory");
	FileDialog.input.setAttribute("nwsaveas",_name);
	FileDialog.input.click();
};
FileDialog.openFolder = function(_onClick) {
	FileDialog.input.value = "";
	FileDialog.onClick = _onClick;
	if(FileDialog.input.hasAttribute("nwsaveas")) FileDialog.input.removeAttribute("nwsaveas");
	FileDialog.input.setAttribute("nwdirectory","");
	FileDialog.input.click();
};
var Main = function() { };
Main.main = function() {
	FileDialog.create();
	HIDE.notifyLoadingComplete(Main.$name);
};
Main.$name = "boyan.window.file-dialog";
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map