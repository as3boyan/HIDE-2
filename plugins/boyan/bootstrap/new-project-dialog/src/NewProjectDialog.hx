package ;
//import core.FileDialog;
//import core.ProjectAccess;
//import core.TabsManager;
import haxe.ds.StringMap;
import haxe.Timer;
import jQuery.JQuery;
import js.Browser;
import js.html.AnchorElement;
import js.html.ButtonElement;
import js.html.DivElement;
import js.html.Event;
import js.html.HeadingElement;
import js.html.InputElement;
import js.html.LabelElement;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.OptionElement;
import js.html.ParagraphElement;
import js.html.SelectElement;
import js.html.SpanElement;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */
class NewProjectDialog
{
	private static var modal:DivElement;
	private static var list:SelectElement;
	private static var selectedCategory:String;
	private static var description:ParagraphElement;
	private static var helpBlock:ParagraphElement;
	private static var projectName:InputElement;
	private static var projectLocation:InputElement;
	private static var createDirectoryForProject:InputElement;
	private static var page1:DivElement;
	private static var page2:DivElement;
	private static var backButton:ButtonElement;
	private static var textfieldsWithCheckboxes:StringMap<InputElement>;
	private static var checkboxes:StringMap<InputElement>;
	private static var nextButton:ButtonElement;
	
	private static var categories:StringMap<Dynamic> = new StringMap();
	static private var tree:UListElement;
	
	public static function create():Void
	{
		modal = Browser.document.createDivElement();
		modal.className = "modal fade";
		
		var dialog:DivElement = Browser.document.createDivElement();
		dialog.className = "modal-dialog";
		modal.appendChild(dialog);
		
		var content:DivElement = Browser.document.createDivElement();
		content.className = "modal-content";
		dialog.appendChild(content);
		
		var header:DivElement = Browser.document.createDivElement();
		header.className = "modal-header";
		content.appendChild(header);
		
		var button:ButtonElement = Browser.document.createButtonElement();
		button.type = "button";
		button.className = "close";
		button.setAttribute("data-dismiss", "modal");
		button.setAttribute("aria-hidden", "true");
		button.innerHTML = "&times;";
		header.appendChild(button);
		
		var h4:HeadingElement = cast(Browser.document.createElement("h4"), HeadingElement);
		h4.className = "modal-title";
		h4.textContent = "New Project";
		header.appendChild(h4);
		
		var body:DivElement = Browser.document.createDivElement();
		body.className = "modal-body";
		body.style.overflow = "hidden";
		content.appendChild(body);
		
		textfieldsWithCheckboxes = new StringMap();
		checkboxes = new StringMap();
		
		createPage1();
		body.appendChild(page1);
		
		createPage2();
		page2.style.display = "none";
		body.appendChild(page2);
		
		var footer:DivElement = Browser.document.createDivElement();
		footer.className = "modal-footer";
		content.appendChild(footer);
		
		backButton = Browser.document.createButtonElement();
		backButton.type = "button";
		backButton.className = "btn btn-default disabled";
		backButton.textContent = "Back";
		
		footer.appendChild(backButton);
		
		nextButton = Browser.document.createButtonElement();
		nextButton.type = "button";
		nextButton.className = "btn btn-default";
		nextButton.textContent = "Next";
		
		backButton.onclick = function (e:MouseEvent)
		{
			if (backButton.className.indexOf("disabled") == -1)
			{
				showPage1();
			}
		}
		;
		
		nextButton.onclick = function (e:MouseEvent)
		{
			if (nextButton.className.indexOf("disabled") == -1)
			{
				showPage2();
			}
		}
		;
		
		footer.appendChild(nextButton);
		
		var finishButton:ButtonElement = Browser.document.createButtonElement();
		finishButton.type = "button";
		finishButton.className = "btn btn-default";
		finishButton.textContent = "Finish";
		
		finishButton.onclick = function (e:MouseEvent)
		{
			if (page1.style.display != "none" || projectName.value == "" )
			{
				generateProjectName(createProject);
			}
			else 
			{
				createProject();
			}
		}
		;
		
		footer.appendChild(finishButton);
		
		var cancelButton:ButtonElement = Browser.document.createButtonElement();
		cancelButton.type = "button";
		cancelButton.className = "btn btn-default";
		cancelButton.setAttribute("data-dismiss", "modal");
		cancelButton.textContent = "Cancel";
		
		footer.appendChild(cancelButton);
		
		Browser.document.body.appendChild(modal);
		
		updateListItems("Haxe");
		
		Browser.window.addEventListener("keyup", function (e)
		{
			if (e.keyCode == 27)
			{
				untyped new JQuery(modal).modal("hide");
			}
		}
		);
		
		var location:String = Browser.getLocalStorage().getItem("Location");
		
		if (location != null)
		{
			projectLocation.value = location;
		}
		
		loadData("Package");
		loadData("Company");
		loadData("License");
		loadData("URL");
		
		loadCheckboxState("Package");
		loadCheckboxState("Company");
		loadCheckboxState("License");
		loadCheckboxState("URL");
		loadCheckboxState("CreateDirectory");
	}
	
