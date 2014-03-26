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
@:keepSub @:expose class ProjectAccess
{
	public static var currentProject:Project = new Project();
	
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
		if (ProjectAccess.currentProject.path != null)
		{
			var pathToProjectHide:String = js.Node.path.join(ProjectAccess.currentProject.path, "project.json");
			
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
}