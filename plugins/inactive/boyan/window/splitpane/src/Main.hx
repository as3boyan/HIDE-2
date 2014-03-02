package ;
import js.Browser;
import js.html.DivElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.window.splitpane";
	public static var dependencies:Array<String> = [];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		Splitpane.components = [];
		
		for (i in 0...5)
		{
			var div:DivElement = Browser.document.createDivElement();
			//div.style.resize = "both";
			//div.style.width = "100px";
			div.style.height = "100%";
			div.style.float = "left";
			//div.style.overflow = "auto";
			//div.style.border = "2px solid";
			Splitpane.components.push(div);
			Browser.document.body.appendChild(div);
		}
		
		Splitpane.components[0].style.width = "30%";
		Splitpane.components[1].style.width = "30%";
		Splitpane.components[2].style.width = "30%";
		Splitpane.components[3].style.width = "30%";
		Splitpane.components[4].style.width = "30%";
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}