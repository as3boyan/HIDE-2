package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.jquery.layout";
	public static var dependencies:Array<String> = ["boyan.jquery.ui"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{			
			HIDE.loadJS(name, ["bin/includes/js/jquery.layout-latest.min.js"], function ():Void
			{
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin(like Bootstrap) can start load themselves
				HIDE.plugins.push(name);
			});
		}
		);
	}
	
}