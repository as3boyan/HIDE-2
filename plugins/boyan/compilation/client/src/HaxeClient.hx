package ;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeClient
{	
	public static function buildProject(command:String, ?onComplete:Dynamic):Void
	{		
		var textarea = cast(Browser.document.getElementById("output"), TextAreaElement);
		textarea.value = "Build started\n";
		textarea.value += command + "\n";
		
		var haxeCompilerClient:js.Node.NodeChildProcess = js.Node.child_process.exec(command, { }, function (error, stdout:String, stderr:String):Void
		{
			if (StringTools.trim(stdout) != "")
			{
				textarea.value += "stdout:\n" + stdout;
				trace("stdout:\n" + stdout);
			}
			
			if (stderr != "")
			{
				textarea.value += "stderr:\n" + stderr;
				trace("stderr:\n" + stderr);
			}
		}
		);
		
		haxeCompilerClient.on("close", function (code:Int):Void
		{
			if (code == 0)
			{
				textarea.value += "Build complete\n";
				
				if (onComplete != null)
				{
					onComplete();
				}
			}
			else 
			{
				trace(command);
				textarea.value += "Build failed (exit code: " + Std.string(code) +  ")\n" ;
			}
		}
		);
	}
	
	public static function buildOpenFLProject(params:Array<String>, ?onComplete:Dynamic):Void
	{
		//buildProject("haxelib", ["run", "openfl"].concat(params), onComplete);
	}
}