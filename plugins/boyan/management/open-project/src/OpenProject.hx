package ;
import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
class OpenProject
{

	public function new() 
	{
		
	}
	
	public static function openProject(?pathToProject:String):Void
	{
		if (pathToProject == null)
		{
			FileDialog.openFile(parseProject);
		}
		else 
		{
			checkIfFileExists(pathToProject);
		}
	}
	
	private static function checkIfFileExists(path:String):Void
	{
		js.Node.fs.exists(path, function (exists:Bool)
		{
			if (exists) 
			{
				parseProject(path);
			}
			else 
			{
				trace("previously opened project: " + path + " was not found");
			}
		}
		);
	}
	
	private static function parseProject(path:String):Void
	{	
		trace("open project: ");
		trace(path);
		
		var filename:String = js.Node.path.basename(path);
			
		switch (filename) 
		{
			case "project.json":
				js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String):Void
				{
					var pathToProject:String = js.Node.path.dirname(path);
					
					ProjectAccess.currentProject = js.Node.parse(data);
					ProjectAccess.currentProject.path = pathToProject;
					
					ProjectOptions.updateProjectOptions();
					FileTree.load(ProjectAccess.currentProject.name, pathToProject);
					
					Browser.getLocalStorage().setItem("pathToLastProject", path);
				}
				);
			case "project.xml", "application.xml":
				var pathToProject:String = js.Node.path.dirname(path);
				
				var project:Project = new Project();
				project.name = pathToProject.substr(pathToProject.lastIndexOf(js.Node.path.sep));
				project.type = Project.OPENFL;
				project.openFLTarget = "flash";
				project.path = pathToProject;
				
				OpenFLTools.getParams(pathToProject, project.openFLTarget, function (stdout:String)
				{									
					var args:Array<String> = [];
				
					var currentLine:String;
					
					for (line in stdout.split("\n"))
					{
						currentLine = StringTools.trim(line);
						
						if (!StringTools.startsWith(currentLine, "#"))
						{
							args.push(currentLine);
						}
					}
					
					project.args = args;
					
					var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.json");
					
					ProjectAccess.currentProject = project;
					
					ProjectOptions.updateProjectOptions();
					
					ProjectAccess.save(function ()
					{
						FileTree.load(project.name, pathToProject);
					}
					);
					
					Browser.getLocalStorage().setItem("pathToLastProject", pathToProjectHide);
				}
				);
			default:				
				var extension:String = js.Node.path.extname(filename);
		
				switch (extension) 
				{
					case ".hxml":
						js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String)
						{
							var pathToProject:String = js.Node.path.dirname(path);
				
							var project:Project = new Project();
							project.name = pathToProject.substr(pathToProject.lastIndexOf(js.Node.path.sep));
							project.type = Project.HAXE;
							project.args = data.split("\n");
							project.path = pathToProject;
							
							ProjectAccess.currentProject = project;
							ProjectOptions.updateProjectOptions();
							
							var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.json");
							
							ProjectAccess.save(function ()
							{
								FileTree.load(project.name, pathToProject);
							}
							);
							
							Browser.getLocalStorage().setItem("pathToLastProject", pathToProjectHide);
						}
						);
					//case ".hx":
						//
					//case ".xml":
						//
					default:
						TabManager.openFileInNewTab(path);
				}
		}
	}
	
	public static function searchForLastProject():Void
	{		
		var pathToLastProject:String = Browser.getLocalStorage().getItem("pathToLastProject");
		if (pathToLastProject != null)
		{
			openProject(pathToLastProject);
		}
	}
	
}