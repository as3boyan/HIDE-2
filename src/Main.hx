package ;

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
	
	static function main() 
	{
		js.Node.require('nw.gui').Window.get().showDevTools();
		
		Browser.window.onload = function (e)
		{
			js.Node.require('nw.gui').Window.get().show();
			loadPlugins();
		};
	}
	
	private static function loadPlugins():Void
	{
		var pathToPlugins:String = js.Node.path.join("..", "plugins");
			
		readDir(pathToPlugins, "", function (path:String, pathToPlugin:String):Void
		{
			var pluginName:String = StringTools.replace(pathToPlugin, js.Node.path.sep, ".");
			
			var relativePathToPlugin:String = js.Node.path.join(path, pathToPlugin);
			
			//Store path to plugin, so we can load scripts by specifying path relative to plugin's directory
			HIDE.pathToPlugins.set(pluginName, relativePathToPlugin);
			
			var absolutePathToPlugin:String = js.Node.require("path").resolve(relativePathToPlugin);
			
			if (true)
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
								trace(error);
							}
							else 
							{						
								if (stat.isDirectory())
								{
									readDir(path, js.Node.path.join(pathToPlugin,item), onLoad);
								}
								else if (item == "plugin.hxml" && !Lambda.has(HIDE.inactivePlugins, StringTools.replace(pathToPlugin, js.Node.path.sep, ".")))
								{
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
		HIDE.loadJS(null, [pathToMain]);
	}
	
	private static function compilePlugin(name:String, pathToPlugin:String, onSuccess:Dynamic):Void
	{
		var haxeCompilerProcess:js.Node.NodeChildProcess = js.Node.childProcess.spawn("haxe", ["--cwd", pathToPlugin, "plugin.hxml"]);
						
		haxeCompilerProcess.stderr.on('data', function (data:String):Void {
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
			}
		}
		);
	}
	
}