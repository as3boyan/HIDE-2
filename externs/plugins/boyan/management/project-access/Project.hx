package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class Project
{
	//Project type
	inline static public var HAXE:Int = 0;
	inline static public var OPENFL:Int = 1;
	inline static public var HXML:Int = 2;
	
	//Compilation targets
	inline static public var FLASH:Int = 0;
	inline static public var JAVASCRIPT:Int = 1;
	inline static public var PHP:Int = 2;
	inline static public var CPP:Int = 3;
	inline static public var JAVA:Int = 4;
	inline static public var CSHARP:Int = 5;
	inline static public var NEKO:Int = 6;
	
	public var target:Int;
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
	
	public var path:String;

	public function new() 
	{
		
	}
	
}