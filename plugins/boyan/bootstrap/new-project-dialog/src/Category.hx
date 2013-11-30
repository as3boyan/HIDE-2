package ;
import haxe.ds.StringMap.StringMap;
import js.html.AnchorElement;
import js.html.LIElement;
import jQuery.JQuery;

/**
 * ...
 * @author AS3Boyan
 */
class Category
{
	public var element:LIElement;
	public var items:Array<Item> = new Array();
	public var subcategories:StringMap<Category> = new StringMap();
	
	public function new(_element:LIElement) 
	{
		element = _element;
	}
	
	public function getCategory(name:String):Category
	{
		if (!subcategories.exists(name))
		{
			NewProjectDialog.createSubcategory(name, this);
		}
		
		return subcategories.get(name);
	}
	
	public function addItem(name:String, ?showCreateDirectoryOption:Bool = true, ?nameLocked:Bool = false):Void
	{
		items.push(new Item(name, showCreateDirectoryOption, nameLocked));
	}
	
	public function getItems():Array<String>
	{
		var itemNames:Array<String> = new Array();
		
		for (item in items)
		{
			itemNames.push(item.name);
		}
		
		return itemNames;
	}
	
	public function select():Void
	{
		NewProjectDialog.updateListItems(this);
	}
	
	public function getItem(name:String):Item
	{
		var currentItem:Item = null;
		
		for (item in items)
		{
			if (name == item.name)
			{
				currentItem = item;
			}
		}
		
		return currentItem;
	}
}