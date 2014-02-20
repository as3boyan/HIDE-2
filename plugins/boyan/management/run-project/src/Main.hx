package ;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.management.run-project";
	public static var dependencies:Array<String> = ["boyan.bootstrap.project-options", "boyan.compilation.client", "boyan.management.project-access"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			BootstrapMenu.getMenu("Project", 80).addMenuItem("Run", 1, runProject, "F5", 116);
			BootstrapMenu.getMenu("Project").addMenuItem("Build", 2, buildProject, "F8", 119);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
	private static function runProject():Void
	{
		buildProject(function ()
		{
			switch (ProjectAccess.currentProject.type) 
			{
				case Project.FLASH:
					HaxeClient.buildProject("start", [js.Node.path.join(ProjectAccess.currentProject.path, "bin", ProjectAccess.currentProject.name + ".swf")]);
				case Project.JAVASCRIPT:
					
				default:
					
			}
		}
		);
	}
	
	private static function buildProject(?onComplete:Dynamic):Void
	{		
		var projectOptions:TextAreaElement = cast(Browser.document.getElementById("project-options-textarea"), TextAreaElement);
		var args:Array<String> = projectOptions.value.split("\n");
		
		HaxeClient.buildProject("haxe", ["--connect", "6001", "--cwd", ProjectAccess.currentProject.path].concat(args), onComplete);
	}
	
}