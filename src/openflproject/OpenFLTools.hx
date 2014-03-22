package openflproject;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class OpenFLTools
{	
	private static var processStdout:String;
	private static var processStderr:String;
	
	public static function getParams(path:String, target:String, onLoaded:Dynamic):Void
	{
		processStdout = "";
		processStderr = "";
		
		var openFLTools:js.Node.NodeChildProcess = js.Node.child_process.exec(["haxelib", "run", "openfl", "display", target].join(" "), { cwd: path }, function (error, stdout, stderr)
		{
			processStdout = stdout;
			processStderr = stderr;
		}
		);
		
		openFLTools.on("close", function (code:Int)
		{
			trace('OpenFL tools process exit code ' + code);
			
			var textarea = cast(Browser.document.getElementById("output"), TextAreaElement);
			textarea.value += "OUTPUT: " + processStdout;
			
			if (processStderr != "")
			{
				textarea.value += "ERROR: " + processStderr;
			}			
			
			if (code == 0)
			{
				if (onLoaded != null)
				{
					onLoaded(processStdout);
				}
			}
		}
		);
	}
}