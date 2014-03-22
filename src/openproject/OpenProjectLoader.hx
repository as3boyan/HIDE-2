package openproject;
import haxe.Timer;
import menu.BootstrapMenu;

/**
 * ...
 * @author AS3Boyan
 */
class OpenProjectLoader
{	
	public static function load():Void
	{		
		BootstrapMenu.getMenu("File").addMenuItem("Open...", 2, OpenProject.openProject, "Ctrl-O");
		OpenProject.searchForLastProject();
	}
	
}