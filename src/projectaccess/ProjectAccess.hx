package projectaccess;
import haxe.Json;
import js.Browser;
import js.Node;
import nodejs.webkit.Window;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
class ProjectAccess
{
	public static var currentProject:Project = new Project();
	
	public static var path:String;
	
	public static function registerSaveOnCloseListener():Void
	{
		var window = Window.get();
		
		window.on("close", function ():Void 
		{
			save(null, true);
			window.close();
			
		});
	}
	
	public static function save(?onComplete:Dynamic, ?sync:Bool = false):Void
	{		
		if (ProjectAccess.path != null)
		{
			var pathToProjectHide:String = js.Node.path.join(ProjectAccess.path, "project.hide");
			
			var data:String = TJSON.encode(ProjectAccess.currentProject, 'fancy');
			
			if (sync) 
			{
				Node.fs.writeFileSync(pathToProjectHide, data, js.Node.NodeC.UTF8);
			}
			else 
			{
				js.Node.fs.writeFile(pathToProjectHide, data, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
				{
					if (onComplete != null)
					{
						onComplete();
					}
				}
				);
			}
		}
		else 
		{
			trace("project path is null");
		}
	}
	
	public static function load(path:String, ?onComplete:Dynamic):Void
	{
		//trace(js.Node.parse());
	}
	
	public static function isItemInIgnoreList(path:String):Bool
	{
		var ignore:Bool = false;
		
		if (!ProjectAccess.currentProject.showHiddenItems) 
		{
			var relativePath:String = Node.path.relative(ProjectAccess.path, path);
			
			trace(relativePath);
			
			if (ProjectAccess.currentProject.hiddenItems.indexOf(relativePath) != -1) 
			{
				ignore = true;
			}
		}
		
		return ignore;
	}
}