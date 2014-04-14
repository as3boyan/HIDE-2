package js.node;
import js.Node;
import js.node.Walkdir.EventEmitter;

/**
 * ...
 * @author AS3Boyan
 */

extern class EventEmitter
{
	function on(event:String, fn:Dynamic):Void;
}

typedef Options =
{
	@:optional var no_recurse:Bool;
}
 
@:native("Walkdir")
class Walkdir
{
	static var walkdir:Dynamic;
	
	static function __init__() : Void untyped {
		walkdir = Node.require('walkdir');
	}	
	
	public static function walk(path:String, options:Options, ?onItem:String->NodeStat->Void):EventEmitter
	{
		var emitter:EventEmitter;
		
		if (onItem != null) 
		{
			emitter = walkdir(path, options);
		}
		else 
		{
			emitter = walkdir(path, options, onItem);
		}
		
		return emitter;
	}
}