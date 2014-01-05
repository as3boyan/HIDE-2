package ;
import haxe.Timer;
import js.Browser;
import js.html.DivElement;
import jQuery.JQuery;
import js.html.Element;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class Splitpane
{
	public static var components:Array<DivElement> = new Array();
	public static var layout:Dynamic;
	private static var panel:DivElement;
	
	public static function createSplitPane():Void
	{
		//<div id="panel" class="ui-layout-container" style="position: absolute; top: 51px;">
			//<div class="outer-center ui-layout-center">
					//<div id="sourceCodeEditor" class="middle-center ui-layout-center">
							//<ul class="tabs" id="docs" style="-webkit-touch-callout: none; -webkit-user-select: none; user-select: none;"></ul>
							//
							//<div class="ui-layout-content">
									//<textarea id='code' name='code' style="width: 100%; height: 100%;"></textarea>
							//</div>
					//</div>
					//
					//<div class="middle-south ui-layout-south">
							//<div id="output" class="ui-layout-content">
									//<textarea style="width: 100%; height: 100%; resize: none;"></textarea>
							//</div>
					//</div>
			//</div>
			//<div class="outer-west ui-layout-west">
					//<div id="tree_well" class="well" style="overflow: auto; padding: 0; margin: 0; width: 100%; height: 100%; font-size: 10pt; line-height: 1;">
							//<ul id="tree" class="nav nav-list" style="padding: 5px 0px;">
							//</ul>
					//</div>
			//</div>
		//</div>
		
		panel = Browser.document.createDivElement();
		panel.id = "panel";
		panel.className = "ui-layout-container";
		panel.style.position = "absolute";
		panel.style.top = "51px";
		
		var outerCenterPanel:DivElement = createComponent("outer", "center");
		panel.appendChild(outerCenterPanel);
		
		var middleCenterPanel:DivElement = createComponent("middle", "center");
		outerCenterPanel.appendChild(middleCenterPanel);
		
		var middleCenterPanelContent:DivElement = createContent();
		middleCenterPanel.appendChild(middleCenterPanelContent);
		
		var middleSouthPanel:DivElement = createComponent("middle", "south");
		outerCenterPanel.appendChild(middleSouthPanel);
		
		var middleSouthPanelContent:DivElement = createContent();
		middleSouthPanel.appendChild(middleSouthPanelContent);
		
		var outerWestPanel:DivElement = createComponent("outer", "west");
		panel.appendChild(outerWestPanel);
		
		var outerEastPanel:DivElement = createComponent("outer", "east");
		panel.appendChild(outerEastPanel);
		
		components.push(outerWestPanel);
		components.push(middleCenterPanelContent);
		components.push(middleSouthPanelContent);
		components.push(outerEastPanel);
		
		Browser.document.body.appendChild(panel);
	}
	
	public static function activateSplitpane():Void
	{		
		var layoutSettings = {
		center__paneSelector:        ".outer-center",
		west__paneSelector:                ".outer-west",
		west__size:                                120,
		east__paneSelector:                ".outer-east",
		east__size:                                120,
		spacing_open:                        8,  // ALL panes
		spacing_closed:                        12, // ALL panes
		
		center__childOptions: {
				center__paneSelector:        ".middle-center",
				south__paneSelector:        ".middle-south",
				south__size:                        100,
				spacing_open:                        8,  // ALL panes
				spacing_closed:                        12 // ALL panes
		}
		};
		
		layout = untyped JQuery("#panel").layout(layoutSettings);
		
		var timer:Timer = new Timer(250);
		
		timer.run = function ():Void
		{
			var treeWell:Element = Browser.document.getElementById("tree-well");
			
			if (treeWell != null)
			{				
				if (treeWell.clientHeight < 250 || treeWell.clientWidth < 80)
				{
					layout.resizeAll();
					new JQuery(Browser.window).trigger("resize");
					
					trace("layout.resizeAll()");
				}
				else 
				{
					timer.stop();
				}
			}
		};
	}
	
	public static function activateStatePreserving():Void
	{
		var localStorage = Browser.getLocalStorage();
        
        var window = js.Node.require('nw.gui').Window.get();
		
		window.on("close", function (e):Void
		{
			var stateString = js.Node.stringify(layout.readState());
			localStorage.setItem("state", stateString);
			window.close(true);
		});
		
		var state = localStorage.getItem("state");
		
		if (state != null)
		{
			layout.loadState(js.Node.parse(state));
		}
	}
	
	public static function createComponent(layout:String, side:String):DivElement
	{
		var component:DivElement = Browser.document.createDivElement();
		component.className = layout + "-" + side + " " + "ui-layout-" + side;
		return component;
	}
	
	public static function createContent():DivElement
	{
		var content:DivElement = Browser.document.createDivElement();
		content.className = "ui-layout-content";
		return content;
	}
}