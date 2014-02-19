package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.management.run-project";
	public static var dependencies:Array<String> = ["boyan.bootstrap.project-options"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			BootstrapMenu.getMenu("Project", 80).addMenuItem("Run", 1, function () {}, "F5", 116);
			BootstrapMenu.getMenu("Project").addMenuItem("Build", 1, function () {}, "F8", 119);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}