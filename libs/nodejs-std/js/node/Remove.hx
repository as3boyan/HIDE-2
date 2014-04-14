package js.node;
import js.Node;

/**
 * ...
 * @author AS3Boyan
 */
class Remove
{
	static var remove:Dynamic;
	
	static function __init__() : Void untyped {
		remove = Node.require('remove');
	}
	
	public static function removeAsync(path:String, options:Dynamic, cb:NodeErr->Void)
	{
		remove(path, options, cb);
	}
}