package core;
import menu.BootstrapMenu;
import tabmanager.TabManager;

/**
 * ...
 * @author 
 */
class EditingTheme
{
	public static function addToMenu()
	{
		BootstrapMenu.getMenu("Options").addMenuItem("Open stylesheet", 1, TabManager.openFileInNewTab.bind("theme.css"));
	}
}