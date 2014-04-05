package ;

import core.RecentProjectsList;
import core.Splitter;
import core.WelcomeScreen;
import dialogs.DialogManager;
import jQuery.JQuery;
import about.About;
import autoformat.HaxePrinterLoader;
import cm.Editor;
import cm.Zoom;
import core.CompilationOutput;
import core.Completion;
import core.DragAndDrop;
import core.FileDialog;
import core.HaxeLint;
import core.HaxeParserProvider;
import core.HaxeServer;
import core.Hotkeys;
import core.MenuCommands;
import core.PreserveWindowState;
import core.RunProject;
import core.Utils;
import filetree.FileTree;
import haxe.Timer;
import haxe.Unserializer;
import haxeproject.HaxeProject;
import js.Browser;
import js.html.Element;
import js.html.TextAreaElement;
import js.Node;
import js.node.Walkdir;
import menu.BootstrapMenu;
import newprojectdialog.NewProjectDialog;
import nodejs.webkit.App;
import nodejs.webkit.Window;
import openflproject.OpenFLProject;
import openproject.OpenProject;
import parser.ClasspathWalker;
import pluginloader.PluginManager;
import projectaccess.ProjectAccess;
import projectaccess.ProjectOptions;
import tabmanager.TabManager;
import watchers.SettingsWatcher;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	public static var currentTime:Float;
	public static var window:Window;
	
	static function main() 
	{        
		window = Window.get();
		window.showDevTools();
		
		js.Node.process.on('uncaughtException', function (err)
		{
			trace(err);
			
			//window.on("loaded", function ():Void 
			//{
				//window.show();
			//}
			//);
			
			//if (!window.isDevToolsOpen()) 
			//{
				
			//}
		}
		);
        
		Hotkeys.prepare();
		PreserveWindowState.init();
		
		Browser.window.addEventListener("load", function (e):Void
		{
			Splitter.load();
			
			SettingsWatcher.load();
			DialogManager.load();
			
			Utils.prepare();
			BootstrapMenu.createMenuBar();
			NewProjectDialog.load();
			MenuCommands.add();
			Zoom.load();
			About.addToMenu();
			FileTree.init();
			ProjectOptions.create();
			FileDialog.create();
			TabManager.load();
			HaxeLint.load();
			Editor.load();
			Completion.registerHelper();
			
			HaxePrinterLoader.load();
			
			RunProject.load();
			
			ProjectAccess.registerSaveOnCloseListener();
			
			HaxeProject.load();
			OpenFLProject.load();
			
			CompilationOutput.load();
			
			RecentProjectsList.load();
			OpenProject.searchForLastProject();
			DragAndDrop.prepare();
			ClasspathWalker.load();
			WelcomeScreen.load();
			
			currentTime = Date.now().getTime();
			
			checkHaxeInstalled(function ()
			{
				HaxeServer.check();
				PluginManager.loadPlugins();
			}
			,
			function ()
			{
				Alertify.error("Haxe compiler is not found");
				PluginManager.loadPlugins(false);
			}
			);
		}
		);
		
		window.on("close", function (e)
		{
			App.closeAllWindows();
			//for (w in HIDE.windows)
			//{
				//w.close(true);
			//}
			
			window.close();
		}
		);
	}
	
	private static function checkHaxeInstalled(onSuccess:Dynamic, onFailed:Dynamic):Void
	{
		Node.child_process.exec("haxe", { }, function (error, stdout, stderr) 
		{			
			if (error == null)
			{
				onSuccess();
			}
			else 
			{
				//if (error.code = 1)
				//{
					//
				//}
				
				trace(error);
				trace(stdout);
				trace(stderr);
				onFailed();
			}
		}
		);
	}
}