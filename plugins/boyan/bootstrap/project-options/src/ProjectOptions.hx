package ;
import js.Browser;
import js.html.DivElement;
import js.html.OptionElement;
import js.html.ParagraphElement;
import js.html.SelectElement;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class ProjectOptions
{	
	private static var textarea:TextAreaElement;
	private static var projectTargetList:SelectElement;
	private static var projectTargetText:ParagraphElement;
	private static var projectOptionsText:ParagraphElement;
	private static var openFLTargetList:SelectElement;
	private static var openFLTargetText:ParagraphElement;
	
	public static function create():Void
	{
		var page:DivElement = Browser.document.createDivElement();
		
		projectOptionsText = Browser.document.createParagraphElement();
		projectOptionsText.id = "project-options-text";
		projectOptionsText.innerText = "Project arguments:";
		
		textarea = Browser.document.createTextAreaElement();
		textarea.id = "project-options-textarea";
		textarea.onchange = function (e)
		{
			ProjectAccess.currentProject.args = textarea.value.split("\n");
		};
		
		projectTargetText = Browser.document.createParagraphElement();
		projectTargetText.innerText = "Project target:";
		page.appendChild(projectTargetText);
		
		projectTargetList = Browser.document.createSelectElement();
		projectTargetList.id = "project-options-project-target";
		
		openFLTargetList = Browser.document.createSelectElement();
		openFLTargetList.id = "project-options-openfl-target";
		
		openFLTargetText = Browser.document.createParagraphElement();
		openFLTargetText.innerText = "OpenFL target:";
		
		for (target in ["Flash", "JavaScript", "Neko", "OpenFL", "PHP", "C++", "Java", "C#"])
		{
			projectTargetList.appendChild(createListItem(target));
		}
		
		projectTargetList.disabled = true;
		projectTargetList.onchange = update;
		
		page.appendChild(projectTargetList);
		page.appendChild(Browser.document.createBRElement());
		page.appendChild(Browser.document.createBRElement());
		page.appendChild(projectOptionsText);
		page.appendChild(textarea);
		page.appendChild(Browser.document.createBRElement());
		page.appendChild(openFLTargetText);
		
		var openFLTargets:Array<String> = ["flash", "html5", "neko", "android", "blackberry", "emscripten", "webos", "tizen", "ios", "windows", "mac", "linux"];
		
		for (target in openFLTargets)
		{
			openFLTargetList.appendChild(createListItem(target));
		}
		
		openFLTargetList.onchange = function (_)
		{
			ProjectAccess.currentProject.openFLTarget = openFLTargets[openFLTargetList.selectedIndex];
		};
		
		page.appendChild(openFLTargetList);
		
		Splitpane.components[3].appendChild(page);
	}
	
	public static function getProjectArguments():String
	{
		return textarea.value;
	}
	
	private static function update(_):Void
	{
		if (projectTargetList.selectedIndex == 3)
		{
			openFLTargetList.style.display = "";
			openFLTargetText.style.display = "";
			textarea.style.display = "none";
			projectOptionsText.style.display = "none";
		}
		else 
		{
			openFLTargetList.style.display = "none";
			openFLTargetText.style.display = "none";
			textarea.style.display = "";
			projectOptionsText.style.display = "";
		}
	}
	
	public static function updateProjectOptions():Void
	{		
		if (ProjectAccess.currentProject.type == Project.OPENFL)
		{
			projectTargetList.selectedIndex = 3;
		}
		else 
		{
			switch (ProjectAccess.currentProject.target) 
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
		}
		
		update(null);
	}
	
	private static function createListItem(text:String):OptionElement
	{		
		var option:OptionElement = Browser.document.createOptionElement();
		option.textContent = text;
		option.value = text;
		return option;
	}
}