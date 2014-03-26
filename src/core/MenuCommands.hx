package core;
import filetree.FileTree;
import menu.BootstrapMenu;
import nodejs.webkit.Window;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class MenuCommands
{
	public static function add():Void 
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
		
		BootstrapMenu.getMenu("View", 2).addMenuItem("Toggle Fullscreen", 1, function ():Void
		{
			window.toggleFullscreen();
		}
		, "F11");
		
		BootstrapMenu.getMenu("Help").addMenuItem("changelog", 1, TabManager.openFileInNewTab.bind("changes.md"));
		
		BootstrapMenu.getMenu("Developer Tools", 100).addMenuItem("Reload IDE", 1, function ():Void
		{
			HaxeServer.terminate();
			
			window.reloadIgnoringCache();
		}
		, "Ctrl-Shift-R");

		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Compile plugins and reload IDE", 2, function ():Void
		{
			HaxeServer.terminate();
			
			HIDE.compilePlugins(function ():Void
			{
				//Only when all plugins successfully loaded
				window.reloadIgnoringCache();
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
			window.showDevTools();
		}
		);
		
		BootstrapMenu.getMenu("Options").addMenuItem("Open settings", 1, TabManager.openFileInNewTab.bind("settings.json"));
		BootstrapMenu.getMenu("Options").addMenuItem("Open stylesheet", 1, TabManager.openFileInNewTab.bind(SettingsWatcher.settings.theme));
		BootstrapMenu.getMenu("Options").addMenuItem("Open editor configuration file", 1, TabManager.openFileInNewTab.bind("editor.json"));
		BootstrapMenu.getMenu("Options").addMenuItem("Open templates folder", 1, FileTree.load.bind("templates", "templates"));
		BootstrapMenu.getMenu("Options").addMenuItem("Open localization file", 1, TabManager.openFileInNewTab.bind(SettingsWatcher.settings.locale));
		BootstrapMenu.getMenu("Help").addMenuItem("Show code editor key bindings", 2, TabManager.openFileInNewTab.bind("bindings.txt"));
	}
}