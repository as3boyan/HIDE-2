package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.presentation.reveal.plugin-development-tutorial";
	public static var dependencies:Array<String> = [];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.openPageInNewWindow(name, "bin/index.html", {toolbar:false});
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
		
		//HIDE.loadCSS(name, ["bin/includes/css/reveal.min.css", "bin/includes/css/theme/default.css", "bin/includes/lib/css/zenburn.css"]);
		
		//HIDE.loadJS(name, ["bin/includes/lib/js/head.min.js", "bin/includes/js/reveal.min.js"], function ():Void
		//{
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			//HIDE.notifyLoadingComplete(name);
			//
			//HIDE.openPageInNewWindow(name, "bin/index.html");
		//}
		//);
	}
	
}