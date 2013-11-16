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
	
	public static function loadJS(url:String, ?onLoad:Dynamic):Void
	{
		var script:ScriptElement = Browser.document.createScriptElement();
		script.src = url;
		script.onload = function (e)
		{
			trace(url + " loaded");
			
			if (onLoad != null)
			{
				onLoad();
			}
		};
		Browser.document.head.appendChild(script);
	}
	
	public static function loadCSS(url:String):Void
	{
		var link:LinkElement = Browser.document.createLinkElement();
		link.href = url;
		link.type = "text/css";
		link.rel = "stylesheet";
		Browser.document.head.appendChild(link);
	}
	
	public static function waitForDependentPluginsToBeLoaded(plugins:Array<String>, onLoaded:Dynamic):Void
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