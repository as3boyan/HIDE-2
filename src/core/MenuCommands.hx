package core;
import dialogs.DialogManager;
import dialogs.ProjectOptionsDialog;
import filetree.FileTree;
import js.Node;
import menu.BootstrapMenu;
import newprojectdialog.NewProjectDialog;
import nodejs.webkit.App;
import nodejs.webkit.Shell;
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
		
		BootstrapMenu.getMenu("View", 3).addMenuItem("Toggle Fullscreen", 1, function ():Void
		{
			window.toggleFullscreen();
		}
		, "F11");
		
		BootstrapMenu.getMenu("Help").addMenuItem("changelog", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "changes.md")));
		
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
		
		BootstrapMenu.getMenu("Help").addMenuItem("Show code editor key bindings", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "bindings.txt")));
		BootstrapMenu.getMenu("Help").addMenuItem("View HIDE repository on GitHub", 2, Shell.openExternal.bind("https://github.com/as3boyan/HIDE-2"));
		BootstrapMenu.getMenu("Help").addMenuItem("Report issue/request feature at GitHub issue tracker", 3, Shell.openExternal.bind("https://github.com/as3boyan/HIDE-2/issues/new"));
		BootstrapMenu.getMenu("Help").addMenuItem("About HIDE...", 4, HIDE.openPageInNewWindow.bind(null, "about.html", {toolbar:false}));
		
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
		
		BootstrapMenu.getMenu("Options").addMenuItem("Open haxelib manager", 1, DialogManager.showHaxelibManagerDialog);
		BootstrapMenu.getMenu("Options").addMenuItem("Open settings", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "config","settings.json")));
		BootstrapMenu.getMenu("Options").addMenuItem("Open stylesheet", 1, TabManager.openFileInNewTab.bind(SettingsWatcher.settings.theme));
		BootstrapMenu.getMenu("Options").addMenuItem("Open editor configuration file", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "config","editor.json")));
		BootstrapMenu.getMenu("Options").addMenuItem("Open templates folder", 1, FileTree.load.bind("templates", Node.path.join("core","templates")));
		BootstrapMenu.getMenu("Options").addMenuItem("Open localization file", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "locale",SettingsWatcher.settings.locale)));
		BootstrapMenu.getMenu("Options", 90).addMenuItem("Open hotkey configuration file", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "config","hotkeys.json")));
		
		BootstrapMenu.getMenu("Edit", 2).addMenuItem("Undo", 1, null);
		BootstrapMenu.getMenu("Edit").addMenuItem("Redo", 1, null);
		BootstrapMenu.getMenu("Edit").addSeparator();
		BootstrapMenu.getMenu("Edit").addMenuItem("Cut", 1, null);
		BootstrapMenu.getMenu("Edit").addMenuItem("Copy", 1, null);
		BootstrapMenu.getMenu("Edit").addMenuItem("Paste", 1, null);
		BootstrapMenu.getMenu("Edit").addSeparator();
		BootstrapMenu.getMenu("Edit").addMenuItem("Find...", 1, null);
		BootstrapMenu.getMenu("Edit").addMenuItem("Replace...", 1, null);
		
		BootstrapMenu.getMenu("Navigate", 4).addMenuItem("Go to Line", 2, GoToLine.show, "Ctrl-G");
		BootstrapMenu.getMenu("Navigate").addMenuItem("Open File", 3, Completion.showFileList, "Ctrl-Shift-O");
		BootstrapMenu.getMenu("Source").addMenuItem("Show Class List", 4, Completion.showClassList, "Ctrl-Shift-P");
		
		BootstrapMenu.getMenu("Project", 80).addMenuItem("Run", 1, RunProject.runProject, "F5");
		BootstrapMenu.getMenu("Project").addMenuItem("Build", 2, RunProject.buildProject, "F8");
		BootstrapMenu.getMenu("Project").addMenuItem("Clean", 3, RunProject.cleanProject, "Shift-F8");
		BootstrapMenu.getMenu("Project").addMenuItem("Set This Hxml As Project Build File", 4, RunProject.setHxmlAsProjectBuildFile);
		BootstrapMenu.getMenu("Project").addSubmenu("Build Recent Project");
		BootstrapMenu.getMenu("Project").addMenuItem("Project Options...", 5, DialogManager.showProjectOptions);
	}
}