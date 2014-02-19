package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class HaxeClient
{	
	public static function buildProject(process:String, params:Array<String>, ?onComplete:Dynamic):Void;
	public static function buildOpenFLProject(params:Array<String>, ?onComplete:Dynamic):Void;
}