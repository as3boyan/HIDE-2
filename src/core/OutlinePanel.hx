package core;
import jQuery.JQuery;

/**
 * ...
 * @author AS3Boyan
 */

typedef TreeItem = {
	var label:String;
	@:optional var items:Array<TreeItem>;
	@:optional var expand:Bool;
}
 
class OutlinePanel
{
	static var source:Array<TreeItem> = [];
	
	public static function update():Void
	{
		untyped new JQuery("#jqxTree").jqxTree( { source: source } );
	}
	
	public static function add(label:String):Void
	{
		source.push( { label: label } );
	}
}