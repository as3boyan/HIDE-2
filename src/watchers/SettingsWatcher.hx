package watchers;
import filetree.FileTree;
import haxe.Timer;
import js.Node;
import js.node.Watchr;
import nodejs.webkit.Window;
import projectaccess.ProjectAccess;
import tjson.TJSON;

typedef Settings = {
	var theme:String;
	var locale:String;
	var ignore:Array<String>;
}

/**
 * ...
 * @author 
 */
class SettingsWatcher
{
	public static var settings:Settings;
	public static var watcher:Dynamic;
    
    static var pathToSettings:String;
	
	public static function load():Void 
	{
        pathToSettings = Node.path.join("core", "config", "settings.json");
        
		Watcher.watchFileForUpdates(pathToSettings, parse, 3000);
		
		parse();
		
		Window.get().on("close", function (e) 
		{
			if (watcher != null) 
			{
				watcher.close();
			}
		}
		);
	}
	
	static function parse():Void 
	{
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		var data:String = Node.fs.readFileSync(pathToSettings, options);
		settings = TJSON.parse(data);
		
		ThemeWatcher.load();
		LocaleWatcher.load();
		
		if (ProjectAccess.path != null) 
		{
			FileTree.load();
		}
	}
	
	public static function isItemInIgnoreList(path:String):Bool
	{
		var ignored:Bool = false;
		
		var ereg:EReg;
		
		for (item in SettingsWatcher.settings.ignore) 
		{
			ereg = new EReg(item, "");
			
			if (ereg.match(path)) 
			{
				ignored = true;
				break;
			}
		}
		
		return ignored;
	}
}