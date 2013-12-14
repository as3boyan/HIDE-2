package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.themes.topcoat";
	public static var dependencies:Array<String> = ["boyan.bootstrap.script"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{		
		HIDE.waitForDependentPluginsToBeLoaded(name,dependencies, function ():Void 
		{
			HIDE.loadCSS(name,["bin/css/topcoat-desktop-dark.min.css"],function ():Void
			{
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			});
		});
	}
	
}