package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.project.openfl";
	public static var dependencies:Array<String> = ["boyan.bootstrap.new-project-dialog"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Project", null, false);
			NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Extension", null, false);
			
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("ActuateExample", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("AddingAnimation", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("AddingText", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("DisplayingABitmap", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HandlingKeyboardEvents", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HandlingMouseEvent", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HerokuShaders", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("PiratePig", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("PlayingSound", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("SimpleBox2D", null, false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("SimpleOpenGLView", null, false, true);
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}