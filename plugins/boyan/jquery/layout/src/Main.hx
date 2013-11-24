package ;
import haxe.Timer;
import js.Browser;

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
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, load);
		
		HIDE.loadCSS(name, ["bin/includes/css/panel.css"]);
		
		//Notify HIDE to ignore this plugin
		//HIDE.conflictingPlugins.push("boyan.jquery.split-pane");
	}
	
	private static function load():Void
	{
		HIDE.loadJS(name, ["bin/includes/js/jquery.layout-latest.min.js"], function ():Void
		{				
			Splitpane.createSplitPane();			
			
			//Waits for all CSS
			HIDE.loadCSS(name, ["bin/includes/css/layout-default-latest.css"], function ():Void
			{
				Splitpane.activateSplitpane();
				//Splitpane.activateStatePreserving();
			}
			);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves
			HIDE.notifyLoadingComplete(name);
		});
	}
	
}