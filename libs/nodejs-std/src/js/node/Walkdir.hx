package js.node;

/**
 * ...
 * @author 
 */
@:native('js.node.$walkdir')
class Walkdir
{
	public static var walk:Dynamic;
	
	static function __init__() : Void untyped {
		__js__("js.node.$walkdir = require('walkdir')");
		walk = Walkdir;
	}	
}