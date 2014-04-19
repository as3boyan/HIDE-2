package projectaccess;
import bootstrap.ButtonManager;
import bootstrap.InputGroupButton;
import core.FileDialog;
import haxe.ds.ArraySort;
import js.Browser;
import js.html.DivElement;
import js.html.OptionElement;
import js.html.ParagraphElement;
import js.html.SelectElement;
import js.html.TextAreaElement;
import js.Node;
import projectaccess.Project.TargetData;
import tabmanager.TabManager;
import watchers.LocaleWatcher;

/**
 * ...
 * @author AS3Boyan
 */
class ProjectOptions
{	
	public static var page:DivElement;
	
	//static var textarea:TextAreaElement;
	static var projectTargetList:SelectElement;
	static var projectTargetText:ParagraphElement;
	//static var projectOptionsText:ParagraphElement;
	static var openFLTargetList:SelectElement;
	static var openFLTargetText:ParagraphElement;
	static var openFLTargets:Array<String>;
	static var buildActionTextArea:TextAreaElement;
	static var actionTextArea:TextAreaElement;
	static var runActionList:SelectElement;
	static var runActionTextAreaDescription:ParagraphElement;
	static var buildActionDescription:ParagraphElement;
	static var runActionDescription:ParagraphElement;
	static private var pathToHxmlDescription;
	static private var inputGroupButton:bootstrap.InputGroupButton;
	static private var input;
	
