package ;

/**
 * ...
 * @author AS3Boyan
 */

extern class BootstrapMenu
{
	public static function createMenuBar():Void;
	public static function getMenu(name:String, ?position:Int):Menu;
}

@:native("ui.menu.basic.Submenu") extern class Submenu
{
	public function addMenuItem(_text:String, _position:Int, _onClickFunction:Dynamic, ?_hotkey:String):Void;
}

@:native("ui.menu.basic.Menu") extern class Menu
{
	public function addMenuItem(_text:String, _position:Int, _onClickFunction:Dynamic, ?_hotkey:String):Void;
	public function addSeparator():Void;
	public function addToDocument():Void;
	public function removeFromDocument():Void;
	public function setDisabled(menuItemNames:Array<String>):Void;
	public function setMenuEnabled(enabled:Bool):Void;
	public function getSubmenu(name:String):Submenu;
}