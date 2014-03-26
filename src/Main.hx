package ;

import jQuery.JQuery;
import about.About;
import autoformat.HaxePrinterLoader;
import cm.CodeMirrorEditor;
import cm.CodeMirrorZoom;
import core.Alerts;
import core.CompilationOutput;
import core.Completion;
import core.DragAndDrop;
import core.FileDialog;
import core.HaxeLint;
import core.HaxeParserProvider;
import core.HaxeServer;
import core.Hotkeys;
import core.LocaleWatcher;
import core.MenuCommands;
import core.PreserveWindowState;
import core.RunProject;
import core.SettingsWatcher;
import core.ThemeWatcher;
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
import newprojectdialog.NewProjectDialogLoader;
import nodejs.webkit.Window;
import openflproject.OpenFLProject;
import openproject.OpenProjectLoader;
import projectaccess.ProjectAccess;
import projectaccess.ProjectOptions;
import tabmanager.TabManagerMain;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	public static var currentTime:Float;
	public static var pluginsTestingData:String = "  - cd plugins";
	public static var window:Window;
	
	static function main() 
	{        
		window = Window.get();
		window.showDevTools();
		
		js.Node.process.on('uncaughtException', function (err)
		{
			trace(err);
			
			//if (!window.isDevToolsOpen()) 
			//{
				//
			//}
		}
		);
        
		PreserveWindowState.init();
		
		Hotkeys.prepare();
		
		Browser.window.addEventListener("load", function (e):Void
		{
			SettingsWatcher.load();
			
			Utils.prepare();
			BootstrapMenu.createMenuBar();
			NewProjectDialogLoader.load();
			MenuCommands.add();
			CodeMirrorZoom.load();
			About.addToMenu();
			FileTree.init();
			ProjectOptions.create();
			FileDialog.create();
			TabManagerMain.load();
			Completion.registerHelper();
			HaxeLint.prepare();
			CodeMirrorEditor.load();
			
			HaxePrinterLoader.load();
			
			RunProject.load();
			
			ProjectAccess.registerSaveOnCloseListener();
			
			HaxeProject.load();
			OpenFLProject.load();
			
			CompilationOutput.load();
			
			OpenProjectLoader.load();
			DragAndDrop.prepare();
			
			currentTime = Date.now().getTime();
			
			checkHaxeInstalled(function ()
			{
				HaxeServer.check();
				loadPlugins();
			}
			,
			function ()
			{
				Alerts.showAlert("Haxe compiler is not found");
				loadPlugins(false);
			}
			);
		}
		);
		
		window.on("close", function (e)
		{
			for (w in HIDE.windows)
			{
				w.close(true);
			}
			
			window.close();
		}
		);
	}
	
	public static function loadPlugins(?compile:Bool = true):Void
	{
		var pathToPlugins:String = "plugins";
		
		if (!Node.fs.existsSync(pathToPlugins)) 
		{
			Node.fs.mkdirSync(pathToPlugins);
		}
		
		var pathToPluginsMTime:String = "pluginsMTime.dat";
		
		var args:Array<String>;
		
		if (js.Node.fs.existsSync(pathToPluginsMTime))
		{
			var options:js.Node.NodeFsFileOptions = { };
			options.encoding = js.Node.NodeC.UTF8;
			var data:String = js.Node.fs.readFileSync(pathToPluginsMTime, options);
			if (data != "") 
			{
				HIDE.pluginsMTime = Unserializer.run(data);
			}
		}
		else 
		{
			HIDE.firstRun = true;
		}
		
		readDir(pathToPlugins, "", function (path:String, pathToPlugin:String):Void
		{
			var pluginName:String = StringTools.replace(pathToPlugin, js.Node.path.sep, ".");
			
			var relativePathToPlugin:String = js.Node.path.join(path, pathToPlugin);
			
			//Store path to plugin, so we can load JS and CSS scripts by specifying path relative to plugin's directory
			HIDE.pathToPlugins.set(pluginName, relativePathToPlugin);
			
			var absolutePathToPlugin:String = js.Node.require("path").resolve(relativePathToPlugin);
			
			if (HIDE.firstRun)
			{
				HIDE.pluginsMTime.set(pluginName, Std.parseInt(Std.string(Date.now().getTime())));
			}
			
			if (compile && (!HIDE.pluginsMTime.exists(pluginName) || HIDE.pluginsMTime.get(pluginName) < walk(absolutePathToPlugin)))
			{				
				//Compile each plugin and load
				compilePlugin(pluginName, absolutePathToPlugin, loadPlugin);
			}
			else 
			{
				//Load plugin
				loadPlugin(absolutePathToPlugin);
			}
		});
		
		Timer.delay(function ():Void
		{
			if (HIDE.requestedPluginsData.length > 0)
			{
				trace("still not loaded plugins: ");
			
				for (pluginData in HIDE.requestedPluginsData)
				{
					trace(pluginData.name + ": can't load plugin, required plugins are not found");
					trace(pluginData.plugins);
					
					window.show();
				}
				
				HIDE.savePluginsMTime();
			}
		}
		, 10000);
	}
	
	private static function walk(pathToPlugin:String):Int
	{
		var pathToItem:String;
		var time:Int = -1;
		var mtime:Int;
		var extension:String;
		
		for (item in js.Node.fs.readdirSync(pathToPlugin))
		{
			pathToItem = js.Node.path.join(pathToPlugin, item);
			
			var stat = js.Node.fs.statSync(pathToItem);
			
			extension = js.Node.path.extname(pathToItem);
			
			if (stat.isFile() && (extension == ".hx" || extension == ".hxml"))
			{
				mtime = stat.mtime.getTime();
				
				if (time < mtime)
				{
					time = mtime;
				}
			}
			else if (stat.isDirectory()) 
			{
				mtime = walk(pathToItem);
				
				if (time < mtime)
				{
					time = mtime;
				}
			}
		}
		
		return time;
	}
	
	private static function readDir(path:String, pathToPlugin:String, onLoad:Dynamic):Void
	{
		var pathToFolder:String;
		
		js.Node.fs.readdir(js.Node.path.join(path, pathToPlugin), function (error:js.Node.NodeErr, folders:Array<String>):Void
		{
			if (error != null)
			{
				trace(error);
			}
			else 
			{
				for (item in folders)
				{
					if (item != "inactive")
					{
						pathToFolder = js.Node.path.join(path, pathToPlugin, item);
					
						js.Node.fs.stat(pathToFolder, function (error:js.Node.NodeErr, stat:js.Node.NodeStat)
						{
							if (error != null)
							{
								//trace(error);
							}
							else 
							{						
								var pluginName:String = StringTools.replace(pathToPlugin, js.Node.path.sep, ".");
								
								if (stat.isDirectory())
								{
									readDir(path, js.Node.path.join(pathToPlugin,item), onLoad);
								}
								else if (item == "plugin.hxml" && !Lambda.has(HIDE.inactivePlugins, pluginName))
								{	
									var levels:String = "";
									for (i in 0...pathToPlugin.split("\\").length)
									{
										levels += "../";
									}
									
									pluginsTestingData += "\n  - cd " + StringTools.replace(pathToPlugin, "\\", "/") + "\n  - haxe plugin.hxml\n  - cd " + levels;
									
									onLoad(path, pathToPlugin);
									return;
								}
							}
						}
						);
					}
				}
			}
		}
		);
	}
	
	private static function loadPlugin(pathToPlugin:String):Void
	{		
		var pathToMain:String = js.Node.path.join(pathToPlugin, "bin", "Main.js");
		
		js.Node.fs.exists(pathToMain, function (exists:Bool)
		{
			if (exists)
			{
				HIDE.loadJS(null, [pathToMain]);
			}
			else 
			{
				trace(pathToMain + " is not found/nPlease compile " + pathToPlugin + " plugin");
			}
		}
		);
	}
	
	public static function compilePlugin(name:String, pathToPlugin:String, onSuccess:Dynamic, ?onFailed:String->Void):Void
	{
		var pathToBin:String =  js.Node.path.join(pathToPlugin, "bin");
		
		js.Node.fs.exists(pathToBin, function (exists:Bool)
		{
			if (exists)
			{
				startPluginCompilation(name, pathToPlugin, onSuccess, onFailed);
			}
			else 
			{
				js.Node.fs.mkdir(pathToBin, function (error):Void
				{
					startPluginCompilation(name, pathToPlugin, onSuccess, onFailed);
				}
				);
			}
		}
		);
	}
	
	private static function startPluginCompilation(name:String, pathToPlugin:String, onSuccess:Dynamic, ?onFailed:String->Void):Void
	{
		var startTime:Float = Date.now().getTime();
		var delta:Float;
		
		var command:String = ["haxe", "--cwd", HIDE.surroundWithQuotes(pathToPlugin), "plugin.hxml"].join(" ");
		
		trace(command);
		
		var haxeCompilerProcess:js.Node.NodeChildProcess = js.Node.child_process.exec(command, { }, function (err, stdout, stderr)
		{			
			if (err == null)
			{
				delta = Date.now().getTime() - startTime;
				
				trace(name + " compilation took " + Std.string(delta)) + " ms";
				
				onSuccess(pathToPlugin);
				HIDE.pluginsMTime.set(name, Std.parseInt(Std.string(Date.now().getTime())));
			}
			else 
			{
				var element:Element = Browser.document.getElementById("plugin-compilation-console");

				var textarea:TextAreaElement;
				
				if (element == null)
				{
					textarea = Browser.document.createTextAreaElement();
					textarea.id = "plugin-compilation-console";
					textarea.value = "Plugins compile-time errors:\n";
					Browser.document.body.appendChild(textarea);
				}
				else  
				{
					textarea = cast(element, TextAreaElement);
				}
				
				trace(pathToPlugin + ' stderr: ' + stderr);
				
				textarea.value += name + "\n" + stderr + "\n";
				trace("can't load " + name + " plugin, compilation failed");
				
				var regex:EReg = new EReg("haxelib install (.+) ", "gim");
				regex.map(stderr, function (ereg:EReg)
				{
					trace(ereg);
					return "";
				}
				);
				
				if (onFailed != null)
				{
					onFailed(stderr);
				}
			}
		}
		);
	}
	
	private static function checkHaxeInstalled(onSuccess:Dynamic, onFailed:Dynamic):Void
	{
		js.Node.child_process.exec("haxe", { }, function (error, stdout, stderr) 
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