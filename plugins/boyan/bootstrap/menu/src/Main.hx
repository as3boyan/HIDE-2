package ;
import js.Browser;
import ui.menu.basic.Menu;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.menu";
	public static var dependencies:Array<String> = ["boyan.bootstrap.script", "boyan.events.hotkey"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		//Will create menu bar when Bootstrap plugin is loaded
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, load);
	}
	
	private static function load():Void
	{
		//Create menubar(navbar) using Bootstrap
		BootstrapMenu.createMenuBar();
		
		//Example on how to create menu
		//BootstrapMenu.getMenu(name:String) function will create menu if it doesn't exists or return existing one
		//You can add menu items to menu using addMenuItem function:
		//menu.addMenuItem(_text:String, _onClickFunction:Void->Void, ?_hotkey:String):Void 
		
		//var fileMenu:Menu = BootstrapMenu.getMenu("File");
		//fileMenu.addMenuItem("New Project...", null, "Ctrl-Shift-N");
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}