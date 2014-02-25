package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class TabManager
{
	public static var editor:Dynamic;
	public static function openFileInNewTab(path:String):Void;
	public static function getCurrentDocumentPath():String;
	public static function saveActiveFile(?onComplete:Dynamic):Void;
}