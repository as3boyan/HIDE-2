package core;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
class CompilationOutput
{
	public static function load():Void
	{		
		var output:TextAreaElement = Browser.document.createTextAreaElement();
		output.id = "output";
		output.readOnly = true;
		
		Splitpane.components[2].appendChild(output);
	}
	
}