	private static function showPage1() 
	{
		new JQuery(page1).show(300);
		new JQuery(page2).hide(300);
		backButton.className = "btn btn-default disabled";
		nextButton.className = "btn btn-default";
	}
	
	private static function showPage2() 
	{
		generateProjectName();
				
		new JQuery(page1).hide(300);
		new JQuery(page2).show(300);
		backButton.className = "btn btn-default";
		nextButton.className = "btn btn-default disabled";
	}
	
	private static function createProject():Void
	{
		if (projectLocation.value != "" && projectName.value != "")
		{
			js.Node.fs.exists(projectLocation.value, function (exists:Bool):Void
			{
				if (exists)
				{
					js.Node.process.chdir(js.Node.path.join(projectLocation.value));
					
					var project:Project = new Project();
					
					switch (selectedCategory) 
					{
						case "Haxe":
							createDirectoryRecursively(projectLocation.value, [projectName.value, "src"], function ():Void
							{				
								var pathToMain:String  = js.Node.path.join(projectLocation.value, projectName.value, "src");
								pathToMain = js.Node.path.join(pathToMain, "Main.hx");
								
								var code:String = "package ;\n\nclass Main\n{\nstatic public function main()\n{\n}\n}";
								
								js.Node.fs.writeFile(pathToMain, code, function (error):Void
								{
									if (error != null)
									{
										trace(error);
									}
									
									//TabsManager.openFileInNewTab(pathToMain);
								}
								);
							}
							);
							
							project.type = Project.HAXE;
							
							switch (list.value) 
							{
								case "Flash Project":
									project.target = "flash";
								case "JavaScript Project":
									project.target = "html5";
								case "Neko Project":
									project.target = "neko";
								case "PHP Project":
									project.target = "php";
								case "C++ Project":
									project.target = "cpp";
								case "Java Project":
									project.target = "java";
								case "C# Project":
									project.target = "csharp";
								default:
									
							}
							
							var pathToMain:String  = js.Node.path.join(projectName.value, "src");
							pathToMain = js.Node.path.join(pathToMain, "Main.hx");
							
							project.main = pathToMain;
						case "OpenFL":
							switch (list.value) 
							{
								case "OpenFL Project":		
									var projectPackage:String = textfieldsWithCheckboxes.get("Package").value;
									
									var str:String = "";
									
									if (checkboxes.get("Package").checked && projectPackage != "")
									{
										str = projectPackage + ".";
									}
									
									var params:Array<String> = ["project", str + projectName.value];
									
									var projectCompany:String = textfieldsWithCheckboxes.get("Company").value;
									
									if (checkboxes.get("Company").checked && projectCompany != "")
									{
										params.push(projectCompany);
									}
									
									createOpenFLProject(params);
								case "OpenFL Extension":
									createOpenFLProject(["extension", projectName.value]);
								default:
									
							}
							
							project.type = Project.OPENFL;
							project.target = "html5";
							project.main = "project.xml";
						case "OpenFL/Samples":
							
							createOpenFLProject([list.value]);
								
							//switch (list.value) 
							//{
								//case "ActuateExample":
									//
								//case "AddingAnimation":
									//
								//case "AddingText":
									//
								//case "DisplayingABitmap":
									//
								//case "HandlingKeyboardEvents":
									//
								//case "HandlingMouseEvent":
									//
								//case "HerokuShaders":
									//
								//case "PiratePig":
									//
								//case "PlayingSound":
									//
								//case "SimpleBox2D":
									//
								//case "SimpleOpenGLView":
									//
								//default:
									//
							//}
							
							project.type = Project.OPENFL;
							project.target = "html5";
							project.main = "project.xml";
						default:
							
					}
					
					var name:String = projectName.value;
							
					if (name != "")
					{
						project.name = name;
					}
					
					var projectPackage:String = textfieldsWithCheckboxes.get("Package").value;
					
					if (checkboxes.get("Package").checked && projectPackage != "")
					{
						project.projectPackage = projectPackage;
					}
					
					var company:String = textfieldsWithCheckboxes.get("Company").value;
					
					if (checkboxes.get("Company").checked && company != "")
					{
						project.company = company;
					}
					
					var license:String = textfieldsWithCheckboxes.get("License").value;
					
					if (checkboxes.get("License").checked && license != "")
					{
						project.license = license;
					}
					
					var url:String = textfieldsWithCheckboxes.get("URL").value;
					
					if (checkboxes.get("URL").checked && url != "")
					{
						project.url = url;
					}
					
					var path:String;
					
					if (createDirectoryForProject.checked)
					{
						path = js.Node.path.join(projectLocation.value, projectName.value, "project.hide");
					}
					else 
					{
						path = js.Node.path.join(projectLocation.value, "project.hide");
					}
					
					//js.Node.system_saveFile(path, js.Node.stringify(project));
					
					//ProjectAccess.currentProject = project;
					//Main.updateMenu();
					
					saveData("Package");
					saveData("Company");
					saveData("License");
					saveData("URL");
					
					saveCheckboxState("Package");
					saveCheckboxState("Company");
					saveCheckboxState("License");
					saveCheckboxState("URL");
					saveCheckboxState("CreateDirectory");
					
					hide();
				}
			}
			);
		}
	}
	
