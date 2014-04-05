package core;
import filetree.FileTree;
import js.Node;
import menu.BootstrapMenu;
import newprojectdialog.NewProjectDialog;
import nodejs.webkit.App;
import nodejs.webkit.Window;
import openproject.OpenProject;
import tabmanager.TabManager;
import watchers.SettingsWatcher;

/**
 * ...
 * @author AS3Boyan
 */
class MenuCommands
{
	public static function add():Void 
	{
		var window = Window.get();

		BootstrapMenu.getMenu("View").addMenuItem("Zoom In", 2, function ():Void
		{
			window.zoomLevel += 1;
		}
		, "Ctrl-Shift-+");

		BootstrapMenu.getMenu("View").addMenuItem("Zoom Out", 3, function ():Void
		{
			window.zoomLevel -= 1;
		}
		, "Ctrl-Shift--");

		BootstrapMenu.getMenu("View").addMenuItem("Reset", 4, function ():Void
		{
			window.zoomLevel = 0;
		}
		, "Ctrl-Shift-0");
		
		BootstrapMenu.getMenu("View", 2).addMenuItem("Toggle Fullscreen", 1, function ():Void
		{
			window.toggleFullscreen();
		}
		, "F11");
		
		BootstrapMenu.getMenu("Help").addMenuItem("changelog", 1, TabManager.openFileInNewTab.bind("changes.md"));
		
		BootstrapMenu.getMenu("Developer Tools", 100).addMenuItem("Reload IDE", 1, window.reloadIgnoringCache, "Ctrl-Shift-R");

		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Compile plugins and reload IDE", 2, function ():Void
		{			
			HIDE.compilePlugins(function ():Void
			{
				//Only when all plugins successfully loaded
				window.reloadIgnoringCache();
			}
			//On plugin compilation failed
			, function (data:String):Void
			{
				
			}
			);
			
		}
		, "Shift-F5");
		
		BootstrapMenu.getMenu("Developer Tools").addMenuItem("Console", 3, window.showDevTools);
		
		BootstrapMenu.getMenu("Options").addMenuItem("Open settings", 1, TabManager.openFileInNewTab.bind(Node.path.join("config","settings.json")));
		BootstrapMenu.getMenu("Options").addMenuItem("Open stylesheet", 1, TabManager.openFileInNewTab.bind(SettingsWatcher.settings.theme));
		BootstrapMenu.getMenu("Options").addMenuItem("Open editor configuration file", 1, TabManager.openFileInNewTab.bind(Node.path.join("config","editor.json")));
		BootstrapMenu.getMenu("Options").addMenuItem("Open templates folder", 1, FileTree.load.bind("templates", "templates"));
		BootstrapMenu.getMenu("Options").addMenuItem("Open localization file", 1, TabManager.openFileInNewTab.bind(Node.path.join("locale",SettingsWatcher.settings.locale)));
		BootstrapMenu.getMenu("Help").addMenuItem("Show code editor key bindings", 2, TabManager.openFileInNewTab.bind("bindings.txt"));
		
		//Ctrl-Tab
		Hotkeys.add("Tab Manager->Show Next Tab", "Ctrl-Tab", null, TabManager.showNextTab);
		
		//Ctrl-Shift-Tab
		Hotkeys.add("Tab Manager->Show Previous Tab", "Ctrl-Shift-Tab", null, TabManager.showPreviousTab);
		
		//Ctrl-W
		Hotkeys.add("Tab Manager->Close File", "Ctrl-W", null, TabManager.closeActiveTab);
		
		BootstrapMenu.getMenu("File", 1).addMenuItem("New Project...", 1, NewProjectDialog.show, "Ctrl-Shift-N");
		
		//Ctrl-N
		BootstrapMenu.getMenu("File").addMenuItem("New File...", 2, TabManager.createFileInNewTab, "Ctrl-N");
		BootstrapMenu.getMenu("File").addSeparator();
		BootstrapMenu.getMenu("File").addMenuItem("Open Project...", 3, OpenProject.openProject.bind(null, true));
		BootstrapMenu.getMenu("File").addSubmenu("Open Recent Project");
		BootstrapMenu.getMenu("File").addMenuItem("Close Project", 4, OpenProject.closeProject);
		BootstrapMenu.getMenu("File").addMenuItem("Open File...", 5, OpenProject.openProject, "Ctrl-O");
		BootstrapMenu.getMenu("File").addSubmenu("Open Recent File");
		BootstrapMenu.getMenu("File").addSeparator();
		
		//Ctrl-S
		BootstrapMenu.getMenu("File").addMenuItem("Save", 6, TabManager.saveActiveFile, "Ctrl-S");
		//Ctrl-Shift-S
		BootstrapMenu.getMenu("File").addMenuItem("Save As...", 7, TabManager.saveActiveFileAs, "Ctrl-Shift-S");
		BootstrapMenu.getMenu("File").addMenuItem("Save All", 8, TabManager.saveAll);
		BootstrapMenu.getMenu("File").addSeparator();
		
		BootstrapMenu.getMenu("File").addMenuItem("Exit", 9, App.closeAllWindows);
		
		Window.get().on('close', TabManager.saveAll);
		
		BootstrapMenu.getMenu("Options", 90).addMenuItem("Open hotkey configuration file", 1, TabManager.openFileInNewTab.bind(Node.path.join("config","hotkeys.json")));
		
		Hotkeys.add("Code Editor->Go to Line", "Ctrl-G", null, GoToLine.show);
		
		Hotkeys.add("Completion->Open File", "Ctrl-Shift-O", null, Completion.showFileList);
		Hotkeys.add("Completion->Show Class List", "Ctrl-Shift-P", null, Completion.showClassList);
	}
}