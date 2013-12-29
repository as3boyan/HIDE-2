package ;

/**
 * ...
 * @author AS3Boyan
 */
class CMDoc
{
	public var name:String;
	public var doc:Dynamic;
	public var path:String;
	
	public function new(_name:String, _doc:Dynamic, _path:String) 
	{
		name = _name;
		doc = _doc;
		path = _path;
	}	
}