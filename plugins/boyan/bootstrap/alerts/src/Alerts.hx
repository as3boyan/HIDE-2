package ;
import jQuery.JQuery;
import haxe.Timer;
import js.Browser;
import js.html.ButtonElement;
import js.html.DivElement;

/**
 * ...
 * @author AS3Boyan
 */

@:keepSub @:expose class Alerts
{	
	public static function showAlert(text:String):Void
	{
		var div:DivElement = Browser.document.createDivElement();
		div.className = "alert alert-success alert-dismissable";
		div.style.position = "fixed";
		div.style.zIndex = "10000";
		div.style.top = "50%";
		div.style.left = "50%";
		
		var button:ButtonElement = Browser.document.createButtonElement();
		button.type = "button";
		button.className = "close";
		button.setAttribute("data-dismiss", "alert");
		button.setAttribute("aria-hidden", "true");
		button.innerHTML = "&times;";
		
		div.appendChild(button);
		div.appendChild(Browser.document.createTextNode(text));
		
		Browser.document.body.appendChild(div);
		
		div.style.marginTop = Std.string(Std.int(-div.clientHeight / 2)) + "px";
		div.style.marginLeft  = Std.string(Std.int(-div.clientWidth / 2)) + "px";
		//new JQuery("#notify_position").html(div.outerHTML);
		
		Timer.delay(function ()
		{
			if (div.parentElement != null) 
			{
				new JQuery(div).fadeOut(500, function ()
				{
					Browser.document.body.removeChild(div);
				});
			}
		}
		, 1500);
	}
}