	private static function createDirectory(path:String, ?onCreated:Dynamic):Void
	{
		js.Node.fs.mkdir(path, function (error):Void
		{								
			if (error != null)
			{
				trace(error);
			}
			
			if (onCreated != null)
			{
				onCreated();
			}
		}
		);
	}
	
	private static function createDirectoryRecursively(path:String, folderPath:Array<String>, ?onCreated:Dynamic):Void
	{
		var fullPath:String = js.Node.path.join(path, folderPath[0]);
		
		createDirectory(fullPath, function ():Void
		{
			folderPath.splice(0, 1);
			
			if (folderPath.length > 0)
			{
				createDirectoryRecursively(fullPath, folderPath, onCreated);
			}
			else
			{
				onCreated();
			}
		}
		);
	}
	
	private static function generateProjectName(?onGenerated:Dynamic):Void
	{
		if (selectedCategory != "OpenFL/Samples")
		{
			var value:String = StringTools.replace(list.value, "+", "p");
			value = StringTools.replace(value, "#", "sharp");
			value = StringTools.replace(value, " ", "");
			
			if (selectedCategory != "OpenFL")
			{
				value = StringTools.replace(selectedCategory, "/", "") + value;
			}
			
			generateFolderName(projectLocation.value, value, 1, onGenerated);
		}
		else
		{
			projectName.value = list.value;
			updateHelpBlock();
			
			if (onGenerated != null)
			{
				onGenerated();
			}
		}
		
		if (selectedCategory != "Haxe")
		{
			createDirectoryForProject.parentElement.parentElement.style.display = "none";
		}
		else
		{
			createDirectoryForProject.parentElement.parentElement.style.display = "block";
		}
	}
	
	public static function show():Void
	{		
		if (page1.style.display == "none")
		{
			backButton.click();
		}
		
		untyped new JQuery(modal).modal("show");
	}
	
	public static function hide():Void
	{
		untyped new JQuery(modal).modal("hide");
	}
	
	public static function getCategory(name:String):Category
	{
		if (!categories.exists(name))
		{
			var category:Category = new Category(createCategory(name));
			categories.set(name, category);
			tree.appendChild(category.element);
			
			//tree.appendChild(createCategoryWithSubcategories("OpenFL", ["Samples"]));
		}
		
		return categories.get(name);
	}
	
