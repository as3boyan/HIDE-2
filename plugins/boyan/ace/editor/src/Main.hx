package ;
import js.Browser;
import js.html.PreElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.ace.editor";
	public static var dependencies:Array<String> = ["boyan.jquery.split-pane", "boyan.bootstrap.tabmanager"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void 
		{
			var pre:PreElement= Browser.document.createPreElement();
			pre.id = "editor";
			
			Splitpane.components[1].appendChild(pre);
			
			HIDE.loadJS(name, ["bin/includes/js/ace.js"], function ():Void
			{
				var editor:Dynamic = untyped ace.edit("editor");
				editor.setTheme("ace/theme/textmate");
				editor.getSession().setMode("ace/mode/haxe");
				
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			}
			);
			
			HIDE.loadCSS(name, ["bin/includes/css/editor.css"]);
		}
		);
	}
	
}