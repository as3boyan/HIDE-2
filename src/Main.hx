package ;

import jQuery.JQueryStatic;
import js.Browser;
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
			
		};
	}
	
	public static function loadJS(url:String):Void
	{
		//"./includes/js/"
		JQueryStatic.getScript(url, function (data, status, jqXhr)
		{
			trace(data);
			trace(status);
			trace(jqXhr.status);
		}
		);
	}
	
	public static function loadCSS(url:String):Void
	{
		var link:LinkElement = Browser.document.createLinkElement();
		link.href = url;
		link.type = "text/css";
		link.rel = "stylesheet";
		
		Browser.document.head.appendChild(link);
	}
	
	public static function registerHotkey(hotkey:String, functionName:String):Void
	{
		
	}
	
}