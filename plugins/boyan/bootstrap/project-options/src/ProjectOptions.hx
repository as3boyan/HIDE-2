package ;
import js.Browser;
import js.html.DivElement;
import js.html.ParagraphElement;
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
		
		Splitpane.components[3].appendChild(page);
	}
	
	public static function getProjectArguments():String
	{
		return textarea.value;
	}
}