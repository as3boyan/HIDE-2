package core;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class Bootbox
{
	public static function prompt(question:String, defaultValue:String, onClick:Dynamic):Void
	{
		var bootboxStatic:Dynamic = untyped __js__("bootbox");
		
		bootboxStatic.prompt(
		{
		  title: LocaleWatcher.getStringSync(question),
		  value: defaultValue,
		  callback: function(result) {
			if (result != null) 
			{
				onClick(result);
			}
		  }
		}
		);      
	}
}