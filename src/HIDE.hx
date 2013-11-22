package ;
import haxe.ds.StringMap.StringMap;
import haxe.Timer;
import js.Browser;
import js.html.KeyboardEvent;
import js.html.LinkElement;
import js.html.ScriptElement;

/**
 * ...
 * @author AS3Boyan
 */
 
@:keepSub @:expose class HIDE
{	
	public static var plugins:Array<String> = new Array();
	public static var pathToPlugins:StringMap<String> = new StringMap();
	public static var pathToInactivePlugins:Array<String> = new Array();
	
	//Loads JS scripts in specified order and calls onLoad function when last item of urls array was loaded
	public static function loadJS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void
	{
		if (name != null)
		{
			for (i in 0...urls.length)
			{
				urls[i] = js.Node.path.join(pathToPlugins.get(name), urls[i]);
			}
		}

		loadJSAsync(urls, onLoad);
	}
	
	//Asynchronously loads multiple CSS scripts
	public static function loadCSS(name:String, urls:Array<String>):Void
	{
		for (url in urls)
		{
			if (name != null)
			{
				url = js.Node.path.join(pathToPlugins.get(name), url);
			}
			
			var link:LinkElement = Browser.document.createLinkElement();
			link.href = url;
			link.type = "text/css";
			link.rel = "stylesheet";
			Browser.document.head.appendChild(link);
		}
	}
	
	public static function waitForDependentPluginsToBeLoaded(plugins:Array<String>, onLoaded:Void->Void):Void
	{
		var time:Int = 0;
		
		var timer:Timer = new Timer(100);
		timer.run = function ():Void
		{
			var pluginsLoaded:Bool = Lambda.foreach(plugins, function (plugin:String):Bool
			{
				return Lambda.has(HIDE.plugins, plugin);
			}
			);
			
			if (pluginsLoaded)
			{
				onLoaded();
				timer.stop();
			}
			else 
			{
				//Check if loading dependent plugins takes too long
				if (time < 3000)
				{
					time += 100;
				}
				else 
				{
					trace("can't load plugin, required plugins is not found");
					timer.stop();
				}
			}
		};
	}
	
	//Private function which loads JS scripts in strict order
	private static function loadJSAsync(urls:Array<String>, ?onLoad:Dynamic):Void
	{
		var script:ScriptElement = Browser.document.createScriptElement();
		script.src = urls.splice(0, 1)[0];
		script.onload = function (e)
		{
			trace(script.src + " loaded");
			
			if (urls.length > 0)
			{
				loadJSAsync(urls, onLoad);
			}
			else if (onLoad != null)
			{
				onLoad();
			}
		};
		
		Browser.document.head.appendChild(script);
	}
	
	public static function registerHotkey(hotkey:String, functionName:String):Void
	{
		
	}
	
	public static function registerHotkeyByKeyCode(code:Int, functionName:String):Void
	{
		Browser.window.addEventListener("keyup", function (e:KeyboardEvent)
		{
			if (e.keyCode == code)
			{
				//new JQuery().triggerHandler(functionName);
			}
			
			//trace(e.keyCode);
		}
		);
	}
	
}