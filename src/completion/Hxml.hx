package completion;
import core.HaxeHelper;
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
	
	static private function getHaxelibList(onComplete:Dynamic) 
	{
		HaxeHelper.getHaxelibList(function (data:Array<String>):Void 
		{
			for (item in data)
			{
				completions.push({text: "-lib " + item});
			}
			
			if (onComplete != null) 
			{
				onComplete();
			}
		}
		);
	}
	
	static private function getDefines(onComplete:Dynamic) 
	{
		HaxeHelper.getDefines(function (data:Array<String>):Void 
		{
			for (item in data)
			{
				completions.push( { text: "-D " + item } );
			}
			
			if (onComplete != null) 
			{
				onComplete();
			}
		}
		);
	}
	
	static private function getArguments(?onComplete:Dynamic) 
	{
		HaxeHelper.getArguments(function (data:Array<String>):Void 
		{
			for (item in data)
			{
				completions.push( { text: item } );
			}
			
			if (onComplete != null) 
			{
				onComplete();
			}
		}
		);
	}
	
	public static function getCompletion():Array<CompletionData>
	{
		return completions;
	}
}