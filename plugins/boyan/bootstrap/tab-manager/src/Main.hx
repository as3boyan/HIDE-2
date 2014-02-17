package ;
import js.Browser;
import js.html.Element;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.tab-manager";
	public static var dependencies:Array<String> = [];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		//Load CSS for tab styling
		HIDE.loadCSS(name, ["bin/includes/css/tabs.css"]);
		
		//Will wait for dependent plugins
		//HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.jquery.split-pane", "boyan.jquery.layout"], load, true);
		HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.jquery.layout"], load);
	}
	
	private static function load():Void
	{
		TabManager.init();
		
		HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.bootstrap.file-tree", "boyan.events.hotkey"], function ():Void
		{
			FileTree.onFileClick = TabManager.openFileInNewTab;
			
			//Ctrl-Tab
			Hotkeys.addHotkey(9, true, false, false, TabManager.showNextTab);
			
			//Ctrl-Shift-Tab
			Hotkeys.addHotkey(9, true, true, false, TabManager.showPreviousTab);
			
			//Ctrl-W
			Hotkeys.addHotkey("W".code, true, false, false, TabManager.closeActiveTab);
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
}