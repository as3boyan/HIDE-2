package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class HaxeCompletionClient
{
	public static function runProcess(process:String, params:Array<String>, onComplete:String->Void, onFailed:Int->String->Void):Void;
}