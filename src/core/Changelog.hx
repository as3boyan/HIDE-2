package core;
import menu.BootstrapMenu;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class Changelog
{
	public static function addToMenu():Void
	{
		BootstrapMenu.getMenu("Help").addMenuItem("changelog", 1, TabManager.openFileInNewTab.bind("changes.md"));
	}
}