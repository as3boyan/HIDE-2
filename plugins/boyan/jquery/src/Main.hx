package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.jquery";
	public static var dependencies:Array<String> = [];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		//Run-time jQuery loading
		//This line is equivalent to adding <script type="text/javascript" src="../plugins/boyan/jquery/bin/includes/js/jquery/jquery-2.0.3.min.js"></script> to bin/index.html head element
		HIDE.loadJS("../plugins/boyan/jquery/bin/includes/js/jquery/jquery-2.0.3.min.js", function ():Void
		{
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin(like Bootstrap) can start load themselves
			HIDE.plugins.push(name);
		});
	}
	
}