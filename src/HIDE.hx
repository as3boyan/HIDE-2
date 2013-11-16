package ;
import haxe.ds.StringMap.StringMap;
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