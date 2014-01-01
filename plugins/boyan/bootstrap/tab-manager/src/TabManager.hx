package ;
import haxe.Timer;
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
@:keepSub @:expose class TabManager
{
	public static var tabs:UListElement;
	public static var curDoc:CMDoc;
	private static var docs:Array<CMDoc>;
	public static var editor:Dynamic;
	
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
		
		docs = [];
		
		Splitpane.components[1].appendChild(tabs);
	}
	
	public static function createNewTab(name:String, path:String):Void
	{
		var li:LIElement = Browser.document.createLIElement();
		li.title = path;
		li.innerText = name + "\t";
		li.setAttribute("path", path);

		var span:SpanElement = Browser.document.createSpanElement();
		span.style.position = "relative";
		span.style.top = "2px";

		span.onclick = function (e):Void
		{
			TabManager.closeTab(path);
		}

		var span2:SpanElement = Browser.document.createSpanElement();
		span2.className = "glyphicon glyphicon-remove-circle";
		span.appendChild(span2);

		li.appendChild(span);

		tabs.appendChild(li);
	}
	
	public static function openFileInNewTab(path:String):Void
	{
		if (isAlreadyOpened(path))
		{
			return;
		}
		
		js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, code:String):Void
		{
			if (error != null)
			{
				trace(error);
			}
			
			var mode:String = getMode(path);
			var name:String = js.Node.path.basename(path);
			
			docs.push(new CMDoc(name, new CodeMirror.Doc(code, mode), path));
			
			createNewTab(name, path);
			
			selectDoc(docs.length - 1);
			
			checkTabsCount();
		}
		);
	}
	
	public static function createFileInNewTab():Void
	{
		FileDialog.saveFile(function (path:String)
		{			
			//var path:String = convertPathToUnixFormat(value);
	
			//if (isAlreadyOpened(path))
			//{
				//return;
			//}
			
			var name:String = js.Node.path.basename(path);
			var mode:String = getMode(name);
			
			var code:String = "";
			
			if (js.Node.path.extname(name) == ".hx")
			{
				path = path.substr(0, path.length - name.length) + name.substr(0, 1).toUpperCase() + name.substr(1); // + Utils.capitalize(name)
				
				code = "package ;\n\nclass " + js.Node.path.basename(name) + "\n{\n\n}";
			}
			
			docs.push(new CMDoc(name, new CodeMirror.Doc(code, mode), path));
			
			createNewTab(name, path);
			
			selectDoc(docs.length - 1);
			
			checkTabsCount();
		}
		);
	}
	
	private static function checkTabsCount():Void
	{
		if (editor != null)
		{				
			if (editor.getWrapperElement().style.display == "none" && docs.length > 0)
			{
				editor.getWrapperElement().style.display = "block";

				editor.refresh();
				
				//Main.updateMenu();
			}
		}
	}
	
	public static function closeAll():Void
	{
		for (i in 0...docs.length)
		{
			if (docs[i] != null)
			{
				closeTab(docs[i].path, false);
			}
		}
		
		if (docs.length > 0)
		{
			Timer.delay(function ()
			{
				closeAll();
			}
			,30);
		}
	}
        
	public static function closeOthers(path:String):Void
	{
		for (i in 0...docs.length)
		{
			if (docs[i] != null && path != docs[i].path)
			{
				closeTab(docs[i].path, false);
			}
		}
		
		if (docs.length > 1)
		{
			Timer.delay(function ()
			{
					closeOthers(path);
			}
			,30);
		}
		else 
		{
			showNextTab();
		}
	}
	
	public static function closeTab(path:String, ?switchToTab:Bool = true):Void
	{
		for (i in 0...docs.length)
		{                                
			if (docs[i] != null && docs[i].path == path)
			{
				docs.splice(i, 1);
				cast(tabs.children.item(i), Element).remove();
			}
		}
		
		if (docs.length > 0)
		{
			if (switchToTab)
			{
				showPreviousTab();
			}
		}
		else 
		{
			if (editor != null)
			{
				editor.getWrapperElement().style.display = "none";
			}
		}
	}
	
	public static function closeActiveTab():Void
	{
		var n = Lambda.indexOf(docs, curDoc);
		docs.splice(n, 1);
		cast(tabs.children.item(n), Element).remove();
		
		if (docs.length > 0)
		{
			showPreviousTab();
		}
		else 
		{
			if (editor != null)
			{
				editor.getWrapperElement().style.display = "none";
			}
		}
	}
	
	public static function showNextTab():Void
	{
		var n = Lambda.indexOf(docs, curDoc);
		
		n++;
		
		if (n > docs.length - 1)
		{
			n = 0;
		}
		
		selectDoc(n);
	}
	
	public static function showPreviousTab():Void
	{
		var n = Lambda.indexOf(docs, curDoc);
		
		n--;
		
		if (n < 0)
		{
			n = docs.length - 1;
		}
		
		selectDoc(n);
	}

	private static function isAlreadyOpened(path:String):Bool
	{
		var opened:Bool = false;
		
		for (i in 0...docs.length)
		{
			if (docs[i].path == path)
			{
				selectDoc(i);
				opened = true;
				break;
			}
		}
		
		return opened;
	}
	
	private static function getMode(path:String):String
	{
		var mode:String = "haxe";
				
		switch (js.Node.path.extname(path)) 
		{
			case ".js":
					mode = "javascript";
			case ".css":
					mode = "css";
			case ".xml":
					mode = "xml";
			case ".html":
					mode = "text/html";
			case ".md":
					mode = "markdown";
			case ".sh", ".bat":
					mode = "shell";
			case ".ml":
					mode = "ocaml";
			default:
					
		}
		
		return mode;
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
		
		curDoc = docs[pos];
		
		if (editor != null)
		{
			editor.swapDoc(curDoc.doc);
		}
	}
}