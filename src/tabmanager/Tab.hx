package tabmanager;
import js.Browser;
import js.html.LIElement;
import js.html.SpanElement;
import js.Node;
import watchers.LocaleWatcher;
import watchers.Watcher;

/**
 * ...
 * @author 
 */
class Tab
{
	public var name:String;
	public var path:String;
	public var doc:CodeMirror.Doc;
	var li:LIElement;
	var span3:SpanElement;
	var watcher:Dynamic;
	var ignoreNextUpdate:Bool;

	public function new(_name:String, _path:String, _doc:CodeMirror.Doc, ?_save:Bool) 
	{
		ignoreNextUpdate = false;
		
		name = _name;
		doc = _doc;
		path = _path;
		
		li = Browser.document.createLIElement();
		li.title = path;
		li.setAttribute("path", path);
		
		span3 = Browser.document.createSpanElement();
		span3.textContent = name + "\t";
		span3.addEventListener("click", function (e):Void 
		{
			TabManager.selectDoc(path);
		}
		);
		
		li.addEventListener("contextmenu", function (e):Void 
		{
			ContextMenu.showMenu(path, e);
		}
		);
		
		li.appendChild(span3);
		
		var span:SpanElement = Browser.document.createSpanElement();
		span.style.position = "relative";
		span.style.top = "2px";

		span.addEventListener("click", function (e):Void 
		{
			TabManager.closeTab(path);
		}
		);

		var span2:SpanElement = Browser.document.createSpanElement();
		span2.className = "glyphicon glyphicon-remove-circle";
		span.appendChild(span2);

		li.appendChild(span);
		
		if (_save) 
		{
			save();
		}
		
		startWatcher();
	}
	
	public function startWatcher():Void
	{
		watcher = Watcher.watchFileForUpdates(path, function ():Void 
		{			
			if (!ignoreNextUpdate) 
			{
				Alertify.confirm(LocaleWatcher.getStringSync("File ") + path + LocaleWatcher.getStringSync(" was changed. Reload?"), function (e)
				{
					if (e != null) 
					{
						TabManager.openFile(path, function (code:String):Void 
						{
							doc.setValue(code);
							doc.clearHistory();
							setChanged(false);
						}
						);
					}
				}
				);
			}
			else 
			{
				
				ignoreNextUpdate = false;
			}
		}
		);
	}
	
	public function setChanged(changed:Bool):Void
	{
		span3.textContent = name;
		
		if (changed) 
		{
			span3.textContent += "*";
		}
		
		span3.textContent += "\n";
	}
	
	public function remove():Void
	{
		li.remove();
		
		if (watcher != null) 
		{
			watcher.close();
		}
	}
	
	public function save():Void 
	{
		ignoreNextUpdate = true;
		
		Node.fs.writeFileSync(path, doc.getValue(), NodeC.UTF8);
		doc.clearHistory();
		setChanged(false);
	}
	
	public function getElement():LIElement
	{
		return li;
	}
	
}