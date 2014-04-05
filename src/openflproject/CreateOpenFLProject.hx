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
		var processParams = ["run", "lime", "create"].concat(params);
		
		ProcessHelper.runProcess("haxelib", processParams, path, onComplete, function (code, stdout, stderr):Void 
		{
			Alertify.error(["haxelib"].concat(processParams).join(" ") + " " + Std.string(code));
			
			if (stdout != "") 
			{
				Alertify.error("stdout:\n" + stdout);
			}
			
			if (stderr != "") 
			{
				Alertify.error("stderr:\n" + stderr);
			}
		});
	}
	
}