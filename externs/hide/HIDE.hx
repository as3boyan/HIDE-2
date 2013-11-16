package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class HIDE
{
	public static function loadJS(url:String, ?onLoad:Dynamic):Void;
	public static function loadCSS(url:String):Void;
	public static function registerHotkey(hotkey:String, functionName:String):Void;
	public static function registerHotkeyByKeyCode(code:Int, functionName:String):Void;
}