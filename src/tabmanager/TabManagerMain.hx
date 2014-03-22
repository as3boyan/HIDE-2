package tabmanager;
import core.Hotkeys;
import filetree.FileTree;
import js.Browser;
import js.html.Element;
import js.html.UListElement;
import js.Node;
import menu.BootstrapMenu;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
class TabManagerMain
{	
	public static function load():Void
	{
		TabManager.init();
		
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
		
		Window.get().on('close', TabManager.saveAll);
		
		BootstrapMenu.getMenu("Options", 90).addMenuItem("Open hotkey configuration file", 1, TabManager.openFileInNewTab.bind("hotkeys.json"));
	}
}