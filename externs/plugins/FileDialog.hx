package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class FileDialog
{
	public static function openFile(_onClick:Dynamic):Void;
	public static function saveFile(_onClick:Dynamic, ?_name:String):Void;
	public static function openFolder(_onClick:Dynamic):Void;
}