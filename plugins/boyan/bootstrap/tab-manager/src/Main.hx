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
		HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.jquery.split-pane", "boyan.jquery.layout", "boyan.window.splitpane"], load, true);
	}
	
	private static function load():Void
	{
		TabManager.init();
		
		HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.bootstrap.file-tree", "boyan.bootstrap.menu"], function ():Void
		{
			FileTree.onFileClick = TabManager.openFileInNewTab;
			
			//Ctrl-Tab
			Hotkeys.addHotkey(9, true, false, false, TabManager.showNextTab);
			
			//Ctrl-Shift-Tab
			Hotkeys.addHotkey(9, true, true, false, TabManager.showPreviousTab);
			
			//Ctrl-N
			BootstrapMenu.getMenu("File").addMenuItem("New File...", 3, TabManager.createFileInNewTab, "Ctrl-N", "N".code, true, false, false);
			
			//Ctrl-S
			BootstrapMenu.getMenu("File").addMenuItem("Save", 4, TabManager.saveActiveFile, "Ctrl-S", "S".code, true, false, false);
			
			//Ctrl-Shift-S
			BootstrapMenu.getMenu("File").addMenuItem("Save As...", 5, TabManager.saveActiveFileAs, "Ctrl-Shift-S", "S".code, true, true, false);
			
			BootstrapMenu.getMenu("File").addMenuItem("Save All", 6, TabManager.saveAll);
			
			//Ctrl-W
			BootstrapMenu.getMenu("File").addMenuItem("Close File", 7, TabManager.closeActiveTab, "Ctrl-W", "W".code, true, false, false);
			
			js.Node.require('nw.gui').Window.get().on('close', function (e)
			{
				TabManager.saveAll();
			}
			);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
}