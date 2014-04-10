package dialogs;
import bootstrap.InputGroupButton;
import bootstrap.ListGroup;
import core.HaxeHelper;
import core.ProcessHelper;
import js.Browser;
import js.html.Event;

/**
 * ...
 * @author AS3Boyan
 */
class HaxelibManagerDialog extends ModalDialog
{

	public function new() 
	{
		super("haxelib manager");
		
		var inputGroupButton:InputGroupButton = new InputGroupButton("Search");
		
		getBody().appendChild(inputGroupButton.getElement());
		
		var listGroup = new ListGroup();
		
		HaxeHelper.getHaxelibList(function (data:Array<String>):Void 
		{
			for (item in data)
			{
				listGroup.addItem(item, "");
			}
		}
		);
		
		getBody().appendChild(listGroup.getElement());
		
		//Browser.window.addEventListener("resize", function (e:Event):Void 
		//{
			//listGroup.getElement().style.height = Browser.window.innerHeight / 2 + "px";
		//}
		//);
	}
	
}