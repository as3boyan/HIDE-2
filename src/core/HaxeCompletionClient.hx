package core;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeCompletionClient
{	
	private static var processStdout:String;
	private static var processStderr:String;
	
	public static function runProcess(process:String, params:Array<String>, onComplete:String->Void, onFailed:Int->String->Void):Void
	{		
		var command:String = process + " " + params.join(" ");
		
		trace(command);
		
		var haxeCompilerClient:js.Node.NodeChildProcess = js.Node.child_process.exec(command, { }, function (error, stdout:String, stderr:String):Void
		{	
			processStdout = stdout;
			processStderr = stderr;
			
			//if (stdout != "")
			//{
				//trace("stdout:\n" + stdout);
			//}
			//
			//if (stderr != "")
			//{
				//trace("stderr:\n" + stderr);
			//}
			
			if (error == null)
			{				
				onComplete(processStderr);
			}
			else 
			{
				onFailed(error.code, processStderr);
			}
		}
		);
	}
}