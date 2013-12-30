package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.new-project-dialog";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu", "boyan.window.file-dialog"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{		
		//Wait for Bootstrap menu plugin
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			NewProjectDialog.create();
			
			BootstrapMenu.getMenu("File", 1).addMenuItem("New Project...", 1, NewProjectDialog.show, "Ctrl-Shift-N", "N".code, true, true, false);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
		
		HIDE.loadCSS(name, ["bin/includes/css/new-project-dialog.css"]);
	}
	
}