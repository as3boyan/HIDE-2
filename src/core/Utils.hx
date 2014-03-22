package core;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class Utils
{
	inline public static var WINDOWS:Int = 0;
	inline public static var LINUX:Int = 1;
	inline public static var OTHER:Int = 2;
	
	public static var os:Int;
	
	public static function prepare():Void
	{		
		switch(js.Node.os.type())
        {
			case "Windows_NT":
				os = WINDOWS;
			case "Linux":
				os = LINUX;
			case _:
				os = OTHER;
        }
	}
}