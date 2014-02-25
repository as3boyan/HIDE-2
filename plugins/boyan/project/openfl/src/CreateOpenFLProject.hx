package ;

/**
 * ...
 * @author AS3Boyan
 */
class CreateOpenFLProject
{

	public function new() 
	{
		
	}
	
	public static function createOpenFLProject(params:Array<String>, ?onComplete:Dynamic):Void
	{
		var OpenFLTools:js.Node.NodeChildProcess = js.Node.childProcess.exec(["haxelib", "run", "openfl", "create"].concat(params).join(" "), { }, function (error, stdout, stderr) 
		{
			trace(stderr);
		}
		);
		
		OpenFLTools.on("close", function (code:Int)
		{
			trace("exit code: " + Std.string(code));
			
			if (onComplete != null) 
			{
				onComplete();
			}
		}
		);
	}
	
}