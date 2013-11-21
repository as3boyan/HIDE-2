package ;
import js.Browser;
import js.html.DivElement;
import js.html.HtmlElement;

/**
 * ...
 * @author AS3Boyan
 */

//Plugin is based on https://github.com/shagstrom/split-pane
class Main
{
	public static var name:String = "boyan.split-pane";
	public static var dependencies:Array<String> = ["boyan.jquery"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		//Will wait for boyan.jquery plugin
		HIDE.waitForDependentPluginsToBeLoaded(dependencies, load);
		
		//CSS doesn't depend on plugins and can be loaded anytime
		HIDE.loadCSS(name, "bin/includes/css/split-pane.css");
	}
	
	private static function load():Void
	{
		//Load split-pane
		HIDE.loadJS(name, "bin/includes/js/split-pane.js", function ():Void
		{
			//split-pane should be ready to use
			
			//Basic example from https://github.com/shagstrom/split-pane
			//<div class="split-pane fixed-left">
				//<div class="split-pane-component" id="left-component">
					//This is the left component
				//</div>
				//<div class="split-pane-divider" id="my-divider"></div>
				//<div class="split-pane-component" id="right-component">
					//This is the right componento
				//</div>
			//</div>
			
			//$('div.split-pane').splitPane();
			
			var htmlElement:HtmlElement = cast(Browser.document.documentElement, HtmlElement);
			htmlElement.style.height = "100%";
			
			Browser.document.body.style.height = "100%";
			
			var splitPane:DivElement = Splitpane.createSplitPane("left");
			splitPane.style.marginTop = "51px";
			
			var leftComponent:DivElement = Splitpane.createComponent();
			leftComponent.style.width = "150px";
			splitPane.appendChild(leftComponent);
			
			var divider:DivElement = Splitpane.createDivider();
			divider.style.left = "150px";
			splitPane.appendChild(divider);
			
			var rightComponent:DivElement = Splitpane.createComponent();
			rightComponent.style.left = "150px";
			rightComponent.style.marginLeft = "5px";
			splitPane.appendChild(rightComponent);
			
			Browser.document.body.appendChild(splitPane);
			
			//Split-pane is a plugin for JQuery, so it extends JQuery with additional function splitPane, which is responsible for creating split panes
			untyped __js__("$('div.split-pane').splitPane()");
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.plugins.push(name);
		}
		);
	}
	
}