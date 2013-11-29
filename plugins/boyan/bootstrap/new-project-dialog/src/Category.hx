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
	
	public function addItem(name:String):Void
	{
		items.push(new Item(name));
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
}