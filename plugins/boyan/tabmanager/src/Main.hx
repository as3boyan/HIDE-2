package ;
import js.Browser;
import js.html.Element;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.tabmanager";
	public static var dependencies:Array<String> = ["boyan.split-pane"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		//Load CSS for tab styling
		HIDE.loadCSS(name, "bin/includes/css/tabs.css");
		
		//Will wait for dependent plugins
		HIDE.waitForDependentPluginsToBeLoaded(dependencies, load);
	}
	
	private static function load():Void
	{
		TabManager.init();
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.plugins.push(name);
	}
}