	private static function createOpenFLProject(params:Array<String>):Void
	{
		var OpenFLTools = js.Node.childProcess.spawn("haxelib", ["run", "openfl", "create"].concat(params));
						
		var log:String = "";
		
		OpenFLTools.stderr.setEncoding('utf8');
		OpenFLTools.stderr.on('data', function (data) {
				var str:String = data.toString();
				log += str;
		}
		);
		
		OpenFLTools.on('close', function (code:Int) {
			trace("exit code: " + Std.string(code));
			
			trace(log);
			
			var path:String = js.Node.path.join(projectLocation.value, projectName.value);
			
			if (list.value != projectName.value)
			{				
				js.Node.fs.rename(js.Node.path.join(projectLocation.value, list.value), path, function (error):Void
				{
					if (error != null)
					{
						trace(error);
					}
					
					//TabsManager.openFileInNewTab(js.Node.path.join(path, "Source", "Main.hx"));
				}
				);
			}
			else
			{
				//TabsManager.openFileInNewTab(js.Node.path.join(path, "Source", "Main.hx"));
			}
		}
		);
	}
	
	private static function generateFolderName(path:String, folder:String, n:Int, ?onGenerated:Dynamic):Void
	{		
		if (path != "" && folder != "")
		{
			js.Node.fs.exists(js.Node.path.join(path, folder + Std.string(n)), function (exists:Bool):Void
			{
				if (exists)
				{
					generateFolderName(path, folder, n + 1, onGenerated);
				}
				else 
				{
					projectName.value = folder + Std.string(n);
					updateHelpBlock();
					
					if (onGenerated != null)
					{
						onGenerated();
					}
				}
			}
			);
		}
		else
		{
			projectName.value = folder + Std.string(n);
			updateHelpBlock();
		}
	}
	
	private static function loadData(_text:String):Void
	{
		var text:String = Browser.getLocalStorage().getItem(_text);
		
		if (text != null)
		{
			textfieldsWithCheckboxes.get(_text).value = text;
		}
	}
	
	private static function saveData(_text:String):Void
	{
		if (checkboxes.get(_text).checked)
		{
			var value:String = textfieldsWithCheckboxes.get(_text).value;
			
			if (value != "")
			{
				Browser.getLocalStorage().setItem(_text, value);
			}
		}
	}
	
	private static function loadCheckboxState(_text:String):Void
	{
		var text:String = Browser.getLocalStorage().getItem(_text + "Checkbox");
		
		if (text != null)
		{
			checkboxes.get(_text).checked = js.Node.parse(text);
		}
	}
	
	private static function saveCheckboxState(_text:String):Void
	{
		Browser.getLocalStorage().setItem(_text + "Checkbox", js.Node.stringify(checkboxes.get(_text).checked));
	}
	
	private static function createPage1():DivElement
	{
		page1 = Browser.document.createDivElement();
		
		var well:DivElement = Browser.document.createDivElement();
		well.className = "well";
		//well.style.overflow = "auto";
		//well.classList.add("pull-left");
		well.style.float = "left";
		well.style.width = "50%";
		well.style.height = "250px";
		well.style.marginBottom = "0";
		page1.appendChild(well);
		
		tree = Browser.document.createUListElement();
		tree.className = "nav nav-list";
		well.appendChild(tree);
		
		list = createList();
		list.style.float = "left";
		list.style.width = "50%";
		list.style.height = "250px";
		
		page1.appendChild(list);
		
		page1.appendChild(Browser.document.createBRElement());
		
		description = Browser.document.createParagraphElement();
		description.style.width = "100%";
		description.style.height = "50px";
		description.style.overflow = "auto";
		description.textContent = "Description";
		
		page1.appendChild(description);
		
		return page1;
	}
	
