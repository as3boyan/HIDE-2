package tabmanager;
import cm.CMDoc;
import cm.Editor;
import core.FileDialog;
import core.HaxeLint;
import core.RecentProjectsList;
import core.WelcomeScreen;
import filetree.FileTree;
import haxe.ds.StringMap.StringMap;
import haxe.Timer;
import jQuery.JQuery;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.Element;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.SpanElement;
import js.html.UListElement;
import js.Node;
import mustache.Mustache;
import nodejs.webkit.Window;
import projectaccess.ProjectAccess;
import watchers.LocaleWatcher;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class TabManager
{
	public static var tabs:UListElement;
	public static var tabMap:TabMap;
	public static var selectedPath:String;
	static var selectedIndex:Int;
	
	public static function load():Void
	{
		tabs = cast(Browser.document.getElementById("tabs"), UListElement);
		
		tabMap = new TabMap();
		
		ContextMenu.createContextMenu();
		
		var options:Alertify.Options = { };
		options.labels = { };
		options.labels.ok = LocaleWatcher.getStringSync("Yes");
		options.labels.cancel = LocaleWatcher.getStringSync("No");
		
		Alertify.set(options);
	}
	
	public static function createNewTab(name:String, path:String, doc:CodeMirror.Doc, ?save:Bool = false):Void
	{
		var tab = new Tab(name, path, doc, save);
		tabMap.add(tab);
		
		tabs.appendChild(tab.getElement());
		
		if (ProjectAccess.currentProject.path != null) 
		{
			var relativePath = Node.path.relative(ProjectAccess.currentProject.path, path);
			
			if (ProjectAccess.currentProject.files.indexOf(relativePath) == -1) 
			{
				ProjectAccess.currentProject.files.push(relativePath);
			}
		}
		
		RecentProjectsList.addFile(path);
		
		Editor.resize();
	}
	
	public static function openFile(path:String, onComplete:String->Void)
	{
		var options:js.Node.NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		Node.fs.readFile(path, options, function (error:js.Node.NodeErr, code:String):Void
		{
			if (error != null)
			{
				trace(error);
			}
			else 
			{
				onComplete(code);
			}
		}
		);
	}
	
	public static function openFileInNewTab(path:String, ?show:Bool = true, ?onComplete:Dynamic):Void
	{
		//path = js.Node.require('path').relative(js.Node.process.cwd(), path);
		path = StringTools.replace(path, "\\", js.Node.path.sep); 
		
		if (isAlreadyOpened(path, show))
		{
			if (onComplete != null) 
			{
				onComplete();
			}
			return;
		}
		
		openFile(path, function (code:String):Void 
		{
			if (isAlreadyOpened(path, show))
			{
				if (onComplete != null) 
				{
					onComplete();
				}
				
				return;
			}
			
			if (code != null)
			{
				var mode:String = getMode(path);
				var name:String = js.Node.path.basename(path);
				
				var doc = new CodeMirror.Doc(code, mode);
				
				createNewTab(name, path, doc);
				
				selectDoc(path);
				
				checkTabsCount();
				
				if (onComplete != null) 
				{
					onComplete();
				}
			}
			else 
			{
				trace("tab-manager: can't load file " + path);
			}
		}
		);
	}
	
	public static function createFileInNewTab(?pathToFile:String):Void
	{
		var path:String = pathToFile;
		
		if (path == null) 
		{
			FileDialog.saveFile(function (_selectedPath:String)
			{			
				//var path:String = convertPathToUnixFormat(value);
		
				//if (isAlreadyOpened(path))
				//{
					//return;
				//}
				
				createNewFile(_selectedPath);
			}
			);
		}
		else 
		{
			createNewFile(path);
		}
	}
	
	private static function createNewFile(path:String):Void
	{
		var name:String = js.Node.path.basename(path);
		var mode:String = getMode(name);
		
		var code:String = "";
		
		var extname:String = js.Node.path.extname(name);
		
		if (extname == ".hx")
		{
			path = path.substr(0, path.length - name.length) + name.substr(0, 1).toUpperCase() + name.substr(1); // + Utils.capitalize(name)
			
			var options:NodeFsFileOptions = { };
			options.encoding = NodeC.UTF8;
			
			var pathToTemplate:String = Node.path.join("templates", "New.hx");
			var templateCode:String = Node.fs.readFileSync(pathToTemplate, options);
			
			//author:"testo"
			code = Mustache.render(templateCode, { name: js.Node.path.basename(name, extname), pack:"", author:""} );
		}
		
		var doc = new CodeMirror.Doc(code, mode);
		
		createNewTab(name, path, doc, true);
		selectDoc(path);
		
		checkTabsCount();
		
		//FileTree.load();
	}
	
	private static function checkTabsCount():Void
	{			
		if (Browser.document.getElementById("editor").style.display == "none" && tabMap.getTabs().length > 0)
		{
			new JQuery("#editor").fadeIn(250);
			
			WelcomeScreen.hide();
			
			Editor.editor.refresh();
			
			Editor.resize();
			//Main.updateMenu();
		}
	}
	
	public static function closeAll():Void
	{
		for (key in tabMap.keys()) 
		{
			closeTab(key, false);
		}
	}
        
	public static function closeOthers(path:String):Void
	{		
		for (key in tabMap.keys()) 
		{
			if (key != path) 
			{
				closeTab(key, false);
			}
		}
		
		if (tabMap.getTabs().length == 1)
		{
			showNextTab();
		}
	}
	
	public static function closeTab(path:String, ?switchToTab:Bool = true):Void
	{
		if (isChanged(path)) 
		{
			Alertify.confirm(LocaleWatcher.getStringSync("File ") + path +  LocaleWatcher.getStringSync(" was changed. Save it?"), function (e)
			{
				if (e)
				{
					saveDoc(path);
				}
				
				removeTab(path, switchToTab);
			}
			);
		}
		else 
		{
			removeTab(path, switchToTab);
		}
		
		Editor.resize();
	}
	
	static function removeTab(path:String, ?switchToTab:Bool)
	{
		var tab = tabMap.get(path);
		tabMap.remove(path);
		
		tab.remove();
		
		if (tabMap.getTabs().length > 0)
		{
			if (switchToTab)
			{
				showPreviousTab();
			}
		}
		else 
		{
			new JQuery("#editor").fadeOut(250);
			
			if (ProjectAccess.currentProject.path != null) 
			{
				WelcomeScreen.hide();
			}
			else 
			{
				WelcomeScreen.show();
			}
			
			selectedPath = null;
		}
		
		
		if (ProjectAccess.currentProject.path != null) 
		{
			var pathToDocument:String = Node.path.relative(ProjectAccess.currentProject.path, path);
			ProjectAccess.currentProject.files.remove(pathToDocument);
		}
	}
	
	public static function showPreviousTab() 
	{
		var index = selectedIndex - 1;
		var tabArray = tabMap.getTabs();
		
		if (index < 0) 
		{
			index = tabArray.length - 1;
		}
		
		selectDoc(tabArray[index].path);
	}
	
	public static function showNextTab() 
	{
		var index = selectedIndex + 1;
		var tabArray = tabMap.getTabs();
		
		if (index > tabArray.length - 1) 
		{
			index = 0;
		}
		
		selectDoc(tabArray[index].path);
	}
	
	public static function closeActiveTab():Void
	{
		closeTab(selectedPath);
	}

	private static function isAlreadyOpened(path:String, ?show:Bool = true):Bool
	{
		var opened:Bool = tabMap.exists(path);
		
		if (opened && show) 
		{
			selectDoc(path);
		}
		
		return opened;
	}
	
	private static function getMode(path:String):String
	{
		var mode:String = "haxe";
				
		switch (js.Node.path.extname(path)) 
		{
			case ".hxml":
					mode = "hxml";
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
	
	public static function selectDoc(path:String):Void
	{
		var keys = tabMap.keys();
		for (i in 0...keys.length) 
		{
			if (keys[i] == path) 
			{
				tabMap.get(keys[i]).getElement().className = "selected";
				selectedIndex = i;
			}
			else 
			{
				tabMap.get(keys[i]).getElement().className = "";
			}
		}
		
		selectedPath = path;
		
		if (ProjectAccess.currentProject.path != null) 
		{
			ProjectAccess.currentProject.activeFile = Node.path.relative(ProjectAccess.currentProject.path, selectedPath);
		}
		
		Editor.editor.swapDoc(tabMap.get(selectedPath).doc);
		
		if (Node.path.extname(selectedPath) == ".hx") 
		{
			HaxeLint.updateLinting();
		}
	}
	
	public static function getCurrentDocumentPath():String
	{
		return selectedPath;
	}
	
	public static function getCurrentDocument():CodeMirror.Doc
	{
		return tabMap.get(selectedPath).doc;
	}
	
	public static function saveDoc(path:String, ?onComplete:Dynamic):Void
	{				
		if (isChanged(path)) 
		{
			var tab:Tab = tabMap.get(path);
			tab.save();
		}
		
		if (onComplete != null)
		{
			onComplete();
		}	
	}
	
	public static function isChanged(path:String):Bool
	{
		var tab:Tab = tabMap.get(path);
		var history:Dynamic = tab.doc.historySize();
		
		return (history.undo > 0 || history.redo > 0);
	}
	
	public static function saveActiveFile(?onComplete:Dynamic):Void
	{
		if (selectedPath != null) 
		{
			saveDoc(selectedPath, onComplete);
		}
	}
	
	public static function saveActiveFileAs():Void
	{		
		var tab = tabMap.get(selectedPath);
		
		FileDialog.saveFile(function (path:String):Void
		{
			tabMap.remove(selectedPath);
			tab.path = path;
			selectedPath = path;
			tabMap.add(tab);
			saveDoc(selectedPath);
		}
		, tab.name);
	}
	
	public static function saveAll(?onComplete:Dynamic):Void
	{		
		for (key in tabMap.keys()) 
		{
			saveDoc(key);
		}
		
		if (onComplete != null)
		{
			onComplete();
		}
	}
}