package core;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import menu.BootstrapMenu;
import nodejs.webkit.Window;
import openproject.OpenProject;
import tabmanager.TabManager;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
class RecentProjectsList
{
	static var projectList:Array<String> = [];
	static var fileList:Array<String> = [];
	
	public static function load()
	{
		var localStorage2 = Browser.getLocalStorage();
		
		if (localStorage2 != null) 
		{
			var recentProjectsData:String = localStorage2.getItem("recentProjects");
			var recentFilesData:String = localStorage2.getItem("recentFiles");
			var recentFilesData:String = localStorage2.getItem("recentFiles");
			
			if (recentProjectsData != null) 
			{
				try 
				{
					projectList = TJSON.parse(recentProjectsData);
				}
				catch (unknown:Dynamic)
				{
					trace(unknown);
				}
			}
			
			if (recentFilesData != null) 
			{
				try 
				{
					fileList = TJSON.parse(recentFilesData);
				}
				catch (unknown:Dynamic)
				{
					trace(unknown);
				}
			}
		}
		
		Window.get().on("close", function ():Void 
		{
			localStorage2.setItem("recentProjects", TJSON.encode(projectList));
			localStorage2.setItem("recentFiles", TJSON.encode(fileList));
		}
		);
		
		updateMenu();
		updateWelcomeScreen();
		updateRecentFileMenu();
	}
	
	public static function add(path:String):Void
	{
		addItemToList(projectList, path);
		
		updateMenu();
		updateWelcomeScreen();
	}
	
	public static function addFile(path:String):Void
	{
		addItemToList(fileList, path);
		updateRecentFileMenu();
	}
	
	static function addItemToList(list:Array<String>, item:String):Void 
	{
		if (list.indexOf(item) == -1) 
		{
			if (list.length >= 10) 
			{
				list.pop();
			}
		}
		else 
		{
			list.remove(item);
		}
		
		list.insert(0, item);
	}
	
	static function updateMenu():Void
	{
		var submenu = BootstrapMenu.getMenu("File").getSubmenu("Open Recent Project");
		submenu.clear();
		
		for (i in 0...projectList.length) 
		{
			submenu.addMenuItem(projectList[i], i + 1, OpenProject.openProject.bind(projectList[i]));
		}
		
		var submenu = BootstrapMenu.getMenu("Project").getSubmenu("Build Recent Project");
		submenu.clear();
		
		for (i in 0...projectList.length) 
		{
			submenu.addMenuItem(projectList[i], i + 1, RunProject.buildProject.bind(projectList[i]));
		}
	}
	
	static function updateWelcomeScreen():Void
	{
		var listGroup:DivElement = cast(Browser.document.getElementById("recentProjectsList"), DivElement);
		
		while (listGroup.firstChild != null) 
		{
			listGroup.removeChild(listGroup.firstChild);
		}
		
		for (i in 0...projectList.length) 
		{
			var a:AnchorElement = Browser.document.createAnchorElement();
			a.href = "#";
			a.className = "list-group-item recentProject";
			a.textContent = projectList[i];
			a.onclick = function (e):Void 
			{
				OpenProject.openProject(projectList[i]);
			};
			
			listGroup.appendChild(a);
		}
	}
	
	static function updateRecentFileMenu():Void
	{
		var submenu = BootstrapMenu.getMenu("File").getSubmenu("Open Recent File");
		submenu.clear();
		
		for (i in 0...fileList.length) 
		{
			submenu.addMenuItem(fileList[i], i + 1, TabManager.openFileInNewTab.bind(fileList[i]));
		}
	}
}