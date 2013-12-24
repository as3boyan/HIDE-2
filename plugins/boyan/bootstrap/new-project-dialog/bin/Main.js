(function ($hx_exports) { "use strict";
var Category = $hx_exports.Category = function(_element) {
	this.subcategories = new haxe.ds.StringMap();
	this.items = new Array();
	this.element = _element;
};
Category.__name__ = true;
Category.prototype = {
	getCategory: function(name) {
		if(!this.subcategories.exists(name)) NewProjectDialog.createSubcategory(name,this);
		return this.subcategories.get(name);
	}
	,addItem: function(name,createProjectFunction,showCreateDirectoryOption,nameLocked) {
		if(nameLocked == null) nameLocked = false;
		if(showCreateDirectoryOption == null) showCreateDirectoryOption = true;
		this.items.push(new Item(name,createProjectFunction,showCreateDirectoryOption,nameLocked));
	}
	,getItems: function() {
		var itemNames = new Array();
		var _g = 0;
		var _g1 = this.items;
		while(_g < _g1.length) {
			var item = _g1[_g];
			++_g;
			itemNames.push(item.name);
		}
		return itemNames;
	}
	,select: function() {
		NewProjectDialog.updateListItems(this);
	}
	,getItem: function(name) {
		var currentItem = null;
		var _g = 0;
		var _g1 = this.items;
		while(_g < _g1.length) {
			var item = _g1[_g];
			++_g;
			if(name == item.name) currentItem = item;
		}
		return currentItem;
	}
	,__class__: Category
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Item = $hx_exports.Item = function(_name,_createProjectFunction,_showCreateDirectoryOption,_nameLocked) {
	if(_nameLocked == null) _nameLocked = false;
	if(_showCreateDirectoryOption == null) _showCreateDirectoryOption = true;
	this.name = _name;
	this.showCreateDirectoryOption = _showCreateDirectoryOption;
	this.nameLocked = _nameLocked;
	this.createProjectFunction = _createProjectFunction;
};
Item.__name__ = true;
Item.prototype = {
	__class__: Item
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	HIDE.waitForDependentPluginsToBeLoaded(Main.$name,Main.dependencies,function() {
		NewProjectDialog.create();
		BootstrapMenu.getMenu("File",1).addMenuItem("New Project...",1,NewProjectDialog.show,"Ctrl-Shift-N",78,true,true,false);
	});
	HIDE.loadCSS(Main.$name,["bin/includes/css/new-project-dialog.css"]);
	HIDE.notifyLoadingComplete(Main.$name);
};
var IMap = function() { };
IMap.__name__ = true;
var haxe = {};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe.ds.StringMap
};
var NewProjectDialog = $hx_exports.NewProjectDialog = function() { };
NewProjectDialog.__name__ = true;
NewProjectDialog.create = function() {
	var _this = window.document;
	NewProjectDialog.modal = _this.createElement("div");
	NewProjectDialog.modal.className = "modal fade";
	var dialog;
	var _this = window.document;
	dialog = _this.createElement("div");
	dialog.className = "modal-dialog";
	NewProjectDialog.modal.appendChild(dialog);
	var content;
	var _this = window.document;
	content = _this.createElement("div");
	content.className = "modal-content";
	dialog.appendChild(content);
	var header;
	var _this = window.document;
	header = _this.createElement("div");
	header.className = "modal-header";
	content.appendChild(header);
	var button;
	var _this = window.document;
	button = _this.createElement("button");
	button.type = "button";
	button.className = "close";
	button.setAttribute("data-dismiss","modal");
	button.setAttribute("aria-hidden","true");
	button.innerHTML = "&times;";
	header.appendChild(button);
	var h4;
	h4 = js.Boot.__cast(window.document.createElement("h4") , HTMLHeadingElement);
	h4.className = "modal-title";
	h4.textContent = "New Project";
	header.appendChild(h4);
	var body;
	var _this = window.document;
	body = _this.createElement("div");
	body.className = "modal-body";
	body.style.overflow = "hidden";
	content.appendChild(body);
	NewProjectDialog.textfieldsWithCheckboxes = new haxe.ds.StringMap();
	NewProjectDialog.checkboxes = new haxe.ds.StringMap();
	NewProjectDialog.createPage1();
	body.appendChild(NewProjectDialog.page1);
	NewProjectDialog.createPage2();
	NewProjectDialog.page2.style.display = "none";
	body.appendChild(NewProjectDialog.page2);
	var footer;
	var _this = window.document;
	footer = _this.createElement("div");
	footer.className = "modal-footer";
	content.appendChild(footer);
	var _this = window.document;
	NewProjectDialog.backButton = _this.createElement("button");
	NewProjectDialog.backButton.type = "button";
	NewProjectDialog.backButton.className = "btn btn-default disabled";
	NewProjectDialog.backButton.textContent = "Back";
	footer.appendChild(NewProjectDialog.backButton);
	var _this = window.document;
	NewProjectDialog.nextButton = _this.createElement("button");
	NewProjectDialog.nextButton.type = "button";
	NewProjectDialog.nextButton.className = "btn btn-default";
	NewProjectDialog.nextButton.textContent = "Next";
	NewProjectDialog.backButton.onclick = function(e) {
		if(NewProjectDialog.backButton.className.indexOf("disabled") == -1) NewProjectDialog.showPage1();
	};
	NewProjectDialog.nextButton.onclick = function(e) {
		if(NewProjectDialog.nextButton.className.indexOf("disabled") == -1) NewProjectDialog.showPage2();
	};
	footer.appendChild(NewProjectDialog.nextButton);
	var finishButton;
	var _this = window.document;
	finishButton = _this.createElement("button");
	finishButton.type = "button";
	finishButton.className = "btn btn-default";
	finishButton.textContent = "Finish";
	finishButton.onclick = function(e) {
		if(NewProjectDialog.page1.style.display != "none" || NewProjectDialog.projectName.value == "") NewProjectDialog.generateProjectName(NewProjectDialog.createProject); else NewProjectDialog.createProject();
	};
	footer.appendChild(finishButton);
	var cancelButton;
	var _this = window.document;
	cancelButton = _this.createElement("button");
	cancelButton.type = "button";
	cancelButton.className = "btn btn-default";
	cancelButton.setAttribute("data-dismiss","modal");
	cancelButton.textContent = "Cancel";
	footer.appendChild(cancelButton);
	window.document.body.appendChild(NewProjectDialog.modal);
	window.addEventListener("keyup",function(e) {
		if(e.keyCode == 27) new $(NewProjectDialog.modal).modal("hide");
	});
	var location = js.Browser.getLocalStorage().getItem("Location");
	if(location != null) NewProjectDialog.projectLocation.value = location;
	NewProjectDialog.loadData("Package");
	NewProjectDialog.loadData("Company");
	NewProjectDialog.loadData("License");
	NewProjectDialog.loadData("URL");
	NewProjectDialog.loadCheckboxState("Package");
	NewProjectDialog.loadCheckboxState("Company");
	NewProjectDialog.loadCheckboxState("License");
	NewProjectDialog.loadCheckboxState("URL");
	NewProjectDialog.loadCheckboxState("CreateDirectory");
};
NewProjectDialog.showPage1 = function() {
	new $(NewProjectDialog.page1).show(300);
	new $(NewProjectDialog.page2).hide(300);
	NewProjectDialog.backButton.className = "btn btn-default disabled";
	NewProjectDialog.nextButton.className = "btn btn-default";
};
NewProjectDialog.showPage2 = function() {
	NewProjectDialog.generateProjectName();
	new $(NewProjectDialog.page1).hide(300);
	new $(NewProjectDialog.page2).show(300);
	NewProjectDialog.backButton.className = "btn btn-default";
	NewProjectDialog.nextButton.className = "btn btn-default disabled";
};
NewProjectDialog.createProject = function() {
	if(NewProjectDialog.projectLocation.value != "" && NewProjectDialog.projectName.value != "") js.Node.require("fs").exists(NewProjectDialog.projectLocation.value,function(exists) {
		if(exists) {
			js.Node.process.chdir(js.Node.require("path").join(NewProjectDialog.projectLocation.value));
			var project = new Project();
			var item = NewProjectDialog.selectedCategory.getItem(NewProjectDialog.list.value);
			if(item.createProjectFunction != null) item.createProjectFunction({ projectName : NewProjectDialog.projectName.value, projectLocation : NewProjectDialog.projectLocation.value});
			var name = NewProjectDialog.projectName.value;
			if(name != "") project.name = name;
			var projectPackage = NewProjectDialog.textfieldsWithCheckboxes.get("Package").value;
			if(NewProjectDialog.checkboxes.get("Package").checked && projectPackage != "") project.projectPackage = projectPackage;
			var company = NewProjectDialog.textfieldsWithCheckboxes.get("Company").value;
			if(NewProjectDialog.checkboxes.get("Company").checked && company != "") project.company = company;
			var license = NewProjectDialog.textfieldsWithCheckboxes.get("License").value;
			if(NewProjectDialog.checkboxes.get("License").checked && license != "") project.license = license;
			var url = NewProjectDialog.textfieldsWithCheckboxes.get("URL").value;
			if(NewProjectDialog.checkboxes.get("URL").checked && url != "") project.url = url;
			var path;
			if(!NewProjectDialog.selectedCategory.getItem(NewProjectDialog.list.value).showCreateDirectoryOption || NewProjectDialog.createDirectoryForProject.checked) path = js.Node.require("path").join(NewProjectDialog.projectLocation.value,NewProjectDialog.projectName.value,"project.hide"); else path = js.Node.require("path").join(NewProjectDialog.projectLocation.value,"project.hide");
			NewProjectDialog.saveData("Package");
			NewProjectDialog.saveData("Company");
			NewProjectDialog.saveData("License");
			NewProjectDialog.saveData("URL");
			NewProjectDialog.saveCheckboxState("Package");
			NewProjectDialog.saveCheckboxState("Company");
			NewProjectDialog.saveCheckboxState("License");
			NewProjectDialog.saveCheckboxState("URL");
			NewProjectDialog.saveCheckboxState("CreateDirectory");
			NewProjectDialog.hide();
		}
	});
};
NewProjectDialog.generateProjectName = function(onGenerated) {
	if(NewProjectDialog.selectedCategory.getItem(NewProjectDialog.list.value).nameLocked == false) {
		var value = StringTools.replace(NewProjectDialog.list.value,"+","p");
		value = StringTools.replace(value,"#","sharp");
		value = StringTools.replace(value," ","");
		NewProjectDialog.generateFolderName(NewProjectDialog.projectLocation.value,value,1,onGenerated);
	} else {
		NewProjectDialog.projectName.value = NewProjectDialog.list.value;
		NewProjectDialog.updateHelpBlock();
		if(onGenerated != null) onGenerated();
	}
	if(NewProjectDialog.selectedCategory.getItem(NewProjectDialog.list.value).showCreateDirectoryOption) NewProjectDialog.createDirectoryForProject.parentElement.parentElement.style.display = "block"; else NewProjectDialog.createDirectoryForProject.parentElement.parentElement.style.display = "none";
	NewProjectDialog.projectName.disabled = NewProjectDialog.selectedCategory.getItem(NewProjectDialog.list.value).nameLocked;
};
NewProjectDialog.show = function() {
	if(NewProjectDialog.page1.style.display == "none") NewProjectDialog.backButton.click();
	new $(NewProjectDialog.modal).modal("show");
};
NewProjectDialog.hide = function() {
	new $(NewProjectDialog.modal).modal("hide");
};
NewProjectDialog.getCategory = function(name) {
	if(!NewProjectDialog.categories.exists(name)) {
		var category = NewProjectDialog.createCategory(name);
		NewProjectDialog.categories.set(name,category);
		NewProjectDialog.tree.appendChild(category.element);
	}
	return NewProjectDialog.categories.get(name);
};
NewProjectDialog.createOpenFLProject = function(params) {
	var OpenFLTools = js.Node.require("child_process").spawn("haxelib",["run","openfl","create"].concat(params));
	var log = "";
	OpenFLTools.stderr.setEncoding("utf8");
	OpenFLTools.stderr.on("data",function(data) {
		var str = data.toString();
		log += str;
	});
	OpenFLTools.on("close",function(code) {
		console.log("exit code: " + Std.string(code));
		console.log(log);
		var path = js.Node.require("path").join(NewProjectDialog.projectLocation.value,NewProjectDialog.projectName.value);
		if(NewProjectDialog.list.value != NewProjectDialog.projectName.value) js.Node.require("fs").rename(js.Node.require("path").join(NewProjectDialog.projectLocation.value,NewProjectDialog.list.value),path,function(error) {
			if(error != null) console.log(error);
		}); else {
		}
	});
};
NewProjectDialog.generateFolderName = function(path,folder,n,onGenerated) {
	if(path != "" && folder != "") js.Node.require("fs").exists(js.Node.require("path").join(path,folder + Std.string(n)),function(exists) {
		if(exists) NewProjectDialog.generateFolderName(path,folder,n + 1,onGenerated); else {
			NewProjectDialog.projectName.value = folder + Std.string(n);
			NewProjectDialog.updateHelpBlock();
			if(onGenerated != null) onGenerated();
		}
	}); else {
		NewProjectDialog.projectName.value = folder + Std.string(n);
		NewProjectDialog.updateHelpBlock();
	}
};
NewProjectDialog.loadData = function(_text) {
	var text = js.Browser.getLocalStorage().getItem(_text);
	if(text != null) NewProjectDialog.textfieldsWithCheckboxes.get(_text).value = text;
};
NewProjectDialog.saveData = function(_text) {
	if(NewProjectDialog.checkboxes.get(_text).checked) {
		var value = NewProjectDialog.textfieldsWithCheckboxes.get(_text).value;
		if(value != "") js.Browser.getLocalStorage().setItem(_text,value);
	}
};
NewProjectDialog.loadCheckboxState = function(_text) {
	var text = js.Browser.getLocalStorage().getItem(_text + "Checkbox");
	if(text != null) NewProjectDialog.checkboxes.get(_text).checked = js.Node.parse(text);
};
NewProjectDialog.saveCheckboxState = function(_text) {
	js.Browser.getLocalStorage().setItem(_text + "Checkbox",js.Node.stringify(NewProjectDialog.checkboxes.get(_text).checked));
};
NewProjectDialog.createPage1 = function() {
	var _this = window.document;
	NewProjectDialog.page1 = _this.createElement("div");
	var well;
	var _this = window.document;
	well = _this.createElement("div");
	well.id = "new-project-dialog-well";
	well.className = "well";
	well.style.float = "left";
	well.style.width = "50%";
	well.style.height = "250px";
	well.style.marginBottom = "0";
	NewProjectDialog.page1.appendChild(well);
	var _this = window.document;
	NewProjectDialog.tree = _this.createElement("ul");
	NewProjectDialog.tree.className = "nav nav-list";
	well.appendChild(NewProjectDialog.tree);
	NewProjectDialog.list = NewProjectDialog.createList();
	NewProjectDialog.list.style.float = "left";
	NewProjectDialog.list.style.width = "50%";
	NewProjectDialog.list.style.height = "250px";
	NewProjectDialog.page1.appendChild(NewProjectDialog.list);
	NewProjectDialog.page1.appendChild((function($this) {
		var $r;
		var _this = window.document;
		$r = _this.createElement("br");
		return $r;
	}(this)));
	var _this = window.document;
	NewProjectDialog.description = _this.createElement("p");
	NewProjectDialog.description.style.width = "100%";
	NewProjectDialog.description.style.height = "50px";
	NewProjectDialog.description.style.overflow = "auto";
	NewProjectDialog.description.textContent = "Description";
	NewProjectDialog.page1.appendChild(NewProjectDialog.description);
	return NewProjectDialog.page1;
};
NewProjectDialog.createPage2 = function() {
	var _this = window.document;
	NewProjectDialog.page2 = _this.createElement("div");
	NewProjectDialog.page2.style.padding = "15px";
	var row;
	var _this = window.document;
	row = _this.createElement("div");
	row.className = "row";
	var _this = window.document;
	NewProjectDialog.projectName = _this.createElement("input");
	NewProjectDialog.projectName.type = "text";
	NewProjectDialog.projectName.className = "form-control";
	NewProjectDialog.projectName.placeholder = "Name";
	NewProjectDialog.projectName.style.width = "100%";
	row.appendChild(NewProjectDialog.projectName);
	NewProjectDialog.page2.appendChild(row);
	var _this = window.document;
	row = _this.createElement("div");
	row.className = "row";
	var inputGroup;
	var _this = window.document;
	inputGroup = _this.createElement("div");
	inputGroup.className = "input-group";
	inputGroup.style.display = "inline";
	row.appendChild(inputGroup);
	var _this = window.document;
	NewProjectDialog.projectLocation = _this.createElement("input");
	NewProjectDialog.projectLocation.type = "text";
	NewProjectDialog.projectLocation.className = "form-control";
	NewProjectDialog.projectLocation.placeholder = "Location";
	NewProjectDialog.projectLocation.style.width = "80%";
	inputGroup.appendChild(NewProjectDialog.projectLocation);
	var browseButton;
	var _this = window.document;
	browseButton = _this.createElement("button");
	browseButton.type = "button";
	browseButton.className = "btn btn-default";
	browseButton.textContent = "Browse...";
	browseButton.style.width = "20%";
	browseButton.onclick = function(e) {
		FileDialog.openFolder(function(path) {
			NewProjectDialog.projectLocation.value = path;
			NewProjectDialog.updateHelpBlock();
			js.Browser.getLocalStorage().setItem("Location",path);
		});
	};
	inputGroup.appendChild(browseButton);
	NewProjectDialog.page2.appendChild(row);
	NewProjectDialog.createTextWithCheckbox(NewProjectDialog.page2,"Package");
	NewProjectDialog.createTextWithCheckbox(NewProjectDialog.page2,"Company");
	NewProjectDialog.createTextWithCheckbox(NewProjectDialog.page2,"License");
	NewProjectDialog.createTextWithCheckbox(NewProjectDialog.page2,"URL");
	var _this = window.document;
	row = _this.createElement("div");
	row.className = "row";
	var checkboxDiv;
	var _this = window.document;
	checkboxDiv = _this.createElement("div");
	checkboxDiv.className = "checkbox";
	row.appendChild(checkboxDiv);
	var label;
	var _this = window.document;
	label = _this.createElement("label");
	checkboxDiv.appendChild(label);
	var _this = window.document;
	NewProjectDialog.createDirectoryForProject = _this.createElement("input");
	NewProjectDialog.createDirectoryForProject.type = "checkbox";
	NewProjectDialog.createDirectoryForProject.checked = true;
	label.appendChild(NewProjectDialog.createDirectoryForProject);
	NewProjectDialog.checkboxes.set("CreateDirectory",NewProjectDialog.createDirectoryForProject);
	NewProjectDialog.createDirectoryForProject.onchange = function(e) {
		NewProjectDialog.updateHelpBlock();
	};
	label.appendChild(window.document.createTextNode("Create directory for project"));
	NewProjectDialog.page2.appendChild(row);
	var _this = window.document;
	row = _this.createElement("div");
	var _this = window.document;
	NewProjectDialog.helpBlock = _this.createElement("p");
	NewProjectDialog.helpBlock.className = "help-block";
	row.appendChild(NewProjectDialog.helpBlock);
	NewProjectDialog.projectLocation.onchange = function(e) {
		NewProjectDialog.updateHelpBlock();
		NewProjectDialog.generateFolderName(NewProjectDialog.projectLocation.value,NewProjectDialog.projectName.value,1);
	};
	NewProjectDialog.projectName.onchange = function(e) {
		NewProjectDialog.projectName.value = HxOverrides.substr(NewProjectDialog.projectName.value,0,1).toUpperCase() + HxOverrides.substr(NewProjectDialog.projectName.value,1,null);
		NewProjectDialog.updateHelpBlock();
	};
	NewProjectDialog.page2.appendChild(row);
	return NewProjectDialog.page2;
};
NewProjectDialog.updateHelpBlock = function() {
	if(NewProjectDialog.projectLocation.value != "") {
		var str = "";
		if((!NewProjectDialog.selectedCategory.getItem(NewProjectDialog.list.value).showCreateDirectoryOption || NewProjectDialog.createDirectoryForProject.checked == true) && NewProjectDialog.projectName.value != "") str = NewProjectDialog.projectName.value;
		NewProjectDialog.helpBlock.innerText = "Project will be created in: " + js.Node.require("path").join(NewProjectDialog.projectLocation.value,str);
	} else NewProjectDialog.helpBlock.innerText = "";
};
NewProjectDialog.createTextWithCheckbox = function(_page2,_text) {
	var row;
	var _this = window.document;
	row = _this.createElement("div");
	row.className = "row";
	var inputGroup;
	var _this = window.document;
	inputGroup = _this.createElement("div");
	inputGroup.className = "input-group";
	row.appendChild(inputGroup);
	var inputGroupAddon;
	var _this = window.document;
	inputGroupAddon = _this.createElement("span");
	inputGroupAddon.className = "input-group-addon";
	inputGroup.appendChild(inputGroupAddon);
	var checkbox;
	var _this = window.document;
	checkbox = _this.createElement("input");
	checkbox.type = "checkbox";
	checkbox.checked = true;
	inputGroupAddon.appendChild(checkbox);
	NewProjectDialog.checkboxes.set(_text,checkbox);
	var text;
	var _this = window.document;
	text = _this.createElement("input");
	text.type = "text";
	text.className = "form-control";
	text.placeholder = _text;
	NewProjectDialog.textfieldsWithCheckboxes.set(_text,text);
	checkbox.onchange = function(e) {
		if(checkbox.checked) text.disabled = false; else text.disabled = true;
	};
	inputGroup.appendChild(text);
	_page2.appendChild(row);
};
NewProjectDialog.createCategory = function(text) {
	var li;
	var _this = window.document;
	li = _this.createElement("li");
	var category = new Category(li);
	var a;
	var _this = window.document;
	a = _this.createElement("a");
	a.href = "#";
	a.addEventListener("click",function(e) {
		NewProjectDialog.updateListItems(category);
	});
	var span;
	var _this = window.document;
	span = _this.createElement("span");
	span.className = "glyphicon glyphicon-folder-open";
	a.appendChild(span);
	var _this = window.document;
	span = _this.createElement("span");
	span.textContent = text;
	span.style.marginLeft = "5px";
	a.appendChild(span);
	li.appendChild(a);
	return category;
};
NewProjectDialog.createSubcategory = function(text,category) {
	var a;
	a = js.Boot.__cast(category.element.getElementsByTagName("a")[0] , HTMLAnchorElement);
	a.className = "tree-toggler nav-header";
	a.onclick = function(e) {
		new $(category.element).children("ul.tree").toggle(300);
	};
	var ul;
	var _this = window.document;
	ul = _this.createElement("ul");
	ul.className = "nav nav-list tree";
	category.element.appendChild(ul);
	category.element.onclick = function(e) {
		var $it0 = category.subcategories.keys();
		while( $it0.hasNext() ) {
			var subcategory = $it0.next();
			ul.appendChild(category.subcategories.get(subcategory).element);
		}
		e.stopPropagation();
		e.preventDefault();
		category.element.onclick = null;
		new $(ul).show(300);
	};
	var subcategory = NewProjectDialog.createCategory(text);
	category.subcategories.set(text,subcategory);
};
NewProjectDialog.updateListItems = function(category) {
	NewProjectDialog.selectedCategory = category;
	new $(NewProjectDialog.list).children().remove();
	NewProjectDialog.setListItems(NewProjectDialog.list,category.getItems());
	NewProjectDialog.checkSelectedOptions();
};
NewProjectDialog.createCategoryWithSubcategories = function(text,subcategories) {
	var li;
	var _this = window.document;
	li = _this.createElement("li");
	var category = NewProjectDialog.createCategory(text);
	var a;
	a = js.Boot.__cast(li.getElementsByTagName("a")[0] , HTMLAnchorElement);
	a.className = "tree-toggler nav-header";
	a.onclick = function(e) {
		new $(li).children("ul.tree").toggle(300);
	};
	var ul;
	var _this = window.document;
	ul = _this.createElement("ul");
	ul.className = "nav nav-list tree";
	li.appendChild(ul);
	li.onclick = function(e) {
		var _g = 0;
		while(_g < subcategories.length) {
			var subcategory = subcategories[_g];
			++_g;
			ul.appendChild(NewProjectDialog.createCategory(subcategory).element);
		}
		e.stopPropagation();
		e.preventDefault();
		li.onclick = null;
		new $(ul).show(300);
	};
	return li;
};
NewProjectDialog.createList = function() {
	var select;
	var _this = window.document;
	select = _this.createElement("select");
	select.size = 10;
	select.onchange = function(e) {
		NewProjectDialog.checkSelectedOptions();
	};
	select.ondblclick = function(e) {
		NewProjectDialog.showPage2();
	};
	return select;
};
NewProjectDialog.checkSelectedOptions = function() {
	if(NewProjectDialog.list.selectedOptions.length > 0) {
		var option;
		option = js.Boot.__cast(NewProjectDialog.list.selectedOptions[0] , HTMLOptionElement);
	}
};
NewProjectDialog.updateDescription = function(category,selectedOption) {
	NewProjectDialog.description.textContent = selectedOption;
};
NewProjectDialog.setListItems = function(list,items) {
	var _g = 0;
	while(_g < items.length) {
		var item = items[_g];
		++_g;
		list.appendChild(NewProjectDialog.createListItem(item));
	}
	list.selectedIndex = 0;
	NewProjectDialog.checkSelectedOptions();
};
NewProjectDialog.createListItem = function(text) {
	var option;
	var _this = window.document;
	option = _this.createElement("option");
	option.textContent = text;
	option.value = text;
	return option;
};
var Project = $hx_exports.Project = function() {
	this.customArgs = false;
};
Project.__name__ = true;
Project.prototype = {
	__class__: Project
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
js.Browser = function() { };
js.Browser.__name__ = true;
js.Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
};
js.Node = function() { };
js.Node.__name__ = true;
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
var module, setImmediate, clearImmediate;
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
var version = HxOverrides.substr(js.Node.process.version,1,null).split(".").map(Std.parseInt);
if(version[0] > 0 || version[1] >= 9) {
	js.Node.setImmediate = setImmediate;
	js.Node.clearImmediate = clearImmediate;
}
Main.$name = "boyan.bootstrap.new-project-dialog";
Main.dependencies = ["boyan.bootstrap.menu","boyan.window.file-dialog"];
NewProjectDialog.categories = new haxe.ds.StringMap();
Project.HAXE = 0;
Project.OPENFL = 1;
Project.HXML = 2;
Main.main();
})(typeof window != "undefined" ? window : exports);

//# sourceMappingURL=Main.js.map