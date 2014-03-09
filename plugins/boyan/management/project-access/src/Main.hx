package ;
import js.Browser;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.management.project-access";
	public static var dependencies:Array<String> = [];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{			
			ProjectAccess.registerSaveOnCloseListener();
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}