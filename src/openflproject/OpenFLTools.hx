package openflproject;
import core.ProcessHelper;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class OpenFLTools
{	
	public static function getParams(path:String, target:String, onLoaded:String->Void):Void
	{
		ProcessHelper.runProcess("haxelib", ["run", "openfl", "display", target], path, function (stdout:String, stderr:String):Void 
		{
			//onComplete
			
			if (onLoaded != null)
			{
				onLoaded(stdout);
			}
			
			printStderr(stderr);
			
		}, function (code:Int, stdout:String, stderr:String):Void 
		{
			//onFailed
			
			Alertify.error("OpenFL tools error. Please update OpenFL.(haxelib upgrade)");
			Alertify.error("OpenFL tools process exit code " + code);
			
			printStderr(stderr);
		}); 
	}
	
	static function printStderr(stderr:String)
	{
		if (stderr != "")
		{
			Alertify.error("OpenFL tools stderr: " + stderr);
		}
	}
}