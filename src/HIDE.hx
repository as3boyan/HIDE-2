package ;

/**
 * ...
 * @author AS3Boyan
 */
 
@keepSub @expose class HIDE
{	
	public static function loadJS(url:String):Void
	{
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
	
	public static function registerHotkeyByCode(code:Int, functionName:String):Void
	{
		Browser.document.addEventListener("keyup", function (e:KeyboardEvent)
		{
			if (e.keyCode == code)
			{
				new JQuery().triggerHandler(functionName);
			}
		}
		);
	}
	
}