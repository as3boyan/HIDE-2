package ;

/**
 * ...
 * @author AS3Boyan
 */
extern class HIDE
{
	public static var plugins:Array<String>;
	public static var inactivePlugins:Array<String>;
	public static var conflictingPlugins:Array<String>;
	
	public static function loadJS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void;
	public static function loadCSS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void;
	public static function waitForDependentPluginsToBeLoaded(name:String, plugins:Array<String>, onLoaded:Void->Void, ?callOnLoadWhenAtLeastOnePluginLoaded:Bool = false):Void;
	public static function notifyLoadingComplete(name:String):Void;
	public static function openPageInNewWindow(name:String, url:String, ?params:Dynamic):Void;
	public static function compilePlugins(?onComplete:Dynamic, ?onFailed:Dynamic):Void;
	public static function readFile(name:String, path:String, onComplete:Dynamic):Void;
	public static function writeFile(name:String, path:String, contents:String, ?onComplete:Dynamic):Void;
	public static function surroundWithQuotes(path:String):String;
	public static function getPluginPath(name:String):String;
	public static function stringifyAndFormat(object:Dynamic):String;
}