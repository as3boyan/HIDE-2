package ;
import jQuery.JQuery;
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
@:keepSub @:expose class FileTree
{	
	public static var onFileClick:Dynamic;
	private static var lastProjectName:String;
	private static var lastProjectPath:String;
	public static var treeWell:DivElement;
	
	public static function init():Void
	{
		//<div id="tree_well" class="well" style="overflow: auto; padding: 0; margin: 0; width: 100%; height: 100%; font-size: 10pt; line-height: 1;">
			//<ul id="tree" class="nav nav-list" style="padding: 5px 0px;">
			//</ul>
		//</div>
		
		var splitPaneComponent:DivElement = cast(Splitpane.components[0], DivElement);
		
		treeWell = Browser.document.createDivElement();
		treeWell.id = "tree-well";
		treeWell.className = "well";
		treeWell.style.overflow = "auto";
		treeWell.style.padding = "0";
		treeWell.style.margin = "0";
		treeWell.style.width = "100%";
		treeWell.style.height = "100%";
		treeWell.style.fontSize = "10pt";
		treeWell.style.lineHeight = "1";
		
		var tree:UListElement = Browser.document.createUListElement();
		tree.className = "nav nav-list";
		tree.id = "tree";
		tree.style.padding = "5px 0px";
		treeWell.appendChild(tree);
		
		splitPaneComponent.appendChild(treeWell);
		
		load("HIDE", "../");
		
		ContextMenu.createContextMenu();
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
		
		var tree:UListElement = cast(Browser.document.getElementById("tree"), UListElement);
		
		new JQuery(tree).children().remove();
		
		var rootTreeElement:LIElement = createDirectoryElement(projectName);		
		
		tree.appendChild(rootTreeElement);
		
		readDir(path, rootTreeElement);
		
		lastProjectName = projectName;
		lastProjectPath = path;
	}
	
	private static function createDirectoryElement(text:String):LIElement
	{
		var directoryElement:LIElement = Browser.document.createLIElement();
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.className = "tree-toggler nav-header";
		a.href = "#";
		
		var span = Browser.document.createSpanElement();
		span.className = "glyphicon glyphicon-folder-open";
		a.appendChild(span);
		
		span = Browser.document.createSpanElement();
		span.textContent = text;
		span.style.marginLeft = "5px";
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
			if (files != null)
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
							a.onclick = function (e):Void
							{
								if (onFileClick != null)
								{
									onFileClick(filePath);
								}
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
								
								var directoryElement:LIElement = createDirectoryElement(file);
								
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