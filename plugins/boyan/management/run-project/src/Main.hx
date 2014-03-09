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
	public static var dependencies:Array<String> = ["boyan.bootstrap.project-options", "boyan.compilation.client", "boyan.management.project-access", "boyan.bootstrap.menu", "boyan.bootstrap.tab-manager"];
	
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
			var gui = js.Node.require('nw.gui');
			
			switch (ProjectAccess.currentProject.runActionType) 
			{
				case Project.URL:
					gui.Shell.openExternal(ProjectAccess.currentProject.runActionText);
				case Project.FILE:
					gui.Shell.openItem(ProjectAccess.currentProject.runActionText);
				case Project.COMMAND:
					HaxeClient.buildProject(ProjectAccess.currentProject.runActionText);
				default:
					
			}
		}
		);
	}
	
	private static function buildProject(?onComplete:Dynamic):Void
	{		
		TabManager.saveAll(function ()
		{
			var command:String = ProjectAccess.currentProject.buildActionCommand;
			
			if (ProjectAccess.currentProject.type == Project.HAXE)
			{
				command = [command].concat(ProjectAccess.currentProject.args).join(" ");
			}
			
			HaxeClient.buildProject(command, onComplete);			
		}
		);
	}	
}
