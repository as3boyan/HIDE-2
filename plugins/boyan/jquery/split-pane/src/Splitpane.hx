package ;
import js.Browser;
import js.html.DivElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class Splitpane
{
	public static var components:Array<DivElement> = new Array();
	
	public static function createSplitPane(fixedSide:String):DivElement
	{
		var splitPaneDiv:DivElement = Browser.document.createDivElement();
		splitPaneDiv.className = "split-pane fixed-" + fixedSide;
		return splitPaneDiv;
	}
	
	public static function createComponent():DivElement
	{
		var splitPaneComponent:DivElement = Browser.document.createDivElement();
		splitPaneComponent.className = "split-pane-component";
		components.push(splitPaneComponent);
		return splitPaneComponent;
	}
	
	public static function createDivider():DivElement
	{
		var divider:DivElement = Browser.document.createDivElement();
		divider.className = "split-pane-divider";
		divider.style.background = "#aaa";
		divider.style.width = "5px";
		return divider;
	}
}