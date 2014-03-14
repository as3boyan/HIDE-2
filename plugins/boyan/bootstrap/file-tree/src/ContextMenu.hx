package ;
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

/**
 * ...
 * @author AS3Boyan
 */
class ContextMenu
{
	
	private static var itemType:String;
	private static var path:String;
	private static var menuItems:StringMap<LIElement>;
	
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
		
		menuItems = new StringMap();
		
		addContextMenuItemToStringMap("New File...", function ()
		{
			Bootbox.prompt("Filename:", "New.hx", function (result:String)
			{
				var filename:String = result;
			
				var template:String = "";
			
				if (filename != null) 
				{
					var extname = js.Node.path.extname(filename);
					var pathToFile:String;
					
					if (extname == ".hx")
					{
						var name:String = js.Node.path.basename(filename, extname);
						name = name.substr(0, 1).toUpperCase() + name.substr(1).toLowerCase();
						name = StringTools.replace(name, " ", "");
						
						template = "package ;\n\nclass " + name + "\n{\n    public function new()\n    {\n\n    }\n}";
						
						pathToFile = js.Node.path.join(path, name + ".hx");
					}
					else 
					{
						pathToFile = js.Node.path.join(path, filename);
					}
					
					js.Node.fs.writeFile(pathToFile, template, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
					{
						FileTree.onFileClick(pathToFile);
						FileTree.load();
					}
					);
				}
			});
			
			
		});
		
		addContextMenuItemToStringMap("New Folder...", function ()
		{
			Bootbox.prompt("Folder name:", "New Folder", function (result:String)
			{
				var dirname:String = result;
			
				if (dirname != null)
				{
					js.Node.fs.mkdir(js.Node.path.join(path, dirname), function (error):Void
					{
						FileTree.load();
					});
				}
			}
			);
			
		});
		
		addContextMenuItemToStringMap("Open File", function ()
		{
			FileTree.onFileClick(path);
		});
		
		addContextMenuItemToStringMap("Open using OS", function ()
		{
			Shell.openItem(path);
		});
		
		addContextMenuItemToStringMap("Show Item In Folder", function ()
		{
			Shell.showItemInFolder(path);
		});
		
		addContextMenuItemToStringMap("Refresh", FileTree.load);
		
		ul.appendChild(menuItems.get("New File..."));
		ul.appendChild(menuItems.get("New Folder..."));
		ul.appendChild(menuItems.get("Open File"));
		ul.appendChild(menuItems.get("Open using OS"));
		ul.appendChild(menuItems.get("Show Item In Folder"));
		ul.appendChild(menuItems.get("Refresh"));
		
		contextMenu.appendChild(ul);
		
		Browser.document.body.appendChild(contextMenu);
		
		FileTree.treeWell.addEventListener('contextmenu', function(ev:MouseEvent) 
		{ 
			itemType = cast(ev.target, Element).getAttribute("itemType");
			path = cast(ev.target, Element).getAttribute("path");
			
			menuItems.get("New File...").style.display = "none";
			menuItems.get("New Folder...").style.display = "none";
			menuItems.get("Open File").style.display = "none";
			menuItems.get("Open using OS").style.display = "none";
			menuItems.get("Show Item In Folder").style.display = "none";
			
			if (itemType != null) 
			{
				switch (itemType) 
				{
					case "file":
						menuItems.get("Open File").style.display = "";
						menuItems.get("Open using OS").style.display = "";
						menuItems.get("Show Item In Folder").style.display = "";
					case "folder":
						menuItems.get("New File...").style.display = "";
						menuItems.get("New Folder...").style.display = "";
						menuItems.get("Show Item In Folder").style.display = "";
					default:
						
				}
			}
			
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
	
	private static function addContextMenuItemToStringMap(text:String, ?onClick:Dynamic):Void
	{
		menuItems.set(text, createContextMenuItem(text, onClick));
	}
}