	private static function createPage2():DivElement
	{
		page2 = Browser.document.createDivElement();
		page2.style.padding = "15px";
		
		var row:DivElement = Browser.document.createDivElement();
		row.className = "row";
		
		projectName = Browser.document.createInputElement();
		projectName.type = "text";
		projectName.className = "form-control";
		projectName.placeholder = "Name";
		projectName.style.width = "100%";
		row.appendChild(projectName);
		
		page2.appendChild(row);
		
		row = Browser.document.createDivElement();
		row.className = "row";
		
		var inputGroup:DivElement = Browser.document.createDivElement();
		inputGroup.className = "input-group";
		inputGroup.style.display = "inline";
		row.appendChild(inputGroup);
		
		projectLocation = Browser.document.createInputElement();
		projectLocation.type = "text";
		projectLocation.className = "form-control";
		projectLocation.placeholder = "Location";
		projectLocation.style.width = "80%";
		inputGroup.appendChild(projectLocation);
		
		var browseButton:ButtonElement = Browser.document.createButtonElement();
		browseButton.type = "button";
		browseButton.className = "btn btn-default";
		browseButton.textContent = "Browse...";
		browseButton.style.width = "20%";
		
		browseButton.onclick = function (e:MouseEvent)
		{
			//FileDialog.openFolder(function (path:String):Void
			//{
				//projectLocation.value = path;
				//updateHelpBlock();
				//
				//Browser.getLocalStorage().setItem("Location", path);
			//}
			//);
		};
		
		inputGroup.appendChild(browseButton);
		
		page2.appendChild(row);
		
		createTextWithCheckbox(page2, "Package");
		createTextWithCheckbox(page2, "Company");
		createTextWithCheckbox(page2, "License");
		createTextWithCheckbox(page2, "URL");
		
		row = Browser.document.createDivElement();
		row.className = "row";
		
		var checkboxDiv:DivElement = Browser.document.createDivElement();
		checkboxDiv.className = "checkbox";
		row.appendChild(checkboxDiv);
		
		var label:LabelElement = Browser.document.createLabelElement();
		checkboxDiv.appendChild(label);
		
		createDirectoryForProject = Browser.document.createInputElement();
		createDirectoryForProject.type = "checkbox";
		createDirectoryForProject.checked = true;
		label.appendChild(createDirectoryForProject);
		
		checkboxes.set("CreateDirectory", createDirectoryForProject);
		
		createDirectoryForProject.onchange = function (e):Void
		{
			updateHelpBlock();
		};
		
		label.appendChild(Browser.document.createTextNode("Create directory for project"));
		
		page2.appendChild(row);
		
		row = Browser.document.createDivElement();
		
		helpBlock = Browser.document.createParagraphElement();
		helpBlock.className = "help-block";
		row.appendChild(helpBlock);
		
		projectLocation.onchange = function (e):Void
		{
			updateHelpBlock();
			generateFolderName(projectLocation.value, projectName.value, 1);
		};
		
		projectName.onchange = function (e):Void
		{			
			projectName.value = projectName.value.substr(0, 1).toUpperCase() + projectName.value.substr(1);
			updateHelpBlock();
		}
		
		page2.appendChild(row);
		
		return page2;
	}
	
	private static function updateHelpBlock():Void
	{
		if (projectLocation.value != "")
		{
			var str:String = "";
			
			if ((selectedCategory != "Haxe" || createDirectoryForProject.checked == true) && projectName.value != "")
			{
				str = projectName.value;
			}
			
			helpBlock.innerText = "Project will be created in: " + js.Node.path.join(projectLocation.value, str);
		}
		else
		{
			helpBlock.innerText = "";
		}
	}
	
	private static function createTextWithCheckbox(_page2:DivElement, _text:String):Void
	{
		var row:DivElement = Browser.document.createDivElement();
		row.className = "row";
		
		var inputGroup:DivElement = Browser.document.createDivElement();
		inputGroup.className = "input-group";
		row.appendChild(inputGroup);
		
		var inputGroupAddon:SpanElement = Browser.document.createSpanElement();
		inputGroupAddon.className = "input-group-addon";
		inputGroup.appendChild(inputGroupAddon);
		
		var checkbox:InputElement = Browser.document.createInputElement();
		checkbox.type = "checkbox";
		checkbox.checked = true;
		inputGroupAddon.appendChild(checkbox);
		
		checkboxes.set(_text, checkbox);
		
		var text:InputElement = Browser.document.createInputElement();
		text.type = "text";
		text.className = "form-control";
		text.placeholder = _text;
		
		textfieldsWithCheckboxes.set(_text, text);
		
		checkbox.onchange = function (e)
		{
			if (checkbox.checked)
			{
				text.disabled = false;
			}
			else
			{
				text.disabled = true;
			}
		};
		
		inputGroup.appendChild(text);
		
		_page2.appendChild(row);
	}
	
