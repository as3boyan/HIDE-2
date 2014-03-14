package ;

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
		  title: question,
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