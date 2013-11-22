package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.filetree";
	public static var dependencies:Array<String> = ["boyan.bootstrap.script", "boyan.jquery.split-pane"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		//Will wait for boyan.bootstrap plugin
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, load);
	}
	
	private static function load():Void
	{
		FileTree.init();
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.plugins.push(name);
	}
	
}