package watchers;
import haxe.ds.StringMap.StringMap;
import js.Browser;
import js.html.Element;
import js.Node;
import nodejs.webkit.Window;
//import jQuery.JQuery;
import js.node.Watchr;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
class LocaleWatcher
{
	static var localeData:Dynamic;
	static var watcher:Dynamic;
	static var listenerAdded:Bool = false;
	
	public static function load():Void 
	{
		if (watcher != null) 
		{
			watcher.close();
		}
		
		parse();
		
		Watcher.watchFileForUpdates(SettingsWatcher.settings.locale, function ():Void 
		{
			parse();
			processHtmlElements();
		}, 1000);
		
		processHtmlElements();
		
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
	
	static function parse():Void 
	{
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		var data:String = Node.fs.readFileSync(SettingsWatcher.settings.locale, options);
		
		localeData = TJSON.parse(data);
	}
	
	public static function getStringSync(name:String):String
	{
		var value:String = name;
		
		if (Reflect.hasField(localeData, name)) 
		{
			value = Reflect.field(localeData, name);
		}
		else 
		{
			Reflect.setField(localeData, name, name);
			var data:String = TJSON.encode(localeData, 'fancy');
			Node.fs.writeFileSync(SettingsWatcher.settings.locale, data, NodeC.UTF8);
		}
		
		return value;
	}
	
	static function processHtmlElements()
	{
		var element:Element;
		var value:String;
		
		for (node in Browser.document.getElementsByTagName("*")) 
		{
			element = cast(node, Element);
			
			value = element.getAttribute("localeString");
			
			if (value != null) 
			{
				element.textContent = getStringSync(value);
			}
		}
	}
}