package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.window.toggle-fullscreen";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{	
			BootstrapMenu.getMenu("View").addMenuItem("Toggle Fullscreen", function ():Void
			{
				js.Node.require('nw.gui').Window.get().toggleFullscreen();
			}
			, "F11", 122, false, false, false);

			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}
