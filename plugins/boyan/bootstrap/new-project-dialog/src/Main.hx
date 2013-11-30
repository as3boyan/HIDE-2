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
			
			BootstrapMenu.getMenu("File").addMenuItem("New Project...",	NewProjectDialog.show, "Ctrl-Shift-N", "N".code, true, true, false);
			
			NewProjectDialog.getCategory("Haxe").addItem("Flash Project");
			NewProjectDialog.getCategory("Haxe").addItem("JavaScript Project");
			NewProjectDialog.getCategory("Haxe").addItem("Neko Project");
			NewProjectDialog.getCategory("Haxe").addItem("PHP Project");
			NewProjectDialog.getCategory("Haxe").addItem("C++ Project");
			NewProjectDialog.getCategory("Haxe").addItem("Java Project");
			NewProjectDialog.getCategory("Haxe").addItem("C# Project");
			
			NewProjectDialog.getCategory("Haxe").select();
			
			NewProjectDialog.getCategory("Haxe").getCategory("HIDE").addItem("HIDE plugin");
			
			NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Project", false);
			NewProjectDialog.getCategory("OpenFL").addItem("OpenFL Extension", false);
			
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("ActuateExample", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("AddingAnimation", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("AddingText", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("DisplayingABitmap", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HandlingKeyboardEvents", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HandlingMouseEvent", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("HerokuShaders", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("PiratePig", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("PlayingSound", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("SimpleBox2D", false, true);
			NewProjectDialog.getCategory("OpenFL").getCategory("Samples").addItem("SimpleOpenGLView", false, true);
		}
		);
		
		//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
		HIDE.notifyLoadingComplete(name);
	}
	
}