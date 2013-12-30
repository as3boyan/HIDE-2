package ;

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
			var pathToMain:String  = js.Node.path.join(data.projectLocation, data.projectName, "src");
			pathToMain = js.Node.path.join(pathToMain, "Main.hx");
			
			var code:String = "package ;\n\nclass Main\n{\n    static public function main()\n    {\n        \n    }\n}";
			
			js.Node.fs.writeFile(pathToMain, code, function (error):Void
			{
				if (error != null)
				{
					trace(error);
				}
				
				TabManager.openFileInNewTab(pathToMain);
			}
			);
		}
		);
	}
	
}