package ;
import js.Browser;
import js.html.KeyboardEvent;

/**
 * ...
 * @author AS3Boyan
 */
typedef Hotkey = 
{
	var keyCode:Int;
	var ctrl:Bool;
	var shift:Bool;
	var alt:Bool;
	var onKeyDown:Dynamic;
}
 
@:keepSub @:expose class Hotkeys
{
	private static var hotkeys:Array<Hotkey> = new Array();
	
	public static function prepare():Void
	{
		Browser.window.addEventListener("keydown", function (e:KeyboardEvent)
		{
			for (hotkey in hotkeys)
			{
				if (hotkey.keyCode == e.keyCode && hotkey.ctrl == e.ctrlKey && hotkey.shift == e.shiftKey && hotkey.alt == e.altKey)
				{
					hotkey.onKeyDown();
				}
			}

			trace(e.keyCode);
		}
		);
	}
	
	public static function addHotkey(keyCode:Int, ctrl:Bool, shift:Bool, alt:Bool, onKeyDown:Dynamic):Void
	{
		hotkeys.push({keyCode:keyCode, ctrl:ctrl, shift:shift, alt:alt, onKeyDown:onKeyDown});
	}
}