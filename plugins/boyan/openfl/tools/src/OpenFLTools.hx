package ;
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
		//js.Node.process.chdir(path);
		
		processStdout = "";
		processStderr = "";
		
		var params:Array<String> = new Array();
		
		var openFLTools:js.Node.NodeChildProcess = js.Node.childProcess.exec(["haxelib", "run", "openfl", "display", target], { } function (error, stdout, stderr)
		{
			processStdout = stdout;
			processStderr = stderr;
		}
		);
		
		openFLTools.on("close", function (code:Int)
		{
			trace('OpenFL tools process exit code ' + code);
			
			var textarea = cast(Browser.document.getElementById("output").firstElementChild, TextAreaElement);
			textarea.value += "OUTPUT: " + processStdout;
			textarea.value += "ERROR: " + processStderr;
				
			params = params.concat(processStdout.split("\n"));
			
			if (code == 0)
			{
				if (onLoaded != null)
				{
					onLoaded(params);
				}
			}
		}
		);
	}
}