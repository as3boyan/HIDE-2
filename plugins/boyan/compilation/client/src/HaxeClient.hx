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
		var haxeCompilerClient:Dynamic = Utils.process.spawn(process, params);
			
		haxeCompilerClient.stdout.setEncoding('utf8');
		haxeCompilerClient.stdout.on('data', function (data) {
				var str:String = data.toString();
				//var lines = str.split("\n");
				trace("OUTPUT: " + str);
				var textarea = cast(Browser.document.getElementById("output").firstElementChild, TextAreaElement);
				textarea.value += "OUTPUT: " + str;
		});
		
		haxeCompilerClient.stderr.setEncoding('utf8');
		haxeCompilerClient.stderr.on('data', function (data) {
				var str:String = data.toString();
				//var lines = str.split("\n");
				trace("ERROR: " + str);
				var textarea = cast(Browser.document.getElementById("output").firstElementChild, TextAreaElement);
				textarea.value += "ERROR: " + str;
		});

		haxeCompilerClient.on('close', function (code:Int) {
				trace('haxeCompilerClient process exit code ' + code);
				
				if (code == 0 && onComplete != null)
				{
					onComplete();
				}
		});
	}
	
	public static function buildOpenFLProject(params:Array<String>, ?onComplete:Dynamic):Void
	{
		buildProject("haxelib", ["run", "openfl"].concat(params), onComplete);
	}
}