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
class ProjectOptions
{	
	private static var textarea:TextAreaElement;
	
	public static function create():Void
	{
		var page:DivElement = Browser.document.createDivElement();
		
		var projectOptionsText:ParagraphElement = Browser.document.createParagraphElement();
		projectOptionsText.id = "project-options-text";
		projectOptionsText.innerText = "Project arguments:";
		
		textarea = Browser.document.createTextAreaElement();
		textarea.id = "project-options-textarea";
		textarea.onchange = function (e)
		{
			ProjectAccess.currentProject.args = textarea.value.split("\n");
		};
		
		var projectTargetText:ParagraphElement = Browser.document.createParagraphElement();
		projectTargetText.innerText = "Project target:";
		page.appendChild(projectTargetText);
		
		var projectTargetList:SelectElement = Browser.document.createSelectElement();
		projectTargetList.id = "project-options-project-target";
		
		var openFLTargetList:SelectElement = Browser.document.createSelectElement();
		openFLTargetList.id = "project-options-openfl-target";
		
		var openFLTargetText:ParagraphElement = Browser.document.createParagraphElement();
		openFLTargetText.innerText = "OpenFL target:";
		
		for (target in ["Flash", "JavaScript", "Neko", "OpenFL", "PHP", "C++", "Java", "C#"])
		{
			projectTargetList.appendChild(createListItem(target));
		}
		
		projectTargetList.onchange = function (e)
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
		page.appendChild(projectTargetList);
		page.appendChild(Browser.document.createBRElement());
		page.appendChild(Browser.document.createBRElement());
		page.appendChild(projectOptionsText);
		page.appendChild(textarea);
		page.appendChild(Browser.document.createBRElement());
		page.appendChild(openFLTargetText);
		
		for (target in ["flash", "html5", "neko", "android", "blackberry", "emscripten", "webos", "tizen", "ios", "windows", "mac", "linux"])
		{
			openFLTargetList.appendChild(createListItem(target));
		}
		page.appendChild(openFLTargetList);
		
		Splitpane.components[3].appendChild(page);
	}
	
	public static function getProjectArguments():String
	{
		return textarea.value;
	}
	
	private static function createListItem(text:String):OptionElement
	{		
		var option:OptionElement = Browser.document.createOptionElement();
		option.textContent = text;
		option.value = text;
		return option;
	}
}