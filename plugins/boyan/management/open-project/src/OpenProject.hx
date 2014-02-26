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
			parseProject(pathToProject);
		}
	}
	
	private static function parseProject(path:String):Void
	{
		var filename:String = js.Node.path.basename(path);
			
		switch (filename) 
		{
			case "project.hide":					
				js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String):Void
				{
					var pathToProject:String = js.Node.path.dirname(path);
					//js.Node.process.chdir(pathToProject);
					
					ProjectAccess.currentProject = Unserializer.run(data);
					trace(pathToProject);
					ProjectAccess.currentProject.path = pathToProject;
					FileTree.load(ProjectAccess.currentProject.name, pathToProject);
					
					var textarea:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
					textarea.value = ProjectAccess.currentProject.args.join("\n");
					
					Browser.getLocalStorage().setItem("pathToLastProject", js.Node.path.join(pathToProject, "project.hide"));
				}
				);
			case "project.xml", "application.xml":
				var pathToProject:String = js.Node.path.dirname(path);
				
				var project:Project = new Project();
				project.type = Project.OPENFL;
				
				ProjectAccess.currentProject = project;
				
				js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
				{
					
				}
				);
				
				Browser.getLocalStorage().setItem("pathToLastProject", js.Node.path.join(pathToProject, "project.hide"));
			default:				
				var extension:String = js.Node.path.extname(filename);
		
				switch (extension) 
				{
					//case ".hxml":
					//
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