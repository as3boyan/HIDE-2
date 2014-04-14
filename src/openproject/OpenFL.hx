package openproject;
import core.RecentProjectsList;
import core.Splitter;
import filetree.FileTree;
import js.Browser;
import js.Node;
import openflproject.OpenFLTools;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import projectaccess.ProjectOptions;

/**
 * ...
 * @author AS3Boyan
 */
class OpenFL
{
	public static function open(path:String):Void
	{
		var pathToProject:String = Node.path.dirname(path);
				
		var project:Project = new Project();
		project.name = pathToProject.substr(pathToProject.lastIndexOf(js.Node.path.sep));
		project.type = Project.OPENFL;
		project.openFLTarget = "flash";
		ProjectAccess.path = pathToProject;
		
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
			
			var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.hide");
			
			ProjectAccess.currentProject = project;
			
			ProjectOptions.updateProjectOptions();
			
			ProjectAccess.save(FileTree.load.bind(project.name, pathToProject));
			
			Splitter.show();
			
			Browser.getLocalStorage().setItem("pathToLastProject", pathToProjectHide);
			RecentProjectsList.add(pathToProjectHide);
		}
		);
	}
}