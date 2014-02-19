package ;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeClient
{	
	public static function buildProject(process:String, params:Array<String>, ?onComplete:Dynamic):Void
	{
		//"haxe", "--connect", "6001", "--cwd", "..","HaxeEditor2.hxml"
		
		var textarea = cast(Browser.document.getElementById("output"), TextAreaElement);
		textarea.value = "";
		
		var haxeCompilerClient:js.Node.NodeChildProcess = js.Node.childProcess.exec(process + " " + params.join(" "), { }, function (error, stdout:String, stderr:String):Void
		{			
			if (stdout != "")
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