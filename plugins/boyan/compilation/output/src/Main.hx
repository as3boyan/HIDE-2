package ;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.compilation.output";
	public static var dependencies:Array<String> = ["boyan.jquery.layout", "boyan.jquery.split-pane"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.loadCSS(name, ["bin/includes/css/output.css"]);
		
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			//<textarea id="output"></textarea>
			
			var output:TextAreaElement = Browser.document.createTextAreaElement();
			output.id = "output";
			output.readOnly = true;
			
			Splitpane.components[2].appendChild(output);
		}
		, true);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}