package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.project-options";
	public static var dependencies:Array<String> = ["boyan.bootstrap.script", "boyan.jquery.layout"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			ProjectOptions.create();
			
			HIDE.notifyLoadingComplete(name);
		}
		);
		
		HIDE.loadCSS(name, ["bin/includes/css/project-options.css"]);
	}
}