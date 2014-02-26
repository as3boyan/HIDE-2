package ;
import haxe.Serializer;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.project.openfl";
	public static var dependencies:Array<String> = ["boyan.bootstrap.new-project-dialog", "boyan.bootstrap.tab-manager", "boyan.bootstrap.file-tree", "boyan.bootstrap.project-options"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
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
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
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
			ProjectAccess.currentProject.path = pathToProject;
			
			var project:Project = new Project();
			project.name = data.projectName;
			project.projectPackage = data.projectPackage;
			project.company = data.projectCompany;
			project.license = data.projectLicense;
			project.url = data.projectURL;
			project.type = Project.OPENFL;
			//project.target = target;
			
			var path:String = js.Node.path.join(pathToProject, "project.hide");
			js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
			{
				FileTree.load(project.name, pathToProject);
			}
			);
			
			TabManager.openFileInNewTab(js.Node.path.join(pathToProject, "Source", "Main.hx"));
		}
		);
	}
	
	public static function createOpenFLExtension(data:Dynamic):Void
	{
		CreateOpenFLProject.createOpenFLProject(["extension", data.projectName], data.projectLocation, function ()
		{
			var pathToProject:String = js.Node.path.join(data.projectLocation, data.projectName);
			ProjectAccess.currentProject.path = pathToProject;
			
			var project:Project = new Project();
			project.name = data.projectName;
			project.projectPackage = data.projectPackage;
			project.company = data.projectCompany;
			project.license = data.projectLicense;
			project.url = data.projectURL;
			project.type = Project.OPENFL;
			//project.target = target;
			
			var path:String = js.Node.path.join(pathToProject, "project.hide");
			js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
			{
				FileTree.load(project.name, pathToProject);
			}
			);
		}
		);
	}
	
}