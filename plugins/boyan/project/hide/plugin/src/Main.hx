package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.project.hide.plugin";
	public static var dependencies:Array<String> = ["boyan.bootstrap.new-project-dialog"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			NewProjectDialog.getCategory("Haxe").getCategory("HIDE").addItem("Plugin");
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}