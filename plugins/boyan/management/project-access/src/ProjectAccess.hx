package ;
import js.Browser;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class ProjectAccess
{
	public static var currentProject:Project = new Project();
	
	public static function registerSaveOnCloseListener():Void
	{
		Browser.document.addEventListener("load", function (e)
		{
			Window.get().on("close", function (e)
			{
				save();
			}
			);
		}
		);
	}
	
	public static function save(?onComplete:Dynamic):Void
	{		
		if (ProjectAccess.currentProject.path != null)
		{
			var pathToProjectHide:String = js.Node.path.join(ProjectAccess.currentProject.path, "project.json");
		
			var data:String = HIDE.stringifyAndFormat(ProjectAccess.currentProject);
			
			js.Node.fs.writeFile(pathToProjectHide, data, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
			{
				 if (onComplete != null)
				{
					onComplete();
				}
			}
			);
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