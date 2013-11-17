package ;

/**
 * ...
 * @author AS3Boyan
 */

extern class BootstrapMenu
{
	public static function createMenuBar():Void;
	public static function getMenu(name:String):Menu;
}

@:native("ui.menu.basic.Menu") extern class Menu
{
	public function addMenuItem(_text:String, _onClickFunction:Void->Void, ?_hotkey:String):Void;
	public function addSeparator():Void;
	public function addToDocument():Void;
	public function setDisabled(menuItemNames:Array<String>):Void;
	public function setMenuEnabled(enabled:Bool):Void;
}