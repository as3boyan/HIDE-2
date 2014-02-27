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
		
		var p:ParagraphElement = Browser.document.createParagraphElement();
		p.id = "project-options-text";
		p.innerText = "Project arguments:";
		page.appendChild(p);
		
		textarea = Browser.document.createTextAreaElement();
		textarea.id = "project-options-textarea";
		textarea.onchange = function (e)
		{
			ProjectAccess.currentProject.args = textarea.value.split("\n");
		};
		page.appendChild(textarea);
		
		var list:SelectElement = Browser.document.createSelectElement();
		
		for (target in ["Flash", "JavaScript", "Neko", "PHP", "C++", "Java", "C#"])
		{
			list.appendChild(createListItem(target));
		}
		page.appendChild(list);
		
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