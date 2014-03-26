package core;
import js.Node;
//import js.node.Watchr;
//import jQuery.JQuery;
import tjson.TJSON;

typedef Settings = {
	var theme:String;
	var locale:String;
}

/**
 * ...
 * @author 
 */
class SettingsWatcher
{
	public static var settings:Settings;
	
	public static function load():Void 
	{
		//Watchr.watch( {
			//path: "settings.json",
			//listener:
				//function (changeType, filePath, fileCurrentStat, filePreviousStat):Void 
				//{
					//if (changeType == "update") 
					//{
						//parse();
					//}
				//},
			//interval: 3000
		//}
		//);
		
		parse();
	}
	
	static function parse():Void 
	{
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		var data:String = Node.fs.readFileSync("settings.json", options);
		
		settings = TJSON.parse(data);
		
		ThemeWatcher.load();
		LocaleWatcher.load();
	}
}