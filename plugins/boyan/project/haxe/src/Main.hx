package ;
import haxe.Serializer;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.project.haxe";
	public static var dependencies:Array<String> = ["boyan.bootstrap.new-project-dialog", "boyan.bootstrap.tab-manager"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			NewProjectDialog.getCategory("Haxe", 1).addItem("Flash Project", createHaxeProject);
			
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
			
			NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project", createHaxeProject);
			NewProjectDialog.getCategory("Haxe").addItem("Neko Project", createHaxeProject);
			NewProjectDialog.getCategory("Haxe").addItem("PHP Project", createHaxeProject);
			NewProjectDialog.getCategory("Haxe").addItem("C++ Project", createHaxeProject);
			NewProjectDialog.getCategory("Haxe").addItem("Java Project", createHaxeProject);
			NewProjectDialog.getCategory("Haxe").addItem("C# Project", createHaxeProject);
			
			NewProjectDialog.getCategory("Haxe").select();
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
	private static function createHaxeProject(data:Dynamic):Void
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
			
			path = js.Node.path.join(js.Node.path.dirname(path), "project.hide");
			js.Node.fs.writeFile(path, Serializer.run(project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr):Void
			{
				
			}
			);
			
			ProjectAccess.currentProject = project;
		}
		);
	}
	
}