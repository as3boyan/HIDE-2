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
	public static var dependencies:Array<String> = ["boyan.bootstrap.new-project-dialog", "boyan.bootstrap.tab-manager", "boyan.bootstrap.project-options"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			NewProjectDialog.getCategory("Haxe", 1).addItem("Flash Project", createFlashProject);
			
			//-cp src
			//-main Main
			
			//-swf FlashProject1.swf
			//-js FlashProject1.js
			//-php FlashProject1.php
			//-cpp FlashProject1.exe
			//-java FlashProject1.jar
			//-cs FlashProject1.exe
			
			//-debug
			//-dce full
			
			NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project", createJavaScriptProject);
			NewProjectDialog.getCategory("Haxe").addItem("Neko Project", createNekoProject);
			NewProjectDialog.getCategory("Haxe").addItem("PHP Project", createPhpProject);
			NewProjectDialog.getCategory("Haxe").addItem("C++ Project", createCppProject);
			NewProjectDialog.getCategory("Haxe").addItem("Java Project", createJavaProject);
			NewProjectDialog.getCategory("Haxe").addItem("C# Project", createCSharpProject);
			
			NewProjectDialog.getCategory("Haxe").select();
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
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
			var pathToMain:String  = data.projectLocation;
			
			if (data.createDirectory)
			{
				pathToMain = js.Node.path.join(pathToMain, data.projectName);
			}
			
			pathToMain = js.Node.path.join(pathToMain, "src", "Main.hx");
			
			var code:String = "package ;\n\nclass Main\n{\n    static public function main()\n    {\n        \n    }\n}";
			
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
			
			var path:String;
			
			if (data.createDirectory)
			{
				path = js.Node.path.join(data.projectLocation, data.projectName, "project.hide");
			}
			else 
			{
				path = js.Node.path.join(data.projectLocation, "project.hide");
			}
			
			var project:Project = new Project();
			project.name = data.projectName;
			project.projectPackage = data.projectPackage;
			project.company = data.projectCompany;
			project.license = data.projectLicense;
			project.url = data.projectURL;
			project.type = Project.HAXE;
			project.target = target;
			
			path = js.Node.path.join(js.Node.path.dirname(path), "project.hide");
			js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
			{
				
			}
			);
			
			ProjectAccess.currentProject = project;
			
			var args:String = "-cp src\n-main Main\n"; 
			
			switch (project.target) 
			{
				case Project.FLASH:
					args += "-swf " + project.name + ".swf\n";
				case Project.JAVASCRIPT:
					args += "-js " + project.name + ".js\n";
				case Project.PHP:
					args += "-php " + project.name + ".php\n";
				case Project.CPP:
					args += "-cpp " + project.name + ".exe\n";
				case Project.JAVA:
					args += "-java " + project.name + ".jar\n";
				case Project.CSHARP:
					args += "-cs " + project.name + ".exe\n";
					
				default:
					
			}
			
			args += "-debug\n -dce full";
			
			var textarea:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
			textarea.value = args;
		}
		);
	}
	
}