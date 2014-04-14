package js.node;
import js.Node;

/**
 * ...
 * @author AS3Boyan
 */
class Mv
{
	static var mv:Dynamic;
	
	static function __init__() : Void untyped {
		mv = Node.require('mv');
	}
	
	public static function move(src:String, dest:String, cb:NodeErr->Void):Void
	{
		mv(src, dest, cb);
	}
	
}