package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.split-pane";
	public static var dependencies:Array<String> = ["boyan.jquery"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		//Will wait for boyan.jquery plugin
		HIDE.waitForDependentPluginsToBeLoaded(dependencies, load);
	}
	
	private static function load():Void
	{
		trace("Ready to use split-pane");
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.plugins.push(name);
	}
	
}