	public static function create():Void
	{
		page = Browser.document.createDivElement();
		
		//projectOptionsText = Browser.document.createParagraphElement();
		//projectOptionsText.id = "project-options-text";
		//projectOptionsText.className = "custom-font-size";
		//projectOptionsText.textContent = LocaleWatcher.getStringSync("Project arguments:");
		//projectOptionsText.setAttribute("localeString", "Project arguments:");
		//
		//textarea = Browser.document.createTextAreaElement();
		//textarea.id = "project-options-textarea";
		//textarea.className = "custom-font-size";
		//textarea.onchange = function (e)
		//{
			//ProjectAccess.currentProject.args = textarea.value.split("\n");
			//ProjectAccess.save();
		//};
		
		pathToHxmlDescription = Browser.document.createParagraphElement();
		pathToHxmlDescription.textContent = LocaleWatcher.getStringSync("Path to Hxml:");
		pathToHxmlDescription.setAttribute("localeString", "Path to Hxml:");
		pathToHxmlDescription.className = "custom-font-size";
		
		inputGroupButton = new InputGroupButton("Browse...");
		
		input = inputGroupButton.getInput();
		
		var browseButton = inputGroupButton.getButton();
		
		browseButton.onclick = function (e):Void 
		{
			FileDialog.openFile(function (path:String):Void 
			{
				input.value = path;
				
				var project = ProjectAccess.currentProject;
				project.targetData[project.target].pathToHxml = input.value;
			}
			, ".hxml");
		};
		
		var editButton = ButtonManager.createButton("Edit", false, true);
		editButton.onclick = function (e):Void 
		{
			TabManager.openFileInNewTab(Node.path.resolve(ProjectAccess.path, input.value));
		};
		
		inputGroupButton.getSpan().appendChild(editButton);
		
		projectTargetText = Browser.document.createParagraphElement();
		projectTargetText.textContent = LocaleWatcher.getStringSync("Project target:");
		projectTargetText.setAttribute("localeString", "Project target:");
		projectTargetText.className = "custom-font-size";
		page.appendChild(projectTargetText);
		
		projectTargetList = Browser.document.createSelectElement();
		projectTargetList.id = "project-options-project-target";
		projectTargetList.className = "custom-font-size";
		projectTargetList.style.width = "100%";
		
		openFLTargetList = Browser.document.createSelectElement();
		openFLTargetList.id = "project-options-openfl-target";
		openFLTargetList.className = "custom-font-size";
		openFLTargetList.style.width = "100%";
		
		openFLTargetText = Browser.document.createParagraphElement();
		openFLTargetText.innerText = LocaleWatcher.getStringSync("OpenFL target:");
		openFLTargetText.setAttribute("localeString", "OpenFL target:");
		openFLTargetText.className = "custom-font-size";
		
		for (target in ["Flash", "JavaScript", "Neko", "OpenFL", "PHP", "C++", "Java", "C#"])
		{
			projectTargetList.appendChild(createListItem(target));
		}
			
		//projectTargetList.disabled = true;
		projectTargetList.onchange = function (e):Void 
		{
			var project = ProjectAccess.currentProject;
			
			switch (projectTargetList.value) 
			{
				case "Flash":
					project.target = Project.FLASH;
				case "JavaScript":
					project.target = Project.JAVASCRIPT;
				case "Neko":
					project.target = Project.NEKO;
				case "OpenFL":
					project.target = Project.OPENFL;
				case "PHP":
					project.target = Project.PHP;
				case "C++":
					project.target = Project.CPP;
				case "Java":
					project.target = Project.JAVA;
				case "C#":
					project.target = Project.CSHARP;
				default:
					throw "Unknown target";
			}
			
			//switch (project.type) 
			//{
				//case Project.HAXE:
					//var targetData:TargetData = project.targetData[project.target];
					//
					//runActionType = targetData.runActionType;
					//runActionText = targetData.runActionText;
				//default:
					//runActionType = project.runActionType;
					//runActionText = project.runActionText;
			//}
			
			updateProjectOptions();
		};
		
		openFLTargets = ["flash", "html5", "neko", "android", "blackberry", "emscripten", "webos", "tizen", "ios", "windows", "mac", "linux"];
		
		for (target in openFLTargets)
		{
			openFLTargetList.appendChild(createListItem(target));
		}
		
		openFLTargetList.onchange = function (_)
		{
			ProjectAccess.currentProject.openFLTarget = openFLTargets[openFLTargetList.selectedIndex];
			
			var buildParams:Array<String> = ["haxelib", "run", "openfl", "build", HIDE.surroundWithQuotes(js.Node.path.join(ProjectAccess.path, "project.xml")), ProjectAccess.currentProject.openFLTarget];
			
			switch (ProjectAccess.currentProject.openFLTarget) 
			{
				case "flash", "html5", "neko":
					buildParams = buildParams.concat(["--connect", "5000"]);
				default:
					
			}
			
			ProjectAccess.currentProject.buildActionCommand = buildParams.join(" ");
			
			trace(buildParams);
			
			ProjectAccess.currentProject.runActionType = Project.COMMAND;
			ProjectAccess.currentProject.runActionText = ["haxelib", "run", "openfl", "run", HIDE.surroundWithQuotes(js.Node.path.join(ProjectAccess.path, "project.xml")), ProjectAccess.currentProject.openFLTarget].join(" ");
			
			updateProjectOptions();
		};
		
		runActionDescription = Browser.document.createParagraphElement();
		runActionDescription.className = "custom-font-size";
		runActionDescription.textContent = LocaleWatcher.getStringSync("Run action:");
		runActionDescription.setAttribute("localeString", "Run action:");
		
		runActionTextAreaDescription = Browser.document.createParagraphElement();
		runActionTextAreaDescription.textContent = LocaleWatcher.getStringSync("URL:");
		runActionTextAreaDescription.setAttribute("localeString", "URL:");
		runActionTextAreaDescription.className = "custom-font-size";
		
		var actions:Array<String> = ["Open URL", "Open File", "Run command"];
		
		runActionList = Browser.document.createSelectElement();
		runActionList.style.width = "100%";
		
		runActionList.onchange = update;
		
		for (action in actions)
		{
			runActionList.appendChild(createListItem(action));
		}
		
		actionTextArea = Browser.document.createTextAreaElement();
		actionTextArea.id = "project-options-action-textarea";
		actionTextArea.className = "custom-font-size";
		actionTextArea.onchange = function (e)
		{			
			ProjectAccess.currentProject.runActionText = actionTextArea.value;
			update(null);
		};
		
		buildActionDescription = Browser.document.createParagraphElement();
		buildActionDescription.className = "custom-font-size";
		buildActionDescription.textContent = LocaleWatcher.getStringSync("Build command:");
		buildActionDescription.setAttribute("localeString", "Build command:");
		
		buildActionTextArea = Browser.document.createTextAreaElement();
		buildActionTextArea.id = "project-options-build-action-textarea";
		buildActionTextArea.className = "custom-font-size";
		buildActionTextArea.onchange = function (e)
		{
			ProjectAccess.currentProject.buildActionCommand = buildActionTextArea.value;
			ProjectAccess.save();
		};
		
		page.appendChild(projectTargetList);
		page.appendChild(buildActionDescription);
		page.appendChild(buildActionTextArea);
		page.appendChild(pathToHxmlDescription);
		page.appendChild(inputGroupButton.getElement());
		//page.appendChild(projectOptionsText);
		//page.appendChild(textarea);
		page.appendChild(openFLTargetText);
		page.appendChild(openFLTargetList);
		page.appendChild(runActionDescription);
		page.appendChild(runActionList);
		page.appendChild(runActionTextAreaDescription);
		page.appendChild(actionTextArea);
		
		//new jQuery.JQuery("#options").append(page);
	}
	
