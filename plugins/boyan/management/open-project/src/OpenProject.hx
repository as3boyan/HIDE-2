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
				trace("previouly opened project: " + path + " was not found");
			}
		}
		);
	}
	
	private static function parseProject(path:String):Void
	{				
		trace(path);
		
		var filename:String = js.Node.path.basename(path);
			
		switch (filename) 
		{
			case "project.hide":
				js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String):Void
				{
					var pathToProject:String = js.Node.path.dirname(path);
					
					ProjectAccess.currentProject = Unserializer.run(data);
					ProjectOptions.updateProjectOptions();
					
					ProjectAccess.currentProject.path = pathToProject;
					FileTree.load(ProjectAccess.currentProject.name, pathToProject);
					
					var textarea:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
					textarea.value = ProjectAccess.currentProject.args.join("\n");
					
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
					var textarea:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
					
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
					
					textarea.value = args.join("\n");
					project.args = args;
					
					var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.hide");
					
					js.Node.fs.writeFile(pathToProjectHide, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
					{
						FileTree.load(project.name, pathToProject);
					}
					);
				}
				);
				
				ProjectAccess.currentProject = project;
				ProjectOptions.updateProjectOptions();
				
				Browser.getLocalStorage().setItem("pathToLastProject", js.Node.path.join(pathToProject, "project.hide"));
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
							
							var textarea:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
							textarea.value = project.args.join("\n");
							
							var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.hide");
							
							js.Node.fs.writeFile(pathToProjectHide, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
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