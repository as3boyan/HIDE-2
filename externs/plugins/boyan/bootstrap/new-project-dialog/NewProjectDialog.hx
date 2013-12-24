package ;
import haxe.ds.StringMap;
import js.html.LIElement;

/**
 * ...
 * @author AS3Boyan
 */
extern class NewProjectDialog
{
	public static function getCategory(name:String):Category;
}

extern class Category
{
	public var element:LIElement;
	public var items:Array<Item>;
	public var subcategories:StringMap<Category>;
	
	public function new(_element:LIElement);
	public function getCategory(name:String):Category;
	public function addItem(name:String, ?createProjectFunction:Dynamic, ?showCreateDirectoryOption:Bool = true, ?nameLocked:Bool = false):Void;
	public function getItems():Array<String>;
	public function select():Void;
	public function getItem(name:String):Item;
}

extern class Item
{
	public var name:String;
	public var showCreateDirectoryOption:Bool;
	public var nameLocked:Bool;
	public var createProjectFunction:Dynamic;

	public function new(_name:String, ?_createProjectFunction:Dynamic, ?_showCreateDirectoryOption:Bool = true, ?_nameLocked:Bool = false);
}