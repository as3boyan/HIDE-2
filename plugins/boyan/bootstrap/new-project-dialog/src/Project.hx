package ;

/**
 * ...
 * @author AS3Boyan
 */
class Project
{
	inline static public var HAXE:Int = 0;
	inline static public var OPENFL:Int = 1;
	inline static public var HXML:Int = 2;
	
	public var target:String;
	public var type:Int;
	
	public var name:String;
	public var main:String;
	public var projectPackage:String;
	public var company:String;
	public var license:String;
	public var url:String;
	
	public var customArgs:Bool;
	public var args:Array<String>;
	
	public var files:Array<String>;
	
	public function new() 
	{
		customArgs = false;
	}
	
}