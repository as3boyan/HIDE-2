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
		
		Browser.document.onclick = function (e:MouseEvent)
		{
			contextMenu.style.display = "none";
		};
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.className = "dropdown-menu";
		ul.style.display = "block";
		
		ul.appendChild(createContextMenuItem("New File...", TabManager.createFileInNewTab));
		
		var li:LIElement = Browser.document.createLIElement();
		li.className = "divider";
		
		ul.appendChild(li);
		ul.appendChild(createContextMenuItem("Close", function ()
		{
				TabManager.closeTab(contextMenu.getAttribute("path"));
		}
		));
		ul.appendChild(createContextMenuItem("Close All", function ()
		{
				TabManager.closeAll();
		}
		));
		
		ul.appendChild(createContextMenuItem("Close Other", function ()
		{
				var path = contextMenu.getAttribute("path");
				TabManager.closeOthers(path);
		}
		));
		
		contextMenu.appendChild(ul);
		
		Browser.document.body.appendChild(contextMenu);
		
		TabManager.tabs.addEventListener('contextmenu', function(ev:MouseEvent) 
		{ 
			ev.preventDefault();
			
			var clickedOnTab:Bool = false;
			
			for (li in TabManager.tabs.childNodes)
			{
				if (ev.target == li)
				{
					clickedOnTab = true;
					break;
				}
			}
			
			if (clickedOnTab)
			{
				var li:LIElement = cast(ev.target, LIElement);
				contextMenu.setAttribute("path", li.getAttribute("path"));
				
				contextMenu.style.display = "block";
				contextMenu.style.left = Std.string(ev.pageX) + "px";
				contextMenu.style.top = Std.string(ev.pageY) + "px";
			}
			
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