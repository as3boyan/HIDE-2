package core;
import haxe.ds.StringMap.StringMap;
import js.Browser;
import js.html.KeyboardEvent;
import js.html.SpanElement;
import js.Node;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
typedef Hotkey = 
{
	var keyCode:Int;
	var ctrl:Bool;
	var shift:Bool;
	var alt:Bool;
	var onKeyDown:Dynamic;
}
 
@:keepSub @:expose("Hotkeys") class Hotkeys
{
	static var hotkeys:Array<Hotkey> = new Array();
	static var commandMap:StringMap<String> = new StringMap();
	static var spanMap:StringMap<SpanElement> = new StringMap();
	public static var data:Dynamic;
	static var pathToData:String;
	static var commandKey:Bool = Utils.os == Utils.MAC;
	
	public static function prepare():Void
	{
		pathToData = Node.path.join("core", "config","hotkeys.json");
		parseData();
		
		var options:NodeWatchOpt = { };
		options.interval = 1500;
		
		Node.fs.watchFile(pathToData, options, function (curr:NodeStat, prev:NodeStat)
		{
			if (curr.mtime != prev.mtime) 
			{
				parseData();
				hotkeys = new Array();
				
				for (key in commandMap.keys()) 
				{
					addHotkey(key);
				}
			}
		}
		);
		
		Browser.window.addEventListener("keyup", function (e:KeyboardEvent)
		{
			for (hotkey in hotkeys)
			{
				if (hotkey.keyCode == e.keyCode && hotkey.ctrl == (e.ctrlKey || (commandKey && e.metaKey)) && hotkey.shift == e.shiftKey && hotkey.alt == e.altKey)
				{
					hotkey.onKeyDown();
				}
			}
		}
		);
	}
	
	public static function add(menuItem:String, hotkeyText:String, span:SpanElement, onKeyDown:Dynamic):Void
	{
		commandMap.set(menuItem, onKeyDown);
		
		if (span != null)
		{
			spanMap.set(menuItem, span);
		}
		
		addHotkey(menuItem, hotkeyText);
	}
	
	private static function addHotkey(menuItem:String, ?hotkeyText:String = "")
	{
		if (Reflect.hasField(data, menuItem))
		{
			hotkeyText = Reflect.field(data, menuItem);
		}
		else
		{
			Reflect.setField(data, menuItem, hotkeyText);
			var data:String = TJSON.encode(data, 'fancy');
			js.Node.fs.writeFileSync(pathToData, data, js.Node.NodeC.UTF8);
		}
		
		var keyCode:Int = null;
		var ctrl:Bool = null;
		var shift:Bool = null;
		var alt:Bool = null;
		
		if (hotkeyText != "")
		{
			var hotkey:Dynamic = parseHotkey(hotkeyText);
			
			if (hotkey.keyCode != 0) 
			{
				keyCode = hotkey.keyCode;
				ctrl = hotkey.ctrl;
				shift = hotkey.shift;
				alt = hotkey.alt;
			}
			else
			{
				Browser.window.console.warn("can't assign hotkey " + hotkeyText + " for " + menuItem);
			}
		}
		
		if (spanMap.exists(menuItem)) 
		{
			
			if (commandKey) 
			{
				hotkeyText = StringTools.replace(hotkeyText, "Ctrl", "Cmd");
			}
			
			spanMap.get(menuItem).innerText = hotkeyText;
		}
		
		if (keyCode != null) 
		{
			hotkeys.push( { keyCode:keyCode, ctrl:ctrl, shift:shift, alt:alt, onKeyDown:commandMap.get(menuItem) } );
		}
	}
	
	private static function parseData():Void
	{
		var options:NodeFsFileOptions = { };
		options.encoding = js.Node.NodeC.UTF8;
		
		data = TJSON.parse(Node.fs.readFileSync(pathToData, options));
	}
	
	private static function parseHotkey(hotkey:String):Dynamic
	{
		var keys:Array<String> = hotkey.split("-");
		
		var ctrl:Bool = false;
		var shift:Bool = false;
		var alt:Bool = false;
		var keyCode:Int = 0;
		
		for (key in keys) 
		{
			switch (key.toLowerCase()) 
			{				
				case "ctrl":
					ctrl = true;
				case "shift":
					shift = true;
				case "alt":
					alt = true;
				case "f1":
					keyCode = 112;
				case "f2":
					keyCode = 113;
				case "f3":
					keyCode = 114;
				case "f4":
					keyCode = 115;
				case "f5":
					keyCode = 116;
				case "f6":
					keyCode = 117;
				case "f7":
					keyCode = 118;
				case "f8":
					keyCode = 119;
				case "f9":
					keyCode = 120;
				case "f10":
					keyCode = 121;
				case "f11":
					keyCode = 122;
				case "f12":
					keyCode = 123;
				case "tab":
					keyCode = 9;
				case "enter":
					keyCode = 13;
				case "esc":
					keyCode = 27;
				case "space":
					keyCode = 32;
				case "+":
					keyCode = 187;
				case "": 
					keyCode = 189;
				default:
					if (key.length == 1)
					{
						keyCode = key.charCodeAt(0);
					}
			}
		}
		
		return { keyCode:keyCode, ctrl: ctrl, shift: shift, alt:alt };
	}
}