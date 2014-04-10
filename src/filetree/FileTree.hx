package filetree;
import jQuery.JQuery;
import jQuery.JQueryStatic;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.UListElement;
import js.node.Watchr;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class FileTree
{
	static var lastProjectName:String;
	static var lastProjectPath:String;
	public static var treeWell:DivElement;
	
	static var clickedItem:Dynamic;
	static var contextMenu:Dynamic;
	
	public static function init():Void
	{
		clickedItem = null;
		
		var li:LIElement = Browser.document.createLIElement();
		li.textContent = "New File...";
		new JQuery("#filetreemenu").append(li);
		
		contextMenu = untyped new JQuery("#jqxMenu").jqxMenu({ autoOpenPopup: false, mode: 'popup' });
		
		attachContextMenu();
		
		// disable the default browser's context menu.
		new JQuery(Browser.document).on('contextmenu', function (e) {
			if (new JQuery(e.target).parents('.jqx-tree').length > 0) {
				return false;
			}
			return true;
		});
		
		new JQuery("#jqxMenu").on('itemclick', function (event) 
		{
			
			var item = JQueryStatic.trim(new JQuery(event.args).text());
			switch (item) {
				case "New File...":
					var selectedItem = untyped new JQuery('#filetree').jqxTree('selectedItem');
					if (selectedItem != null) {
						untyped new JQuery('#filetree').jqxTree('addTo', { label: 'New File' }, selectedItem.element);
						attachContextMenu();
					}
				case "New Folder...":
					var selectedItem = untyped new JQuery('#filetree').jqxTree('selectedItem');
					if (selectedItem != null) {
						untyped new JQuery('#filetree').jqxTree('addTo', { label: 'New Folder' }, selectedItem.element);
						attachContextMenu();
					}
				case "Remove Item":
					var selectedItem = untyped new JQuery('#filetree').jqxTree('selectedItem');
					if (selectedItem != null) {
						untyped new JQuery('#filetree').jqxTree('removeItem', selectedItem.element);
						attachContextMenu();
					}
			}
		}
		);
		
		//<div id="tree_well" class="well" style="overflow: auto; padding: 0; margin: 0; width: 100%; height: 100%; font-size: 10pt; line-height: 1;">
			//<ul id="tree" class="nav nav-list" style="padding: 5px 0px;">
			//</ul>
		//</div>
		
		//treeWell = Browser.document.createDivElement();
		//treeWell.id = "tree-well";
		//treeWell.className = "well";
		//
		//var tree:UListElement = Browser.document.createUListElement();
		//tree.className = "nav nav-list";
		//tree.id = "tree";
		//treeWell.appendChild(tree);
		//
		//new jQuery.JQuery("#filetree").append(treeWell);
		//
		//load("HIDE", "../");
		//
		//ContextMenu.createContextMenu();
	}
	
	static function attachContextMenu() 
	{
		// open the context menu when the user presses the mouse right button.
		new JQuery("#filetree li").on('mousedown', function (event) {
			var target = new JQuery(event.target).parents('li:first')[0];
			var rightClick = isRightClick(event);
			if (rightClick && target != null) 
			{
				untyped new JQuery("#filetree").jqxTree('selectItem', target);
				var scrollTop = new JQuery(Browser.window).scrollTop();
				var scrollLeft = new JQuery(Browser.window).scrollLeft();
				contextMenu.jqxMenu('open', Std.parseInt(event.clientX) + 5 + scrollLeft, Std.parseInt(event.clientY) + 5 + scrollTop);
				return false;
			}
			else 
			{
				return true;
			}
		});
	}
	
	static function isRightClick(event:Dynamic):Bool
	{
		var rightclick = null;
		if (!event) var event = Browser.window.event;
		if (event.which) rightclick = (event.which == 3);
		else if (event.button) rightclick = (event.button == 2);
		return rightclick;
	}
	
	public static function load(?projectName:String, ?path:String):Void
	{
		if (projectName == null)
		{
			projectName = lastProjectName;
		}
		
		if (path == null)
		{
			path = lastProjectPath;
		}
		
		var config:Config = { };
		
		
		Watchr.watch(config);
		
		//var tree:UListElement = cast(Browser.document.getElementById("tree"), UListElement);
		//
		//new JQuery(tree).children().remove();
		//
		//var rootTreeElement:LIElement = createDirectoryElement(projectName, path);		
		//
		//tree.appendChild(rootTreeElement);
		//
		//readDir(path, rootTreeElement);
		//
		
		lastProjectName = projectName;
		lastProjectPath = path;
	}
	
	private static function createDirectoryElement(text:String, path:String):LIElement
	{
		var directoryElement:LIElement = Browser.document.createLIElement();
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.className = "tree-toggler nav-header";
		a.href = "#";
		a.setAttribute("path", path);
		a.setAttribute("itemType", "folder");
		
		var span = Browser.document.createSpanElement();
		span.className = "glyphicon glyphicon-folder-open";
		span.setAttribute("path", path);
		span.setAttribute("itemType", "folder");
		a.appendChild(span);
		
		span = Browser.document.createSpanElement();
		span.textContent = text;
		span.style.marginLeft = "5px";
		span.setAttribute("path", path);
		span.setAttribute("itemType", "folder");
		a.appendChild(span);
		
		//var textNode = Browser.document.createTextNode(text);
		//a.appendChild(textNode);
		
		a.onclick = function (e:MouseEvent):Void
		{
			new JQuery(directoryElement).children('ul.tree').toggle(300);
			//Main.resize();
		};
		
		//var label:LabelElement = Browser.document.createLabelElement();
		//label.className = "tree-toggler nav-header";
		//label.textContent = text;
		
		directoryElement.appendChild(a);
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.className = "nav nav-list tree";
		
		directoryElement.appendChild(ul);
		
		return directoryElement;
	}
	
	private static function readDir(path:String, topElement:LIElement):Void
	{
		js.Node.fs.readdir(path, function (error:js.Node.NodeErr, files:Array<String>):Void
		{			
			if (error == null && files != null)
			{
				var foldersCount:Int = 0;
			
				for (file in files)
				{
					var filePath:String = js.Node.path.join(path, file);
					
					js.Node.fs.stat(filePath, function (error:js.Node.NodeErr, stat:js.Node.NodeStat)
					{					
						if (stat.isFile())
						{
							var li:LIElement = Browser.document.createLIElement();
							
							var a:AnchorElement = Browser.document.createAnchorElement();
							a.href = "#";
							a.textContent = file;
							a.title = filePath;
							a.setAttribute("path", filePath);
							a.setAttribute("itemType", "file");
							a.onclick = function (e):Void
							{
								TabManager.openFileInNewTab(filePath);
							};
							
							if (StringTools.endsWith(file, ".hx"))
							{
								a.style.fontWeight = "bold";
							}
							else if (StringTools.endsWith(file, ".hxml"))
							{
								a.style.fontWeight = "bold";
								a.style.color = "gray";
							}
							else
							{
								a.style.color = "gray";
							}
							
							li.appendChild(a);
							
							var ul:UListElement = cast(topElement.getElementsByTagName("ul")[0], UListElement);
							ul.appendChild(li);
						}
						else
						{
							if (!StringTools.startsWith(file, "."))
							{
								var ul:UListElement = cast(topElement.getElementsByTagName("ul")[0], UListElement);
								
								var directoryElement:LIElement = createDirectoryElement(file, filePath);
								
								//Lazy loading
								directoryElement.onclick = function (e):Void
								{
									if (directoryElement.getElementsByTagName("ul")[0].childNodes.length == 0)
									{
										readDir(filePath, directoryElement);
										e.stopPropagation();
										e.preventDefault();
										directoryElement.onclick = null;
									}
								}
								
								ul.appendChild(directoryElement);
								ul.insertBefore(directoryElement, ul.childNodes[foldersCount]);
								foldersCount++;
							}
						}
					}
					);
				}
				
				new JQuery(topElement).children('ul.tree').show(300);
			}
		}
		);
	}
	
}