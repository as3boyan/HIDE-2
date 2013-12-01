package ;
import haxe.ds.StringMap.StringMap;
import haxe.Timer;
import js.Browser;
import js.html.KeyboardEvent;
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
	public static var inactivePlugins:Array<String> = ["boyan.ace.editor", "boyan.jquery.split-pane"];
	//public static var conflictingPlugins:Array<String> = [];
	
	public static var requestedPluginsData:Array<PluginDependenciesData> = new Array();
	
	public static var windows:Array<Dynamic> = [];
	
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
		var url:String;
		
		for (i in 0...urls.length)
		{			
			url = urls[i];
			
			if (name != null)
			{
				url = js.Node.path.join(getPluginPath(name), url);
			}
			
			var link:LinkElement = Browser.document.createLinkElement();
			link.href = url;
			link.type = "text/css";
			link.rel = "stylesheet";
			link.onload = function (e)
			{
				traceScriptLoadingInfo(name, url);
				
				if (i == urls.length - 1 && onLoad != null)
				{
					onLoad();
				}
			};
			Browser.document.head.appendChild(link);
		}
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
	
	private static function getPluginPath(name):String
	{
		var pathToPlugin:String = pathToPlugins.get(name);
				
		if (pathToPlugin == null)
		{
			trace("HIDE can't find path for plugin: " + name + "\nPlease check that folder structure of plugin corresponds to it's 'name'");
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
		plugins.push(name);
		checkRequiredPluginsData();
	}
	
	public static function openPageInNewWindow(name:String, url:String, ?params:Dynamic):Dynamic
	{
		var window = js.Node.require("nw.gui").Window.open(js.Node.path.join(getPluginPath(name), url), params);
		windows.push(window);
		
		window.on("close", function (e):Void
		{
			windows.remove(window);
			window.close(true);
		}
		);
		
		return window;
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
					pluginData.onLoaded();
				}
				else 
				{
					j++;
				}
			}
		}
		else 
		{
			if (Lambda.count(pathToPlugins) == plugins.length)
			{
				trace("all plugins loaded");
				
				var delta:Float = Date.now().getTime() - Main.currentTime;
				
				trace("Loading took: " + Std.string(delta) + " ms");
			}
		}
	}
	
	//Private function which loads JS scripts in strict order
	private static function loadJSAsync(name:String, urls:Array<String>, ?onLoad:Dynamic):Void
	{
		var script:ScriptElement = Browser.document.createScriptElement();
		script.src = urls.splice(0, 1)[0];
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
	
	public static function registerHotkey(hotkey:String, functionName:String):Void
	{
		
	}
	
	public static function registerHotkeyByKeyCode(code:Int, functionName:String):Void
	{
		Browser.window.addEventListener("keyup", function (e:KeyboardEvent)
		{
			if (e.keyCode == code)
			{
				//new JQuery().triggerHandler(functionName);
			}
			
			//trace(e.keyCode);
		}
		);
	}
	
}