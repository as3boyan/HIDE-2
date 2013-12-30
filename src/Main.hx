package ;

import haxe.Timer;
import js.Browser;
import js.html.KeyboardEvent;
import js.html.LinkElement;
import js.Lib;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	public static var currentTime:Float;
	public static var pluginsTestingData:String = "";
	public static var window:Dynamic;
	
	static function main() 
	{
		var gui:Dynamic = js.Node.require('nw.gui');
		window = gui.Window.get();
		
		window.showDevTools();
		
		Browser.window.addEventListener("load", function (e):Void
		{
			window.show();
			currentTime = Date.now().getTime();
			
			checkHaxeInstalled(function ()
			{
				loadPlugins();
			}
			,
			function ()
			{
				loadPlugins(false);
			}
			);
		}
		);
				
		window.on("close", function (e):Void
		{
			for (window in HIDE.windows)
			{
				window.close(true);
			}
		}
		);
	}
	
	public static function loadPlugins(?compile:Bool = true):Void
	{
		var pathToPlugins:String = js.Node.path.join("..", "plugins");
			
		readDir(pathToPlugins, "", function (path:String, pathToPlugin:String):Void
		{
			var pluginName:String = StringTools.replace(pathToPlugin, js.Node.path.sep, ".");
			
			var relativePathToPlugin:String = js.Node.path.join(path, pathToPlugin);
			
			//Store path to plugin, so we can load JS and CSS scripts by specifying path relative to plugin's directory
			HIDE.pathToPlugins.set(pluginName, relativePathToPlugin);
			
			var absolutePathToPlugin:String = js.Node.require("path").resolve(relativePathToPlugin);
			
			if (compile)
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
			}
		}
		, 10000);
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
								//&& !Lambda.has(HIDE.conflictingPlugins, pluginName)
								else if (item == "plugin.hxml" && !Lambda.has(HIDE.inactivePlugins, pluginName))
								{
									pluginsTestingData += "\n    - pushd " + StringTools.replace(js.Node.path.join("plugins", pathToPlugin), js.Node.path.sep, "/") + " && haxe plugin.hxml && popd";
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
		var haxeCompilerProcess:js.Node.NodeChildProcess = js.Node.childProcess.spawn("haxe", ["--cwd", pathToPlugin, "plugin.hxml"]);
						
		var stderrData:String = "";

		haxeCompilerProcess.stderr.on('data', function (data:String):Void {
			stderrData += data;
			trace(pathToPlugin + ' stderr: ' + data);
		});
		
		haxeCompilerProcess.on("close", function (code:Int):Void
		{
			if (code == 0)
			{
				onSuccess(pathToPlugin);
			}
			else 
			{
				trace("can't load " + name + " plugin, compilation failed");

				if (onFailed != null)
				{
					onFailed(stderrData);
				}
			}
		}
		);
	}
	
	private static function checkHaxeInstalled(onSuccess:Dynamic, onFailed:Dynamic):Void
	{
		js.Node.childProcess.exec("haxe", { }, function (error, stdout, stderr) 
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