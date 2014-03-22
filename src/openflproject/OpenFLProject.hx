package openflproject;
import filetree.FileTree;
import js.Browser;
import js.html.TextAreaElement;
import newprojectdialog.NewProjectDialog;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import projectaccess.ProjectOptions;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class OpenFLProject
{
	public static function load():Void
	{
		NewProjectDialog.getCategory("OpenFL", 2).addItem("OpenFL Project", createOpenFLProject, false);
		NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Extension", createOpenFLExtension, false);
		
		var samples: Array<String> = [
		"ActuateExample",
		"AddingAnimation",
		"AddingText",
		"DisplayingABitmap",
		"HandlingKeyboardEvents",
		"HandlingMouseEvent",
		"HerokuShaders",
		"PiratePig",
		"PlayingSound",
		"SimpleBox2D",
		"SimpleOpenGLView",
		];
		
		for (sample in samples)
		{
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem(sample, function (data:Dynamic):Void
			{
				//data.projectName = sample;
				createOpenFLProject(data, true);
			}
			, false, true);
		}
	}
	
	public static function createOpenFLProject(data:Dynamic, sample:Bool = false):Void
	{	
		var params:Array<String>;
		
		if (!sample)
		{
			var str:String = "";
		
			if (data.projectPackage != "")
			{
				str = data.projectPackage + ".";
			}
			
			params = ["project", "\"" + str + data.projectName + "\""];
			
			if (data.projectCompany != "")
			{
				params.push("\"" + data.projectCompany + "\"");
			}
		}
		else 
		{
			params = [data.projectName];
		}
				
		CreateOpenFLProject.createOpenFLProject(params, data.projectLocation, function ()
		{	
			var pathToProject:String = js.Node.path.join(data.projectLocation, data.projectName);
			
			createProject(data);
			
			TabManager.openFileInNewTab(js.Node.path.join(pathToProject, "Source", "Main.hx"));
		}
		);
	}
	
	public static function createOpenFLExtension(data:Dynamic):Void
	{
		CreateOpenFLProject.createOpenFLProject(["extension", data.projectName], data.projectLocation, function ()
		{
			createProject(data);
		}
		);
	}
	
	private static function createProject(data:Dynamic):Void
	{
		var pathToProject:String = js.Node.path.join(data.projectLocation, data.projectName);
			
		var project:Project = new Project();
		project.name = data.projectName;
		project.projectPackage = data.projectPackage;
		project.company = data.projectCompany;
		project.license = data.projectLicense;
		project.url = data.projectURL;
		project.type = Project.OPENFL;
		//project.target = target;
		project.openFLTarget = "flash";
		project.path = pathToProject;
		project.buildActionCommand = ["haxelib", "run", "openfl", "build", '"%join%(%path%,project.xml)"', project.openFLTarget].join(" ");
		project.runActionType = Project.COMMAND;
		project.runActionText = ["haxelib", "run", "openfl", "run", '"%join%(%path%,project.xml)"', project.openFLTarget].join(" ");
		
		ProjectAccess.currentProject = project;
		
		OpenFLTools.getParams(project.path, project.openFLTarget, function (stdout:String)
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
			ProjectOptions.updateProjectOptions();
			
			var path:String = js.Node.path.join(pathToProject, "project.json");
			Browser.getLocalStorage().setItem("pathToLastProject", path);
			
			ProjectAccess.save(function ()
			{
				FileTree.load(project.name, pathToProject);
			}
			);
		}
		);
	}
	
}