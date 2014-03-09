package ;
import haxe.ds.StringMap.StringMap;
import haxe.Serializer;
import js.Browser;
import js.html.LinkElement;
import js.html.ScriptElement;

/**
 * ...
 * @author AS3Boyan
 */
 
 //This class is a global HIDE API for plugins
 //Using this API plugins can load JS and CSS scripts in specified order 
 //To use it in plugins you may need to add path to externs for this class, they are located at externs/plugins/hide
 
typedef PluginDependenciesData =
{
	var name:String;
	var plugins:Array<String>;
	var onLoaded:Void->Void;
	var callOnLoadWhenAtLeastOnePluginLoaded:Bool;
}
 
@:keepSub @:expose class HIDE
{	
	public static var plugins:Array<String> = new Array();
	public static var pathToPlugins:StringMap<String> = new StringMap();
	//"boyan.bootstrap.script"
	public static var inactivePlugins:Array<String> = [];
	//public static var conflictingPlugins:Array<String> = [];
	
	public static var requestedPluginsData:Array<PluginDependenciesData> = new Array();
	
	public static var pluginsMTime:StringMap<Int> = new StringMap();
	
	public static var windows:Array<Dynamic> = [];
	
	public static var firstRun:Bool = false;
	
	//Loads JS scripts in specified order and calls onLoad function when last item of urls array was loaded
	public static function loadJS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void
	{		
		if (name != null)
		{
			for (i in 0...urls.length)
			{
				urls[i] = js.Node.path.join(getPluginPath(name), urls[i]);
			}
		}

		loadJSAsync(name, urls, onLoad);
	}
	
	//Asynchronously loads multiple CSS scripts
	public static function loadCSS(name:String, urls:Array<String>, ?onLoad:Dynamic):Void
	{
		if (name != null)
		{
			for (i in 0...urls.length)
			{
				urls[i] = js.Node.path.join(getPluginPath(name), urls[i]);
			}
		}

		loadCSSAsync(name, urls, onLoad);
	}
	
	private static function loadCSSAsync(name:String, urls:Array<String>, ?onLoad:Dynamic):Void
	{
		var link:LinkElement = Browser.document.createLinkElement();
		link.href = urls.splice(0, 1)[0];
		link.type = "text/css";
		link.rel = "stylesheet";
		link.onload = function (e)
		{
			traceScriptLoadingInfo(name, link.href);
			
			if (urls.length > 0)
			{
				loadCSSAsync(name, urls, onLoad);
			}
			else if (onLoad != null)
			{
				onLoad();
			}
		};
		
		Browser.document.head.appendChild(link);
	}	
	
	private static function traceScriptLoadingInfo(name:String, url:String):Void
	{
		var str:String;
				
		if (name != null)
		{
			str = "\n" + name + ":\n" + url + "\n";
		}
		else 
		{
			str = url + " loaded";
		}
		
		trace(str);
	}
	
	public static function getPluginPath(name:String):String
	{
		var pathToPlugin:String = pathToPlugins.get(name);
				
		if (pathToPlugin == null)
		{
			trace("HIDE can't find path for plugin: " + name + "\nPlease check folder structure of plugin, make sure that it corresponds to it's 'name'");
		}
		
		return pathToPlugin;
	}
	
	public static function waitForDependentPluginsToBeLoaded(name:String, plugins:Array<String>, onLoaded:Void->Void, ?callOnLoadWhenAtLeastOnePluginLoaded:Bool = false):Void
	{	
		var data:PluginDependenciesData = { name:name, plugins:plugins, onLoaded:onLoaded, callOnLoadWhenAtLeastOnePluginLoaded:callOnLoadWhenAtLeastOnePluginLoaded };
		requestedPluginsData.push(data);
		checkRequiredPluginsData();
	}
	
	public static function notifyLoadingComplete(name:String):Void
	{
		//trace("Object " + name);
		plugins.push(name);
		checkRequiredPluginsData();
	}
	
	public static function openPageInNewWindow(name:String, url:String, ?params:Dynamic):Dynamic
	{	
		var fullPath:String = url;
		
		if (!StringTools.startsWith(url, "http") && name != null)
		{
			fullPath = js.Node.path.join(getPluginPath(name), url);
		}
		
		var window = js.Node.require("nw.gui").Window.open(fullPath, params);
		windows.push(window);
		
		window.on("close", function (e):Void
		{
			windows.remove(window);
			window.close(true);
		}
		);
		
		return window;
	}

	public static function compilePlugins(?onComplete:Dynamic, ?onFailed:Dynamic):Void
	{
		var pluginCount:Int = Lambda.count(HIDE.pathToPlugins);
		var compiledPluginCount:Int = 0;

		var relativePathToPlugin:String;
		var absolutePathToPlugin:String;

		for (name in HIDE.pathToPlugins.keys())
		{
			relativePathToPlugin = HIDE.pathToPlugins.get(name);
			absolutePathToPlugin = js.Node.require("path").resolve(relativePathToPlugin);

			Main.compilePlugin(name, absolutePathToPlugin, function ():Void
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
	
	public static function readFile(name:String, path:String, onComplete:Dynamic):Void
	{
		js.Node.fs.readFile(js.Node.path.join(pathToPlugins.get(name), path), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String):Void
		{
			if (error != null)
			{
				trace(error);
			}
			
			onComplete(data);
		}
		);
	}
	
	public static function writeFile(name:String, path:String, contents:String, ?onComplete:Dynamic):Void
	{
		js.Node.fs.writeFile(js.Node.path.join(pathToPlugins.get(name), path), contents, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
		{
			if (onComplete != null && error == null)
			{
				onComplete();
			}
		}
		);
	}
	
	public static function surroundWithQuotes(path:String):String
	{
		return '"' + path + '"';
	}
	
	private static function checkRequiredPluginsData():Void
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
						return Lambda.has(HIDE.plugins, plugin);
					}
					);
				}
				else 
				{
					pluginsLoaded = !Lambda.foreach(pluginData.plugins, function (plugin:String):Bool
					{
						return !Lambda.has(HIDE.plugins, plugin);
					}
					);
				}
				
				if (pluginsLoaded)
				{
					requestedPluginsData.splice(j, 1);
					//trace(pluginData);
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
			trace(requestedPluginsData.length);
			
			trace("all plugins loaded");
			
			var delta:Float = Date.now().getTime() - Main.currentTime;
			
			trace("Loading took: " + Std.string(delta) + " ms");
			
			//js.Node.fs.writeFile("../HIDEPlugins.hxml", Main.pluginsTestingData, js.Node.NodeC.UTF8, function (error):Void
			//{
				//
			//}
			//);
			
			js.Node.fs.readFile("../.travis.yml.template", js.Node.NodeC.UTF8, function(error, data:String):Void
			{
				if (data != null)
				{
					var updatedData:String = StringTools.replace(data,"::plugins::", Main.pluginsTestingData);

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
			
			Main.window.show();
		}
	}
	
	public static function savePluginsMTime() 
	{
		var pathToPluginsMTime:String = js.Node.path.join("..", "pluginsMTime.dat");
			
		var data:String = Serializer.run(HIDE.pluginsMTime);
		
		js.Node.fs.writeFile(pathToPluginsMTime, data, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
		{
			
		}
		);
	}
	
	//Private function which loads JS scripts in strict order
	private static function loadJSAsync(name:String, urls:Array<String>, ?onLoad:Dynamic):Void
	{
		var script:ScriptElement = Browser.document.createScriptElement();
		script.src = urls.splice(0, 1)[0]; //+ "?" + Std.string(Std.random(100000))
		script.onload = function (e)
		{			
			traceScriptLoadingInfo(name, script.src);
			
			if (urls.length > 0)
			{
				loadJSAsync(name, urls, onLoad);
			}
			else if (onLoad != null)
			{
				onLoad();
			}
		};
		
		Browser.document.body.appendChild(script);
	}
}