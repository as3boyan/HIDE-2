package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class TabManager
{
	public static function openFileInNewTab(path:String):Void;
	public static function getCurrentDocumentPath():String;
	public static function saveActiveFile(?onComplete:Dynamic):Void;
	public static function saveAll(?onComplete:Dynamic):Void;
	public static function getCurrentDocument():CMDoc;
}

extern class CMDoc
{
	public var name:String;
	public var doc:Dynamic;
	public var path:String;
	
	public function new(_name:String, _doc:Dynamic, _path:String);
}