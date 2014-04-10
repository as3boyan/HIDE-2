package core;

/**
 * ...
 * @author AS3Boyan
 */
class HaxeHelper
{
	public static function getArguments(onComplete:Array<String>->Void):Void
	{
		var data:Array<String> = [];
		
		ProcessHelper.runProcess("haxe", ["--help"], null, function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/-+[A-Z-]+ /gim;
			regex.map(stderr, function (ereg:EReg):String
			{
				var str = ereg.matched(0);
				data.push(str.substr(0, str.length - 1));
				return str;
			}
			);
			onComplete(data);
		}
		);
	}
	
	public static function getDefines(onComplete:Array<String>->Void):Void
	{
		var data:Array<String> = [];
		
		ProcessHelper.runProcess("haxe", ["--help-defines"], null, function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/[A-Z-]+ +:/gim;
			regex.map(stdout, function (ereg:EReg):String
			{
				var str = ereg.matched(0);
				data.push(StringTools.trim(str.substr(0, str.length - 1)));
				return ereg.matched(0);
			}
			);
			onComplete(data);
		}
		);
	}
	
	public static function getHaxelibList(onComplete:Array<String>->Void):Void
	{
		var data:Array<String> = [];
		
		ProcessHelper.runProcess("haxelib", ["list"], null, function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/^[A-Z-]+:/gim;
			regex.map(stdout, function (ereg:EReg):String
			{
				var str = ereg.matched(0);
				data.push(str.substr(0, str.length - 1));
				return str;
			}
			);
			onComplete(data);
		}
		);
	}
}