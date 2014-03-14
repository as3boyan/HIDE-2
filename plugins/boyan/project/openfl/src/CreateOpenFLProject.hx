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
	
	public static function createOpenFLProject(params:Array<String>, path:String, ?onComplete:Dynamic):Void
	{	
		var args = ["haxelib", "run", "openfl", "create"].concat(params).join(" ");
		
		trace(args);
		
		var OpenFLTools:js.Node.NodeChildProcess = js.Node.child_process.exec(args, { cwd: path }, function (error, stdout, stderr) 
		{
			trace(stderr);
		}
		);
		
		OpenFLTools.on("close", function (code:Int)
		{
			trace("exit code: " + Std.string(code));
			
			if (code == 0 && onComplete != null) 
			{
				onComplete();
			}
		}
		);
	}
	
}