package ;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.window.zoom";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{	
			var window = Window.get();

			BootstrapMenu.getMenu("View").addMenuItem("Zoom In", 2, function ():Void
			{
				window.zoomLevel += 1;
			}
			, "Ctrl-Shift-+");

			BootstrapMenu.getMenu("View").addMenuItem("Zoom Out", 3, function ():Void
			{
				window.zoomLevel -= 1;
			}
			, "Ctrl-Shift--");

			BootstrapMenu.getMenu("View").addMenuItem("Reset", 4, function ():Void
			{
				window.zoomLevel = 0;
			}
			, "Ctrl-Shift-0");
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}
