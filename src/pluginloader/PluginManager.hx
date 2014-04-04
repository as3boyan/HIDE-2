package pluginloader;
import haxe.ds.StringMap;
import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import js.Browser;
import js.html.Element;
import js.html.TextAreaElement;
import js.Node;
import mustache.Mustache;

/**
 * ...
 * @author 
 */

typedef PluginDependenciesData =
{
	var name:String;
	var plugins:Array<String>;
	var onLoaded:Void->Void;
	var callOnLoadWhenAtLeastOnePluginLoaded:Bool;
}
 
class PluginManager
{
	public static var plugins:Array<String> = new Array();
	public static var pathToPlugins:StringMap<String> = new StringMap();
	public static var inactivePlugins:Array<String> = [];
	
	public static var requestedPluginsData:Array<PluginDependenciesData> = new Array();
	
	public static var pluginsMTime:StringMap<Int> = new StringMap();
	
	public static var firstRun:Bool = false;
	
	public static var pluginsTestingData:String = "  - cd plugins";
	
	public static function loadPlugins(?compile:Bool = true):Void
	{
		var pathToPluginsFolder:String = "plugins";
		
		if (!Node.fs.existsSync(pathToPluginsFolder)) 
		{
			Node.fs.mkdirSync(pathToPluginsFolder);
		}
		
		var pathToPluginsMTime:String = "pluginsMTime.dat";
		
		var args:Array<String>;
		
		if (Node.fs.existsSync(pathToPluginsMTime))
		{
			var options:NodeFsFileOptions = { };
			options.encoding = NodeC.UTF8;
			var data:String = Node.fs.readFileSync(pathToPluginsMTime, options);
			if (data != "") 
			{
				pluginsMTime = Unserializer.run(data);
			}
		}
		else 
		{
			firstRun = true;
		}
		
		readDir(pathToPluginsFolder, "", function (path:String, pathToPlugin:String):Void
		{
			var pluginName:String = StringTools.replace(pathToPlugin, Node.path.sep, ".");
			
			var relativePathToPlugin:String = Node.path.join(path, pathToPlugin);
			
			//Store path to plugin, so we can load JS and CSS scripts by specifying path relative to plugin's directory
			pathToPlugins.set(pluginName, relativePathToPlugin);
			
			var absolutePathToPlugin:String = Node.require("path").resolve(relativePathToPlugin);
			
			if (firstRun)
			{
				pluginsMTime.set(pluginName, Std.parseInt(Std.string(Date.now().getTime())));
			}
			
			if (compile && (!pluginsMTime.exists(pluginName) || pluginsMTime.get(pluginName) < walk(absolutePathToPlugin)))
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
			if (requestedPluginsData.length > 0)
			{
				trace("still not loaded plugins: ");
			
				for (pluginData in requestedPluginsData)
				{
					trace(pluginData.name + ": can't load plugin, required plugins are not found");
					trace(pluginData.plugins);
				}
				
				savePluginsMTime();
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
								else if (item == "plugin.hxml" && !Lambda.has(inactivePlugins, pluginName))
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
		var pathToBin:String =  Node.path.join(pathToPlugin, "bin");
		
		Node.fs.exists(pathToBin, function (exists:Bool)
		{
			if (exists)
			{
				startPluginCompilation(name, pathToPlugin, onSuccess, onFailed);
			}
			else 
			{
				Node.fs.mkdir(pathToBin, function (error):Void
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
				pluginsMTime.set(name, Std.parseInt(Std.string(Date.now().getTime())));
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
	
	static function checkRequiredPluginsData():Void
	{		
		if (requestedPluginsData.length > 0)
		{
			var pluginData:PluginDependenciesData;
		
			var j:Int = 0;
			while (j < requestedPluginsData.length)
			{
				pluginData = requestedPluginsData[j];
				
				var pluginsLoaded:Bool;
				
				if (pluginData.callOnLoadWhenAtLeastOnePluginLoaded == false)
				{
					pluginsLoaded = Lambda.foreach(pluginData.plugins, function (plugin:String):Bool
					{
						return Lambda.has(plugins, plugin);
					}
					);
				}
				else 
				{
					pluginsLoaded = !Lambda.foreach(pluginData.plugins, function (plugin:String):Bool
					{
						return !Lambda.has(plugins, plugin);
					}
					);
				}
				
				if (pluginsLoaded)
				{
					requestedPluginsData.splice(j, 1);
					trace(pluginData.name);
					pluginData.onLoaded();
				}
				else 
				{
					j++;
				}
			}
		}
		
		if (Lambda.count(pathToPlugins) == plugins.length)
		{			
			trace("all plugins loaded");
			
			var delta:Float = Date.now().getTime() - Main.currentTime;
			
			trace("Loading took: " + Std.string(delta) + " ms");
			
			var options:js.Node.NodeFsFileOptions = { };
			options.encoding = js.Node.NodeC.UTF8;
			js.Node.fs.readFile("../.travis.yml.template", options, function(error, data:String):Void
			{
				if (data != null)
				{
					var updatedData:String = Mustache.render(data, {plugins: pluginsTestingData});

					js.Node.fs.writeFile("../.travis.yml", updatedData,js.Node.NodeC.UTF8, function(error):Void
					{
						trace(".travis.yml was updated according to active plugins list");
					}
					);
					
				}
				else
				{
					trace(error);
				}
			}
			);
			
			savePluginsMTime();
		}
	}
	
	public static function savePluginsMTime() 
	{
		var pathToPluginsMTime:String = js.Node.path.join("..", "pluginsMTime.dat");
			
		var data:String = Serializer.run(pluginsMTime);
		
		Node.fs.writeFile(pathToPluginsMTime, data, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
		{
			
		}
		);
	}
	
	public static function waitForDependentPluginsToBeLoaded(name:String, plugins:Array<String>, onLoaded:Void->Void, ?callOnLoadWhenAtLeastOnePluginLoaded:Bool = false):Void
	{	
		var data:PluginDependenciesData = { name:name, plugins:plugins, onLoaded:onLoaded, callOnLoadWhenAtLeastOnePluginLoaded:callOnLoadWhenAtLeastOnePluginLoaded };
		requestedPluginsData.push(data);
		checkRequiredPluginsData();
	}
	
	public static function notifyLoadingComplete(name:String):Void
	{
		plugins.push(name);
		checkRequiredPluginsData();
	}
	
	public static function compilePlugins(?onComplete:Dynamic, ?onFailed:Dynamic):Void
	{
		var pluginCount:Int = Lambda.count(pathToPlugins);
		var compiledPluginCount:Int = 0;

		var relativePathToPlugin:String;
		var absolutePathToPlugin:String;

		if (pluginCount > 0) 
		{
			for (name in pathToPlugins.keys())
			{
				relativePathToPlugin = pathToPlugins.get(name);
				absolutePathToPlugin = Node.require("path").resolve(relativePathToPlugin);

				PluginManager.compilePlugin(name, absolutePathToPlugin, function ():Void
				{
					compiledPluginCount++;

					if (compiledPluginCount == pluginCount)
					{
						onComplete();
					}
				}
				, onFailed);
			}
		}
		else 
		{
			onComplete();
		}
	}
}