	private static function createCategory(text:String):LIElement
	{
		var li:LIElement = Browser.document.createLIElement();
			
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.href = "#";
		
		a.addEventListener("click", function (e:MouseEvent):Void
		{
			var parent = li.parentElement.parentElement;
			var topA:AnchorElement = cast(parent.getElementsByTagName("a")[0], AnchorElement);
			
			if (parent.className == "well")
			{
				updateListItems(a.textContent);
			}
			else
			{
				updateListItems(topA.innerText + "/" + a.textContent);
			}
		}
		);
		
		var span = Browser.document.createSpanElement();
		span.className = "glyphicon glyphicon-folder-open";
		a.appendChild(span);
		
		span = Browser.document.createSpanElement();
		span.textContent = text;
		span.style.marginLeft = "5px";
		a.appendChild(span);
		
		li.appendChild(a);
		
		return li;
	}
	
	private static function updateListItems(category:String):Void
	{		
		selectedCategory = category;
		
		new JQuery(list).children().remove();
		
		switch (category) 
		{
			case "Haxe":
				setListItems(list, ["Flash Project", "JavaScript Project", "Neko Project", "PHP Project", "C++ Project", "Java Project", "C# Project"]);
			case "OpenFL":
				setListItems(list, ["OpenFL Project", "OpenFL Extension"]);
			case "OpenFL/Samples":
				setListItems(list, ["ActuateExample", "AddingAnimation", "AddingText", "DisplayingABitmap", "HandlingKeyboardEvents", "HandlingMouseEvent", "HerokuShaders", "PiratePig", "PlayingSound", "SimpleBox2D", "SimpleOpenGLView"]);
			default:
					
		}
		
		checkSelectedOptions();
	}
	
	public static function createCategoryWithSubcategories(text:String, subcategories:Array<String>):LIElement
	{
		var li:LIElement = createCategory(text);
		
		var a:AnchorElement = cast(li.getElementsByTagName("a")[0], AnchorElement);
		a.className = "tree-toggler nav-header";
		
		a.onclick = function (e:MouseEvent):Void
		{
			new JQuery(li).children('ul.tree').toggle(300);
		};
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.className = "nav nav-list tree";
		li.appendChild(ul);
		
		li.onclick = function (e:MouseEvent):Void
		{
			for (subcategory in subcategories)
			{
				ul.appendChild(createCategory(subcategory));
			}
			
			e.stopPropagation();
			e.preventDefault();
			li.onclick = null;
			
			new JQuery(ul).show(300);
		};
		
		return li;
	}
	
	private static function createList():SelectElement
	{
		var select:SelectElement = Browser.document.createSelectElement();
		select.size = 10;		
		
		select.onchange = function (e):Void
		{
			checkSelectedOptions();
		};
		
		select.ondblclick = function (e):Void
		{
			showPage2();
		};
		
		return select;
	}
	
	private static function checkSelectedOptions():Void
	{
		if (list.selectedOptions.length > 0)
		{
			var option:OptionElement = cast(list.selectedOptions[0], OptionElement);
			updateDescription(selectedCategory, option.label);
		}
	}
	
	private static function updateDescription(category:String, selectedOption:String):Void
	{
		//switch (category) 
		//{
			//case "Haxe":
				//switch (selectedOption) 
				//{
					//["Flash Project", "JavaScript Project", "Neko Project", "PHP Project", "C++ Project", "Java Project", "C# Project"]
					//case "Flash Project":
						//description.textContent = selectedOption;
					//default:
						//
				//}
			//case "OpenFL":
			//case "OpenFL/Samples":
				//
			//default:
				//
		//}
		
		description.textContent = selectedOption;
	}
	
	private static function setListItems(list:SelectElement, items:Array<String>):Void
	{
		for (item in items)
		{
			list.appendChild(createListItem(item));
		}
		
		list.selectedIndex = 0;
		checkSelectedOptions();
	}
	
	private static function createListItem(text:String):OptionElement
	{		
		var option:OptionElement = Browser.document.createOptionElement();
		option.textContent = text;
		option.value = text;
		return option;
	}
	
}