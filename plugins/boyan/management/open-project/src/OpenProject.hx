package ;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author AS3Boyan
 */
class OpenProject
{

	public function new() 
	{
		
	}
	
	public static function openProject():Void
	{
		FileDialog.openFile(function (path:String) 
		{ 
			var filename:String = js.Node.path.basename(path);
			
			switch (filename) 
			{
				case "project.hide":					
					js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String):Void
					{
						ProjectAccess.currentProject = cast(Unserializer.run(data), Project);
					}
					);
				case "project.xml":
					var project:Project = new Project();
					
					ProjectAccess.currentProject = project;
					
					js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
					{
						
					}
					);
				default:
					
					var extension:String = js.Node.path.extname(filename);
			
					switch (extension) 
					{
						case ".hxml":
						
						case ".hx":
							
						default:
							
					}
			}
		} 
		);
	}
	
}