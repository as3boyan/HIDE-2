package core;
import menu.BootstrapMenu;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class EditorConfiguration
{
	public static function addToMenu():Void
	{
		BootstrapMenu.getMenu("Options").addMenuItem("Open editor configuration file", 1, TabManager.openFileInNewTab.bind("editor.json"));
	}
}