package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.file-tree";
	public static var dependencies:Array<String> = ["boyan.bootstrap.script"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		//Will wait for boyan.bootstrap plugin
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			//Will wait for one of splitpane plugins
			HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.jquery.layout", "boyan.jquery.split-pane"], load, true);
		}
		);
		
		HIDE.loadCSS(name, ["bin/includes/css/file-tree.css"]);
	}
	
	private static function load():Void
	{
		FileTree.init();
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}