	//public static function getProjectArguments():String
	//{
		//return textarea.value;
	//}
	
	private static function update(_):Void
	{
		if (projectTargetList.selectedIndex == 3)
		{
			openFLTargetList.style.display = "";
			openFLTargetText.style.display = "";
			//textarea.style.display = "none";
			//projectOptionsText.style.display = "none";
		}
		else
		{
			openFLTargetList.style.display = "none";
			openFLTargetText.style.display = "none";
			//textarea.style.display = "";
			//projectOptionsText.style.display = "";
		}
		
		if (ProjectAccess.currentProject.type == Project.HXML) 
		{
			openFLTargetList.style.display = "none";
			openFLTargetText.style.display = "none";
			//textarea.style.display = "none";
			//projectOptionsText.style.display = "none";
			
			buildActionTextArea.style.display = "none";
			buildActionDescription.style.display = "none";
			//runActionTextAreaDescription.style.display = "none";
			//runActionList.style.display = "none";
			//runActionDescription.style.display = "none";
			projectTargetList.style.display = "none";
			projectTargetText.style.display = "none";
			//actionTextArea.style.display = "none";
		}
		else 
		{
			buildActionTextArea.style.display = "";
			buildActionDescription.style.display = "";
			runActionTextAreaDescription.style.display = "";
			runActionList.style.display = "";
			runActionDescription.style.display = "";
			projectTargetList.style.display = "";
			projectTargetText.style.display = "";
			actionTextArea.style.display = "";
		}
		
		var project = ProjectAccess.currentProject;
		
		switch (runActionList.selectedIndex) 
		{
			case 0:
				runActionTextAreaDescription.innerText = LocaleWatcher.getStringSync("URL: ");
				project.runActionType = Project.URL;
			case 1:
				runActionTextAreaDescription.innerText = LocaleWatcher.getStringSync("Path: ");
				project.runActionType = Project.FILE;
			case 2:
				runActionTextAreaDescription.innerText = LocaleWatcher.getStringSync("Command: ");
				project.runActionType = Project.COMMAND;
				
			default:
				
		}
		
		ProjectAccess.save();
	}
	
	public static function updateProjectOptions():Void
	{		
		var project = ProjectAccess.currentProject;
		
		var runActionType;
		var runActionText;
		
		switch (project.type) 
		{
			case Project.HAXE:
				var targetData:TargetData = project.targetData[project.target];
				
				runActionType = targetData.runActionType;
				runActionText = targetData.runActionText;
			default:
				runActionType = project.runActionType;
				runActionText = project.runActionText;
		}
		
		if (project.type == Project.OPENFL)
		{
			projectTargetList.selectedIndex = 3;
			
			var i:Int = Lambda.indexOf(openFLTargets, project.openFLTarget);
			if (i != -1)
			{
				openFLTargetList.selectedIndex = i;
			}
			else 
			{
				openFLTargetList.selectedIndex = 0;
			}
		}
		else 
		{			
			switch (project.target) 
			{
				case Project.FLASH:
					projectTargetList.selectedIndex = 0;
				case Project.JAVASCRIPT:
					projectTargetList.selectedIndex = 1;
				case Project.NEKO:
					projectTargetList.selectedIndex = 2;
				case Project.PHP:
					projectTargetList.selectedIndex = 4;
				case Project.CPP:
					projectTargetList.selectedIndex = 5;
				case Project.JAVA:
					projectTargetList.selectedIndex = 6;
				case Project.CSHARP:
					projectTargetList.selectedIndex = 7;
				default:
					
			}
			
			//textarea.value = ProjectAccess.currentProject.args.join("\n");
		}
		
		buildActionTextArea.value = project.buildActionCommand;
		
		switch (runActionType) 
		{
			case Project.URL:
				runActionList.selectedIndex = 0;
			case Project.FILE:
				runActionList.selectedIndex = 1;
			case Project.COMMAND:
				runActionList.selectedIndex = 2;
			default:
				
		}
		
		if (runActionText == null) 
		{
			runActionText = "";
		}
		actionTextArea.value = runActionText;
		
		update(null);
	}
	
	private static function createListItem(text:String):OptionElement
	{		
		var option:OptionElement = Browser.document.createOptionElement();
		option.textContent = LocaleWatcher.getStringSync(text);
		option.value = text;
		return option;
	}
}