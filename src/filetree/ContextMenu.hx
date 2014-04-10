package filetree;
import haxe.ds.StringMap.StringMap;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.Element;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.UListElement;
import js.Lib;
import nodejs.webkit.Shell;
import tabmanager.TabManager;
import watchers.LocaleWatcher;

/**
 * ...
 * @author AS3Boyan
 */
class ContextMenu
{
	static var itemType:String;
	static var path:String;
	static var menuItems:StringMap<LIElement>;
	
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
		
		menuItems = new StringMap();
		
		addContextMenuItemToStringMap("New File...", function ()
		{
			Alertify.prompt(LocaleWatcher.getStringSync("Filename:"), function (e:Bool, str:String)
			{
				if (e) 
				{
					var pathToFile:String = js.Node.path.join(path, str);
					TabManager.createFileInNewTab(pathToFile);
				}
			}, "New.hx");
		});
		
		addContextMenuItemToStringMap("New Folder...", function ()
		{
			Alertify.prompt("Folder name:", function (e, str:String)
			{
				if (e) 
				{
					var dirname:String = str;
			
					if (dirname != null)
					{
						js.Node.fs.mkdir(js.Node.path.join(path, dirname), function (error):Void
						{
							//FileTree.load();
						});
					}
				}
			}, "New Folder");
		});
		
		addContextMenuItemToStringMap("Open File", TabManager.openFileInNewTab.bind(path));
		addContextMenuItemToStringMap("Open using OS", Shell.openItem.bind(path));
		
		addContextMenuItemToStringMap("Show Item In Folder", Shell.showItemInFolder.bind(path));
		
		addContextMenuItemToStringMap("Hide Item", null);
		addContextMenuItemToStringMap("Show Hidden Items", null);
		
		addContextMenuItemToStringMap("Refresh", FileTree.load);
		
		ul.appendChild(menuItems.get("New File..."));
		ul.appendChild(menuItems.get("New Folder..."));
		ul.appendChild(menuItems.get("Open File"));
		ul.appendChild(menuItems.get("Open using OS"));
		ul.appendChild(menuItems.get("Show Item In Folder"));
		ul.appendChild(createSeparator());
		ul.appendChild(menuItems.get("Hide Item"));
		ul.appendChild(menuItems.get("Show Hidden Items"));
		ul.appendChild(createSeparator());
		ul.appendChild(menuItems.get("Refresh"));
		
		contextMenu.appendChild(ul);
		
		Browser.document.body.appendChild(contextMenu);
		
		//FileTree.treeWell.addEventListener('contextmenu', function(ev:MouseEvent) 
		//{ 
			//itemType = cast(ev.target, Element).getAttribute("itemType");
			//path = cast(ev.target, Element).getAttribute("path");
			//
			//menuItems.get("New File...").style.display = "none";
			//menuItems.get("New Folder...").style.display = "none";
			//menuItems.get("Open File").style.display = "none";
			//menuItems.get("Open using OS").style.display = "none";
			//menuItems.get("Show Item In Folder").style.display = "none";
			//
			//if (itemType != null) 
			//{
				//switch (itemType) 
				//{
					//case "file":
						//menuItems.get("Open File").style.display = "";
						//menuItems.get("Open using OS").style.display = "";
						//menuItems.get("Show Item In Folder").style.display = "";
					//case "folder":
						//menuItems.get("New File...").style.display = "";
						//menuItems.get("New Folder...").style.display = "";
						//menuItems.get("Show Item In Folder").style.display = "";
					//default:
						//
				//}
			//}
			//
			//ev.preventDefault();
				//
			//contextMenu.style.display = "block";
			//contextMenu.style.left = Std.string(ev.pageX) + "px";
			//contextMenu.style.top = Std.string(ev.pageY) + "px";
			//
			//return false;
		//}
		//);
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
	
	static function createSeparator():LIElement
	{
		var li:LIElement = Browser.document.createLIElement();
		li.className = "divider";
		return li;
	}
	
	static function addContextMenuItemToStringMap(text:String, ?onClick:Dynamic):Void
	{
		menuItems.set(text, createContextMenuItem(text, onClick));
	}
}