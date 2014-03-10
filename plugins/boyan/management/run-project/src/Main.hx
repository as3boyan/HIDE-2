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
	public static var dependencies:Array<String> = ["boyan.bootstrap.project-options", "boyan.compilation.client", "boyan.management.project-access", "boyan.bootstrap.menu", "boyan.bootstrap.tab-manager", "boyan.bootstrap.alerts"];
	
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
					var path:String = ProjectAccess.currentProject.runActionText;
					
					js.Node.fs.exists(path, function (exists:Bool)
					{
						if (!exists)
						{
							path = js.Node.path.join(ProjectAccess.currentProject.path, path);
						}
						
						gui.Shell.openItem(path);
					}
					);
				case Project.COMMAND:
					HaxeClient.buildProject(preprocessCommand(ProjectAccess.currentProject.runActionText));
				default:
					
			}
		}
		);
	}
	
	private static function buildProject(?onComplete:Dynamic):Void
	{		
		if (ProjectAccess.currentProject.path == null)
		{
			Alerts.showAlert("Please open or create project first!");
		}
		else 
		{
			TabManager.saveAll(function ()
			{
				var command:String = ProjectAccess.currentProject.buildActionCommand;
				command = preprocessCommand(command);
				
				if (ProjectAccess.currentProject.type == Project.HAXE)
				{
					command = [command].concat(ProjectAccess.currentProject.args).join(" ");
				}
				
				HaxeClient.buildProject(command, onComplete);			
			}
			);
		}
	}
	
	private static function preprocessCommand(command:String):String
	{
		var processedCommand:String = command;
		
		processedCommand = StringTools.replace(processedCommand, "%path%", ProjectAccess.currentProject.path);
		
		var ereg:EReg = ~/%join%[(](.+)[)]/;
		
		if (ereg.match(processedCommand))
		{
			var matchedString:String = ereg.matched(1);
			var arguments = matchedString.split(",");
			
			processedCommand = StringTools.replace(processedCommand, ereg.matched(0), js.Node.path.join(arguments[0], arguments[1]));
		}
		
		return processedCommand;
	}
}
