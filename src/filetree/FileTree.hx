package filetree;
import haxe.ds.StringMap.StringMap;
import jQuery.JQuery;
import jQuery.JQueryStatic;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.UListElement;
import js.Node;
import js.node.Mv;
import js.Node.NodeStat;
import js.node.Remove;
import js.node.Walkdir;
import js.node.Watchr;
import nodejs.webkit.Shell;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;
import watchers.LocaleWatcher;
import watchers.SettingsWatcher;
import watchers.Watcher;

/**
 * ...
 * @author AS3Boyan
 */
class FileTree
{
	static var lastProjectName:String;
	static var lastProjectPath:String;
	
	static var contextMenu:Dynamic;
	static var contextMenuCommandsMap:StringMap<Dynamic>;
	static var watcher:Dynamic;
	
	public static function init():Void
	{		
		contextMenuCommandsMap = new StringMap();
		
		appendToContextMenu("New File...", function (selectedItem):Void 
		{
			var path:String;
			
			if (selectedItem.value.type == 'folder') 
			{
				path = selectedItem.value.path;
			}
			else
			{
				path = Node.path.dirname(selectedItem.value.path);
			}
			
			Alertify.prompt(LocaleWatcher.getStringSync("Filename:"), function (e:Bool, str:String)
			{
				if (e) 
				{
					var pathToFile:String = js.Node.path.join(path, str);
					TabManager.createFileInNewTab(pathToFile);
					untyped new JQuery('#filetree').jqxTree('addTo', createFileItem(pathToFile) , selectedItem.element);
					attachContextMenu();
				}
			}, "New.hx");
		});
		
		appendToContextMenu("New Folder...", function (selectedItem):Void 
		{
			var path:String;
			
			if (selectedItem.value.type == 'folder') 
			{
				path = selectedItem.value.path;
			}
			else
			{
				path = Node.path.dirname(selectedItem.value.path);
			}
			
			Alertify.prompt("Folder name:", function (e, str:String)
			{
				if (e) 
				{
					var dirname:String = str;
			
					if (dirname != null)
					{
						Node.fs.mkdir(Node.path.join(path, dirname), function (error:NodeErr):Void
						{
							if (error == null) 
							{
								untyped new JQuery('#filetree').jqxTree('addTo', { label: str, value: {type: "folder", path: pathToFile, icon: "includes/images/folder.png"} }, selectedItem.element);
								attachContextMenu();
							}
							else 
							{
								Alertify.error(error);
							}
						});
					}
				}
			}, "New Folder");
		});
		
		appendToContextMenu("Open Item", function (selectedItem):Void 
		{
			if (selectedItem.value.type == 'file') 
			{
				TabManager.openFileInNewTab(selectedItem.value.path);
			}
			else
			{
				untyped new JQuery('#filetree').jqxTree('expandItem', selectedItem.element);
			}
		});
		
		appendToContextMenu("Open using OS", function (selectedItem):Void 
		{
			Shell.openItem(selectedItem.value.path);
		});
		
		appendToContextMenu("Show Item In Folder", function (selectedItem):Void 
		{
			Shell.showItemInFolder(selectedItem.value.path);
		});
		
		appendToContextMenu("Open Item", function (selectedItem):Void 
		{
			if (selectedItem.value.type == 'file') 
			{
				TabManager.openFileInNewTab(selectedItem.value.path);
			}
			else
			{
				untyped new JQuery('#filetree').jqxTree('expandItem', selectedItem.element);
			}
		});
		
		appendToContextMenu("Rename...", function (selectedItem):Void 
		{			
			var path = selectedItem.value.path;
			
			Alertify.prompt(LocaleWatcher.getStringSync("Please enter new name for ") + path, function (e, str):Void 
			{
				if (e) 
				{
					var currentDirectory:String = Node.path.dirname(path);
					Mv.move(path, Node.path.join(currentDirectory, str), function (error):Void 
					{
						if (error == null) 
						{
							FileTree.load();
						}
						else 
						{
							Alertify.error(error);
						}
					}
					);
				}
			}
			, Node.path.basename(path));
		}
		);
		
		appendToContextMenu("Delete...", function (selectedItem):Void 
		{
			var path = selectedItem.value.path;
			
			switch (selectedItem.value.type) 
			{
				case 'file':
					Alertify.confirm(LocaleWatcher.getStringSync("Remove file ") + path + " ?", function (e):Void 
					{
						if (e) 
						{
							Node.fs.unlink(path, function (error:NodeErr):Void 
							{
								if (error == null) 
								{
									untyped new JQuery('#filetree').jqxTree('removeItem', selectedItem.element);
									attachContextMenu();
								}
								else
								{
									Alertify.error(error);
								}
							}
							);
						}
					}
					);
				case 'folder':
					Alertify.confirm(LocaleWatcher.getStringSync("Remove folder ") + path + " ?", function (e):Void 
					{
						if (e) 
						{
							Remove.removeAsync(path, {}, function (error):Void 
							{
								if (error == null) 
								{
									untyped new JQuery('#filetree').jqxTree('removeItem', selectedItem.element);
									attachContextMenu();
								}
								else 
								{
									Alertify.error(error);
								}
							}
							);
						}
					}
					);
				default:
					
			}
		}
		);
		
		appendToContextMenu("Toggle Hidden Items Visibility", function (selectedItem):Void 
		{
			if (ProjectAccess.path != null) 
			{
				ProjectAccess.currentProject.showHiddenItems = !ProjectAccess.currentProject.showHiddenItems;
				Alertify.success(LocaleWatcher.getStringSync("Hidden Items Visible: ") + Std.string(ProjectAccess.currentProject.showHiddenItems));
				
				if (!ProjectAccess.currentProject.showHiddenItems) 
				{
					Alertify.log("Hidden Items: \n" + Std.string(ProjectAccess.currentProject.hiddenItems));
				}
			}
			
			FileTree.load();
		}
		);
		
		appendToContextMenu("Toggle Item Visibility", function (selectedItem):Void 
		{
			if (ProjectAccess.path != null) 
			{
				var relativePath:String = Node.path.relative(ProjectAccess.path, selectedItem.value.path);
				
				if (ProjectAccess.currentProject.hiddenItems.indexOf(relativePath) == -1) 
				{
					ProjectAccess.currentProject.hiddenItems.push(relativePath);
					untyped new JQuery('#filetree').jqxTree('removeItem', selectedItem.element);
					attachContextMenu();
				}
				else 
				{
					ProjectAccess.currentProject.hiddenItems.remove(relativePath);
					FileTree.load();
				}
			}
			else 
			{
				untyped new JQuery('#filetree').jqxTree('removeItem', selectedItem.element);
			}
		}
		);
		
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
			contextMenuCommandsMap.get(item)();
		}
		);
		
		new JQuery('#filetree').dblclick(function (event):Void 
		{
			var item = untyped new JQuery('#filetree').jqxTree('getSelectedItem');
			
			if (item.value.type == 'file') 
			{
				TabManager.openFileInNewTab(item.value.path);
			}
		}
		);
		
		new JQuery('#filetree').bind('dragEnd', function (event) {
                var target = event.args.originalEvent.target;
                var targetParents = new JQuery(target).parents();
                var item:Dynamic = null;
                JQueryStatic.each(untyped new JQuery("#filetree").jqxTree('getItems'), function (index, value) {
                    if (value.label == event.args.label && value.value == event.args.value) {
                        item = value;
                        untyped __js__('return false');
                    }
                });
                if (item) {
                    var parents = new JQuery(item.element).parents('li');
                    var path = "";
					
                    JQueryStatic.each(parents, function (index, value) {
                        var item = untyped new JQuery("#filetree").jqxTree('getItem', value);
						
						if (item.level > 0) 
						{
							 path = item.label + "/" + path;
						}
                    });
					
					var topDirectory = untyped new JQuery("#filetree").jqxTree('getItems')[0].value.path;
					var selectedItem = untyped new JQuery("#filetree").jqxTree('getSelectedItem');
					
					var previousPath = selectedItem.value.path;
                    var newPath = Node.path.join(topDirectory, path, selectedItem.label);
					
					Mv.move(previousPath, newPath, function (error:NodeErr):Void 
					{
						if (error == null) 
						{
							Alertify.success("File were successfully moved to " + newPath);
						}
						else 
						{
							Alertify.error("Can't move file from " + previousPath + " to " + newPath);
						}
					}
					);
                }
            });
	}
	
	static function appendToContextMenu(name:String, onClick:Dynamic)
	{
		var li:LIElement = Browser.document.createLIElement();
		li.textContent = name;
		new JQuery("#filetreemenu").append(li);
		
		contextMenuCommandsMap.set(name, function ():Void 
		{
			var selectedItem = untyped new JQuery('#filetree').jqxTree('getSelectedItem');
			if (selectedItem != null) 
			{
				onClick(selectedItem);
			}
		});
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
		
		readDirItems(path, function (source):Void 
		{
			source.expanded = true;
			untyped new JQuery('#filetree').jqxTree( { source: [source] } );
			attachContextMenu();
			
			//var items = untyped new JQuery("#filetree").jqxTree('getItems');
			//trace(items);
		}, true);
		
		if (watcher != null) 
		{
			watcher.close();
			watcher = null;
		}
		
		var config:Config = {
			path: path,
			listener:
				function (changeType, filePath, fileCurrentStat, filePreviousStat):Void 
				{
					switch (changeType) 
					{
						case 'create', 'delete':
							load();
						default:
							
					}
				}
		};
		
		config.interval = 3000;
		
		watcher = Watchr.watch(config);
		
		lastProjectName = projectName;
		lastProjectPath = path;
	}
	
	static function readDirItems(path:String, ?onComplete:Dynamic->Void, ?root:Bool = false)
	{		
		var items:Array<Dynamic> = [];
		var files:Array<Dynamic> = [];
		
		var options:Options = {};
		options.no_recurse = true;
		
		var emitter = Walkdir.walk(path, options);
		
		emitter.on("file", function (pathToFile:String, stat:NodeStat):Void 
		{
			if (!SettingsWatcher.isItemInIgnoreList(pathToFile) && !ProjectAccess.isItemInIgnoreList(pathToFile)) 
			{
				files.push(createFileItem(pathToFile));
			}
		}
		);
		
		var folders:Int = 0;
		var end:Bool = false;
		
		emitter.on("directory", function (pathToDirectory:String, stat:NodeStat):Void 
		{
			if (!SettingsWatcher.isItemInIgnoreList(pathToDirectory) && !ProjectAccess.isItemInIgnoreList(pathToDirectory)) 
			{
				folders++;
			
				readDirItems(pathToDirectory, function (source:Dynamic):Void 
				{
					folders--;
					
					items.push(source);
					
					if (folders == 0) 
					{
						items = items.concat(files);
						
						onComplete({label:Node.path.basename(path), items: items, value: {path: path, type: "folder"}, icon: "includes/images/folder.png"});
					}
				}
				);
			}
		}
		);
		
		emitter.on("end", function ():Void 
		{
			end = true;
			
			if (folders == 0) 
			{
				items = items.concat(files);
				
				onComplete({label:Node.path.basename(path), items: items, value: {path: path, type: "folder"}, icon: "includes/images/folder.png"});
			}
		}
		);
	}
	
	static function createFileItem(path:String):Dynamic
	{
		var basename:String = Node.path.basename(path);
		var extname:String = Node.path.extname(basename);
		
		var data:Dynamic = { label: basename, value: {path: path, type: "file"} };
		
		switch (extname) 
		{
			case ".pdf":
				data.icon = "includes/images/page_white_acrobat.png";
			case ".swf":
				data.icon = "includes/images/page_white_flash.png";
			case ".jpg", ".jpeg", ".png", ".gif", ".tga":
				data.icon = "includes/images/photo.png";
			case ".html":
				data.icon = "includes/images/html.png";
			default:
				
		}
		
		return data;
	}
}