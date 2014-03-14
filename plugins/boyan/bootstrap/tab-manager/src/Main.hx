package ;
import js.Browser;
import js.html.Element;
import js.html.UListElement;
import js.Node;
import nodejs.webkit.Window;

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
			Hotkeys.add("Tab Manager->Show Next Tab", "Ctrl-Tab", null, TabManager.showNextTab);
			
			//Ctrl-Shift-Tab
			Hotkeys.add("Tab Manager->Show Previous Tab", "Ctrl-Shift-Tab", null, TabManager.showPreviousTab);
			
			//Ctrl-N
			BootstrapMenu.getMenu("File").addMenuItem("New File...", 3, TabManager.createFileInNewTab, "Ctrl-N");
			
			//Ctrl-S
			BootstrapMenu.getMenu("File").addMenuItem("Save", 4, TabManager.saveActiveFile, "Ctrl-S");
			
			//Ctrl-Shift-S
			BootstrapMenu.getMenu("File").addMenuItem("Save As...", 5, TabManager.saveActiveFileAs, "Ctrl-Shift-S");
			
			BootstrapMenu.getMenu("File").addMenuItem("Save All", 6, TabManager.saveAll);
			
			//Ctrl-W
			BootstrapMenu.getMenu("File").addMenuItem("Close File", 7, TabManager.closeActiveTab, "Ctrl-W");
			
			Window.get().on('close', function (e)
			{
				TabManager.saveAll();
			}
			);
			
			BootstrapMenu.getMenu("Options", 90).addMenuItem("Open hotkey configuration file", 1, function ()
			{
				TabManager.openFileInNewTab(Node.path.join(HIDE.getPluginPath("boyan.events.hotkey"), "config.json"));
			}
			);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
}