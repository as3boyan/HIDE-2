package core;
import jQuery.JQuery;
import js.Node;
//import js.node.Watchr;

/**
 * ...
 * @author AS3Boyan
 */
class ThemeWatcher
{
	static var watcher:Dynamic;
	
	public static function load():Void 
	{		
		if (watcher != null) 
		{
			watcher.close();
		}
		
		//watcher = Watchr.watch( {
			//path: SettingsWatcher.settings.theme,
			//listener:
				//function (changeType, filePath, fileCurrentStat, filePreviousStat):Void 
				//{
					//if (changeType == "update") 
					//{
						new JQuery("#theme").attr("href", SettingsWatcher.settings.theme);
					//}
				//},
			//interval: 1500
		//}
		//);
	}
}