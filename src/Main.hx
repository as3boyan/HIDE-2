package ;

import haxe.Timer;
import haxe.Unserializer;
import js.Browser;
import js.html.Element;
import js.html.Text;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	public static var currentTime:Float;
	public static var pluginsTestingData:String = "  - cd plugins";
	public static var window:Dynamic;
	
	static function main() 
	{
		var gui:Dynamic = js.Node.require('nw.gui');
		window = gui.Window.get();
		
		window.showDevTools();
		
		js.Node.process.on('uncaughtException', function (err)
		{
			trace(err);
		}
		);
		
		Browser.window.addEventListener("load", function (e):Void
		{
			//window.show();
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
			
		var pathToPluginsMTime:String = js.Node.path.join("..", "pluginsMTime.dat");
		
		var args:Array<String>;
		
		if (js.Node.fs.existsSync(pathToPluginsMTime))
		{
			var data:String = js.Node.fs.readFileSync(pathToPluginsMTime, js.Node.NodeC.UTF8);
			HIDE.pluginsMTime = Unserializer.run(data);
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
								//&& !Lambda.has(HIDE.conflictingPlugins, pluginName)
								else if (item == "plugin.hxml" && !Lambda.has(HIDE.inactivePlugins, pluginName))
								{	
									var levels:String = "";
									for (i in 0...pathToPlugin.split("\\").length)
									{
										levels += "../";
									}
									
									pluginsTestingData += "\n  - cd " + StringTools.replace(pathToPlugin, "\\", "/") + "\n  - haxe plugin.hxml\n  - cd " + levels;
									
									//js.Node.fs.readFile(js.Node.path.join(path, pathToPlugin, item), js.Node.NodeC.UTF8, function (error, data):Void
									//{
										//if (pluginsTestingData != "")
										//{
											//pluginsTestingData += "--next\n";
										//}
										//
										//var currentLine:String;
										//
										//for (line in data.split("\n"))
										//{		
											//currentLine = line;
											//
											//for (argument in ["-cp", "-js"])
											//{
												//if (StringTools.startsWith(line, argument))
												//{												
													//currentLine = argument + " " + js.Node.path.join("plugins", pathToPlugin, line.substr(4));
												//}
											//}
											//
											//pluginsTestingData += currentLine + "\n";
										//}
										
										//pluginsTestingData += data;
									//}
									//);
									
									//pluginsTestingData += "\n    - pushd " + StringTools.replace(js.Node.path.join("plugins", pathToPlugin), js.Node.path.sep, "/") + " && haxe plugin.hxml && popd";
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
		
		var haxeCompilerProcess:js.Node.NodeChildProcess = js.Node.childProcess.exec(command, { }, function (err, stdout, stderr)
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
					textarea.style.position = "fixed";
					textarea.style.width = "100%";
					textarea.style.height = "15%";
					textarea.style.backgroundColor = "darkseagreen";
					textarea.style.opacity = "0.8";
					textarea.style.bottom = "0";
					textarea.style.zIndex = "10000";
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