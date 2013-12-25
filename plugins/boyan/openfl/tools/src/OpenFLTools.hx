package ;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class OpenFLTools
{	
	public static function getParams(path:String, target:String, onLoaded:Dynamic):Void
	{
		js.Node.process.chdir(path);
		
		var openFLTools:Dynamic = js.Node.childProcess.spawn("haxelib", ["run", "openfl", "display", target]);
		
		var params:Array<String> = new Array();
		
		openFLTools.stdout.setEncoding('utf8');
		openFLTools.stdout.on('data', function (data) {
				var str:String = data.toString();
				//var lines = str.split("\n");
				//trace("OUTPUT: " + str);
				var textarea = cast(Browser.document.getElementById("output").firstElementChild, TextAreaElement);
				textarea.value += "OUTPUT: " + str;
				
				params = params.concat(str.split("\n"));
		});
		
		openFLTools.stderr.setEncoding('utf8');
		openFLTools.stderr.on('data', function (data) {
				var str:String = data.toString();
				//var lines = str.split("\n");
				trace("ERROR: " + str);
				var textarea = cast(Browser.document.getElementById("output").firstElementChild, TextAreaElement);
				textarea.value += "ERROR: " + str;
		});

		openFLTools.on('close', function (code:Int) {
				trace('OpenFL tools process exit code ' + code);
				
				if (code == 0)
				{
					if (onLoaded != null)
					{
						onLoaded(params);
					}
				}
		});
	}
}