package ;

/**
 * ...
 * @author 
 */
@:native("CodeMirror")
extern class CodeMirrorStatic
{
	@:overload(function (object:Dynamic, event:String, callback_function:Dynamic):Void {})
	static function on(event:String, callback_function:Dynamic):Void;
	static function showHint(cm:CodeMirror, getHints:Dynamic, ?options: { closeCharacters:Dynamic} ):Void;
}