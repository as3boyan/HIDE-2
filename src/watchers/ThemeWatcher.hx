package watchers;
import haxe.Timer;
import jQuery.JQuery;
import js.node.Watchr;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
class ThemeWatcher
{
	static var watcher:Dynamic;
	static var listenerAdded:Bool = false;
	
	public static function load() 
	{		
		if (watcher != null) 
		{
			watcher.close();
		}
		
		Watcher.watchFileForUpdates(SettingsWatcher.settings.theme, function ():Void 
		{
			new JQuery("#theme").attr("href", SettingsWatcher.settings.theme);
		}, 1000);
		
		if (!listenerAdded) 
		{
			Window.get().on("close", function (e) 
			{
				if (watcher != null) 
				{
					watcher.close();
				}
			}
			);
			
			listenerAdded = true;
		}
	}
}