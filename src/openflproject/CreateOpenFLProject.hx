package openflproject;
import core.ProcessHelper;

/**
 * ...
 * @author AS3Boyan
 */
class CreateOpenFLProject
{
	public static function createOpenFLProject(params:Array<String>, path:String, ?onComplete:Dynamic):Void
	{	
		ProcessHelper.runProcess("haxelib", ["run", "lime-tools", "create"].concat(params), path, onComplete);
	}
	
}