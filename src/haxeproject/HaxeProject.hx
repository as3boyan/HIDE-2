package haxeproject;
import core.FileTools;
import core.Splitter;
import filetree.FileTree;
import js.Browser;
import js.html.TextAreaElement;
import js.Node;
import mustache.Mustache;
import newprojectdialog.NewProjectDialog;
import openproject.OpenProject;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import projectaccess.ProjectOptions;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class HaxeProject
{
	static var code:String;
	static var indexPageCode:String;
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function load():Void
	{
			NewProjectDialog.getCategory("Haxe", 1).addItem("Flash Project", createFlashProject);			
			NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project", createJavaScriptProject);
			NewProjectDialog.getCategory("Haxe").addItem("Neko Project", createNekoProject);
			NewProjectDialog.getCategory("Haxe").addItem("PHP Project", createPhpProject);
			NewProjectDialog.getCategory("Haxe").addItem("C++ Project", createCppProject);
			NewProjectDialog.getCategory("Haxe").addItem("Java Project", createJavaProject);
			NewProjectDialog.getCategory("Haxe").addItem("C# Project", createCSharpProject);
			
			var options:NodeFsFileOptions = { };
			options.encoding = NodeC.UTF8;
			
			var path:String = Node.path.join("core", "templates", "Main.hx");
			
			Node.fs.readFile(path, options, function (error:NodeErr, data:String):Void
			{
				if (error == null) 
				{
					code = data;
				}
				else 
				{
					trace(error);
					Alertify.error("Can't load template " + path);
				}
			}
			);
			
			path = Node.path.join("core", "templates", "index.html");
			
			Node.fs.readFile(path, options, function (error:NodeErr, data:String):Void
			{
				if (error == null) 
				{
					indexPageCode = data;
				}
				else 
				{
					trace(error);
					Alertify.error("Can't load template " + path);
				}
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
				pathToProject = Node.path.join(pathToProject, data.projectName);
			}
			
			var pathToMain:String = pathToProject;
			
			pathToMain = Node.path.join(pathToMain, "src", "Main.hx");
			
			js.Node.fs.writeFile(pathToMain, code, function (error:js.Node.NodeErr):Void
			{
				if (error != null)
				{
					Alertify.error(error);
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
			ProjectAccess.path = pathToProject;
			
			var filenames = ["flash", "javascript", "neko", "php", "cpp", "java", "csharp"];
			
			var pathToProjectTemplates = Node.path.join("core", "templates", "project");
			
			for (i in 0...filenames.length) 
			{
				var targetData:TargetData = { };
				targetData.pathToHxml = filenames[i] + ".hxml";
				
				var options:NodeFsFileOptions = { };
				options.encoding = NodeC.UTF8;
				
				var templateCode:String = Node.fs.readFileSync(Node.path.join(pathToProjectTemplates, targetData.pathToHxml), options);
				
				var pathToFile:String;
				
				switch (i)
				{
					case Project.FLASH:
						pathToFile = "bin/" + project.name + ".swf";
						targetData.runActionType = Project.FILE;
						targetData.runActionText = pathToFile;
					case Project.JAVASCRIPT:
						pathToFile = "bin/" +  project.name + ".js";
						
						var updatedPageCode:String = Mustache.render(indexPageCode, { title: project.name, script: project.name + ".js" } );
						
						var pathToWebPage:String = Node.path.join(pathToProject, "bin", "index.html");
						
						Node.fs.writeFile(pathToWebPage, updatedPageCode, NodeC.UTF8, function (error:js.Node.NodeErr):Void
						{
							
						}
						);
						
						targetData.runActionType = Project.FILE;
						targetData.runActionText = Node.path.join("bin", "index.html");
					case Project.NEKO:
						pathToFile  = "bin/" + project.name + ".n";
						
						targetData.runActionType = Project.COMMAND;
						targetData.runActionText = "neko " + pathToFile;
					case Project.PHP:
						pathToFile = "bin/" + project.name + ".php";
					case Project.CPP:
						pathToFile = "bin/" + project.name + ".exe";
						
						targetData.runActionType = Project.COMMAND;
						targetData.runActionText = pathToFile;
					case Project.JAVA:
						pathToFile = "bin/" + project.name + ".jar";
					case Project.CSHARP:
						pathToFile = "bin/" + project.name + ".exe";
						
					default:
						throw "Path to file is null";
				}
				
				templateCode = Mustache.render(templateCode, { file: pathToFile } );
				Node.fs.writeFileSync(Node.path.join(pathToProject, targetData.pathToHxml), templateCode, NodeC.UTF8);
				
				project.targetData.push(targetData);
			}
			
			Node.fs.mkdir(Node.path.join(pathToProject, "bin"));
			
			var path:String = js.Node.path.join(pathToProject, "project.hide");
			ProjectAccess.currentProject = project;
			ProjectAccess.save(OpenProject.openProject.bind(path));
		}
		);
	}
	
}