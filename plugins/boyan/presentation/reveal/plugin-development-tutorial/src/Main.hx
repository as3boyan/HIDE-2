package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.presentation.reveal.plugin-development-tutorial";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			BootstrapMenu.getMenu("Help", 110).addMenuItem("How to develop plugins for HIDE", 1, HIDE.openPageInNewWindow.bind(name, "bin/index.html", {toolbar:false}));
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}