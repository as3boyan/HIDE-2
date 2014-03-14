package ;
import js.Browser;
import js.html.WheelEvent;
import jQuery.JQuery;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.codemirror.zoom";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{		
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			Browser.document.addEventListener("mousewheel", function(e:WheelEvent)
			{
				if (e.altKey)
				{
					if (e.wheelDeltaY < 0)
					{
						var fontSize:Int = Std.parseInt(new JQuery(".CodeMirror").css("font-size"));
						fontSize--;
						setFontSize(fontSize);
						e.preventDefault(); 
						e.stopPropagation(); 
					}
					else if (e.wheelDeltaY > 0)
					{
						var fontSize:Int = Std.parseInt(new JQuery(".CodeMirror").css("font-size"));
						fontSize++;
						setFontSize(fontSize);
						e.preventDefault(); 
						e.stopPropagation(); 
					}
				}
			}
			);
			
			BootstrapMenu.getMenu("View").addMenuItem("Increase Font Size", 10001, function ()
			{
				var fontSize:Int = Std.parseInt(new JQuery(".CodeMirror").css("font-size"));
				fontSize++;
				setFontSize(fontSize);
			}
			, "Ctrl-+");
			
			BootstrapMenu.getMenu("View").addMenuItem("Decrease Font Size", 10002, function ()
			{
				var fontSize:Int = Std.parseInt(new JQuery(".CodeMirror").css("font-size"));
				fontSize--;
				setFontSize(fontSize);
			}
			, "Ctrl--");
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
	public static function setFontSize(fontSize:Int):Void
	{
		new JQuery(".CodeMirror").css("font-size", Std.string(fontSize) + "px");
		new JQuery(".CodeMirror-hint").css("font-size", Std.string(fontSize - 2) + "px");
		new JQuery(".CodeMirror-hints").css("font-size", Std.string(fontSize - 2) + "px");
	}
	
}