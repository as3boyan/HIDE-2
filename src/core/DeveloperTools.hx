package core;
import menu.BootstrapMenu;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
class DeveloperTools
{
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function addToMenu():Void
	{
		BootstrapMenu.getMenu("Developer Tools", 100).addMenuItem("Reload IDE", 1, function ():Void
		{
			//HaxeServer.terminate();
			
			Window.get().reloadIgnoringCache();
		}
		, "Ctrl-Shift-R");

		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Compile plugins and reload IDE", 2, function ():Void
		{
			//HaxeServer.terminate();
			
			HIDE.compilePlugins(function ():Void
			{
				//Only when all plugins successfully loaded
				Window.get().reloadIgnoringCache();
			}
			//On plugin compilation failed
			, function (data:String):Void
			{
				
			}
			);
			
		}
		, "Shift-F5");
		
		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Console", 3, function ():Void
		{
			var window = Window.get();
			window.showDevTools();
		}
		);
	}
	
}
