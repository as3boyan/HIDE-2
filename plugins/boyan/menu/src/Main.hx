package ;
import js.Browser;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.menu";
	public static var dependencies:Array<String> = ["boyan.bootstrap"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{				
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.plugins.push(name);
	}
	
}