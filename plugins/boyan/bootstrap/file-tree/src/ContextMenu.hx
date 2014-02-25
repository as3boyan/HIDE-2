package ;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */
class ContextMenu
{

	public function new() 
	{
		
	}
	
	public static function createContextMenu():Void
	{
		var contextMenu:DivElement = Browser.document.createDivElement();
		contextMenu.className = "dropdown";
		contextMenu.style.position = "absolute";
		contextMenu.style.display = "none";
		
		Browser.document.addEventListener("click", function (e:MouseEvent)
		{
			contextMenu.style.display = "none";
		}
		);
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.className = "dropdown-menu";
		ul.style.display = "block";
		
		ul.appendChild(createContextMenuItem("Refresh", FileTree.load));
		
		contextMenu.appendChild(ul);
		
		Browser.document.body.appendChild(contextMenu);
		
		FileTree.treeWell.addEventListener('contextmenu', function(ev:MouseEvent) 
		{ 
			ev.preventDefault();
						
			contextMenu.style.display = "block";
			contextMenu.style.left = Std.string(ev.pageX) + "px";
			contextMenu.style.top = Std.string(ev.pageY) + "px";
			
			return false;
		}
		);
	}
	
	public static function createContextMenuItem(text:String, onClick:Dynamic):LIElement
	{
		var li:LIElement = Browser.document.createLIElement();
		li.onclick = function (e:MouseEvent):Void
		{
			onClick();
		};
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.href = "#";
		a.textContent = text;
		li.appendChild(a);
		
		return li;
	}
}