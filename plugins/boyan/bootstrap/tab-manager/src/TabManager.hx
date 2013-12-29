package ;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.Element;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.SpanElement;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */
class TabManager
{
	public static var tabs:UListElement;
	
	public static function init():Void
	{
		//<ul class="tabs" id="docs" style="-webkit-touch-callout: none; -webkit-user-select: none; user-select: none;"></ul>
		
		tabs = Browser.document.createUListElement();
		tabs.className = "tabs no-select";
		
		tabs.onclick = function(e):Void
		{
			var target:Dynamic = e.target || e.srcElement;
			if (target.nodeName.toLowerCase() != "li") return;

			var i = 0;
			var c:Dynamic = target.parentNode.firstChild;

			if (c == target)
			{
				return TabManager.selectDoc(0);
			}
			else
			{
				while (true)
				{
					i++;
					c = c.nextSibling;
					if (c == target) return TabManager.selectDoc(i);
				}
			}                        
		};
		
		ContextMenu.createContextMenu();
		
		createNewTab("test");
		
		Splitpane.components[1].appendChild(tabs);
	}
	
	public static function createNewTab(name:String):Void
	{
		var li:LIElement = Browser.document.createLIElement();
		//li.title = path;
		li.innerText = name + "\t";
		//li.setAttribute("path", path);

		var span:SpanElement = Browser.document.createSpanElement();
		span.style.position = "relative";
		span.style.top = "2px";

		span.onclick = function (e):Void
		{
			//closeTab(path);
		}

		var span2:SpanElement = Browser.document.createSpanElement();
		span2.className = "glyphicon glyphicon-remove-circle";
		span.appendChild(span2);

		li.appendChild(span);

		tabs.appendChild(li);
	}
	
	public static function selectDoc(pos:Int):Void
	{
		for (i in 0...tabs.childNodes.length)
		{
			var child:Element = cast(tabs.childNodes[i], Element);
          
			if (pos == i)
			{
				child.className = "selected";
			}
			else
			{
				child.className = "";
			}
		}
	}
}