package completion;
import core.ProcessHelper;

/**
 * ...
 * @author AS3Boyan
 */
class MetaTags
{
	static var completions:Array<Hxml.CompletionData>;
	
	public static function load()
	{
		completions = [];
		
		ProcessHelper.runProcess("haxe", ["--help-metas"], function (stdout:String, stderr:String):Void 
		{
			var regex:EReg = ~/@:[A-Z]+ /gim;
			regex.map(stdout, function (ereg:EReg):String
			{
				completions.push({text: StringTools.trim(ereg.matched(0))});
				return ereg.matched(0);
			}
			);
		}
		);
	}
	
	public static function getCompletion():Array<Hxml.CompletionData>
	{
		return completions;
	}
}