package newprojectdialog;
import menu.BootstrapMenu;

/**
 * ...
 * @author AS3Boyan
 */
class NewProjectDialogLoader
{
	public static function load():Void
	{		
		NewProjectDialog.create();
		BootstrapMenu.getMenu("File", 1).addMenuItem("New Project...", 1, NewProjectDialog.show, "Ctrl-Shift-N");
	}
	
}