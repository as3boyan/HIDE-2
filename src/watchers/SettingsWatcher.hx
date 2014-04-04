package watchers;
import haxe.Timer;
import js.Node;
import js.node.Watchr;
import nodejs.webkit.Window;
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
	public static var watcher:Dynamic;
	
	public static function load():Void 
	{
		Watcher.watchFileForUpdates(Node.path.join("config","settings.json"), parse, 3000);
		
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
		
		var data:String = Node.fs.readFileSync(Node.path.join("config","settings.json"), options);
		settings = TJSON.parse(data);
		
		ThemeWatcher.load();
		LocaleWatcher.load();
	}
}