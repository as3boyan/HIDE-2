package completion;
import core.ProcessHelper;

/**
 * ...
 * @author AS3Boyan
 */

typedef CompletionData =
{
	var text:String;
	@:optional var displayText:String;
	@:optional var hint:CodeMirror->Dynamic->CompletionData->Void;
}
 
class Hxml
{
	static var completions:Array<CompletionData>;
	
	public static function load()
	{
		completions = [];
		
		getArguments(getDefines.bind(getHaxelibList));
	}
	
	static function getArguments(onComplete:Dynamic)
	{
		ProcessHelper.runProcess("haxe", ["--help"], function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/-+[A-Z-]+ /gim;
			regex.map(stderr, function (ereg:EReg):String
			{
				var str = ereg.matched(0);
				completions.push({text: str.substr(0, str.length - 1)});
				return str;
			}
			);
			onComplete();
		}
		);
	}
	
	static function getDefines(onComplete:Dynamic)
	{
		ProcessHelper.runProcess("haxe", ["--help-defines"], function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/[A-Z-]+ +:/gim;
			regex.map(stdout, function (ereg:EReg):String
			{
				var str = ereg.matched(0);
				completions.push({text: "-D " + StringTools.trim(str.substr(0, str.length - 1))});
				return ereg.matched(0);
			}
			);
			onComplete();
		}
		);
	}
	
	static function getHaxelibList()
	{
		ProcessHelper.runProcess("haxelib", ["list"], function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/^[A-Z-]+:/gim;
			regex.map(stdout, function (ereg:EReg):String
			{
				var str = ereg.matched(0);
				completions.push({text: "-lib " + str.substr(0, str.length - 1)});
				return str;
			}
			);
		}
		);
	}
	
	public static function getCompletion():Array<CompletionData>
	{
		return completions;
	}
}