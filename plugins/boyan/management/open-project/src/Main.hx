package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.management.open-project";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu", "boyan.window.file-dialog", "boyan.management.project-access", "boyan.bootstrap.project-options", "boyan.bootstrap.file-tree", "boyan.bootstrap.tab-manager", "boyan.openfl.tools"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load
	public static function main():Void
	{		
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			BootstrapMenu.getMenu("File").addMenuItem("Open...", 2, OpenProject.openProject, "Ctrl-O", "O".code, true, false, false);
			
			OpenProject.searchForLastProject();
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}