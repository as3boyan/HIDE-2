package ;
import haxe.Serializer;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.project.haxe";
	public static var dependencies:Array<String> = ["boyan.bootstrap.new-project-dialog", "boyan.bootstrap.tab-manager", "boyan.bootstrap.project-options", "boyan.bootstrap.file-tree"];
	private static var code:String;
	private static var indexPageCode:String;
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			NewProjectDialog.getCategory("Haxe", 1).addItem("Flash Project", createFlashProject);			
			NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project", createJavaScriptProject);
			NewProjectDialog.getCategory("Haxe").addItem("Neko Project", createNekoProject);
			NewProjectDialog.getCategory("Haxe").addItem("PHP Project", createPhpProject);
			NewProjectDialog.getCategory("Haxe").addItem("C++ Project", createCppProject);
			NewProjectDialog.getCategory("Haxe").addItem("Java Project", createJavaProject);
			NewProjectDialog.getCategory("Haxe").addItem("C# Project", createCSharpProject);
			
			//NewProjectDialog.getCategory("Haxe").select();
			
			HIDE.readFile(name, "templates/Main.hx", function (data:String):Void
			{
				code = data;
				
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			}
			);
			
			HIDE.readFile(name, "templates/index.html", function (data:String):Void
			{
				indexPageCode = data;
			}
			);
		}
		);
	}
	
	private static function createCSharpProject(data:Dynamic):Void 
	{
		createHaxeProject(data, Project.CSHARP);
	}
	
	private static function createJavaProject(data:Dynamic):Void
	{
		createHaxeProject(data, Project.JAVA);
	}
	
	private static function createCppProject(data:Dynamic):Void
	{
		createHaxeProject(data, Project.CPP);
	}
	
	private static function createPhpProject(data:Dynamic):Void
	{
		createHaxeProject(data, Project.PHP);
	}
	
	private static function createNekoProject(data:Dynamic):Void
	{
		createHaxeProject(data, Project.NEKO);
	}
	
	private static function createFlashProject(data:Dynamic):Void
	{
		createHaxeProject(data, Project.FLASH);
	}
	
	private static function createJavaScriptProject(data:Dynamic):Void
	{
		createHaxeProject(data, Project.JAVASCRIPT);
	}
	
	private static function createHaxeProject(data:Dynamic, target:Int):Void
	{
		FileTools.createDirectoryRecursively(data.projectLocation, [data.projectName, "src"], function ():Void
		{
			var pathToProject:String  = data.projectLocation;
			
			if (data.createDirectory)
			{
				pathToProject = js.Node.path.join(pathToProject, data.projectName);
			}
			
			var pathToMain:String = pathToProject;
			
			pathToMain = js.Node.path.join(pathToMain, "src", "Main.hx");
			
			js.Node.fs.writeFile(pathToMain, code, function (error:js.Node.NodeErr):Void
			{
				if (error != null)
				{
					trace(error);
				}
				
				js.Node.fs.exists(pathToMain, function (exists:Bool):Void
				{
					if (exists)
					{
						TabManager.openFileInNewTab(pathToMain);
					}
					else 
					{
						trace(pathToMain + " file was not generated");
					}
				}
				);
			}
			);
			
			var project:Project = new Project();
			project.name = data.projectName;
			project.projectPackage = data.projectPackage;
			project.company = data.projectCompany;
			project.license = data.projectLicense;
			project.url = data.projectURL;
			project.type = Project.HAXE;
			project.target = target;
			project.path = pathToProject;
			
			var pathToBin:String = js.Node.path.join(pathToProject, "bin");
			js.Node.fs.mkdir(pathToBin);
			
			var args:String = "-cp src\n-main Main\n"; 
			
			switch (project.target) 
			{
				case Project.FLASH:
					args += "-swf " + "bin/" + project.name + ".swf\n";
				case Project.JAVASCRIPT:
					var pathToScript:String = "bin/" +  project.name + ".js";
					
					args += "-js " + pathToScript + "\n";
					
					var updatedPageCode:String = StringTools.replace(indexPageCode, "::title::", project.name);
					updatedPageCode = StringTools.replace(indexPageCode, "::script::", pathToScript);
					
					js.Node.fs.writeFile(js.Node.path.join(pathToBin, "index.html"), indexPageCode, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
					{
						
					}
					);
				case Project.NEKO:
					args += "-neko " + "bin/" + project.name + ".n\n";
				case Project.PHP:
					args += "-php " + "bin/" + project.name + ".php\n";
				case Project.CPP:
					args += "-cpp " + "bin/" + project.name + ".exe\n";
				case Project.JAVA:
					args += "-java " + "bin/" + project.name + ".jar\n";
				case Project.CSHARP:
					args += "-cs " + "bin/" + project.name + ".exe\n";
					
				default:
					
			}
			
			args += "-debug\n -dce full";
			
			project.args = args.split("\n");
			
			var path:String = js.Node.path.join(pathToProject, "project.hide");
			
			js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
			{
				FileTree.load(project.name, pathToProject);
			}
			);
			
			Browser.getLocalStorage().setItem("pathToLastProject", path);
			
			ProjectAccess.currentProject = project;
			ProjectOptions.updateProjectOptions();
			
			var textarea:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
			textarea.value = args;
		}
		);
	}
	
}