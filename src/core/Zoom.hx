package core;
import menu.BootstrapMenu;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
class Zoom
{
	public static function addToMenu():Void
	{
		var window = Window.get();

		BootstrapMenu.getMenu("View").addMenuItem("Zoom In", 2, function ():Void
		{
			window.zoomLevel += 1;
		}
		, "Ctrl-Shift-+");

		BootstrapMenu.getMenu("View").addMenuItem("Zoom Out", 3, function ():Void
		{
			window.zoomLevel -= 1;
		}
		, "Ctrl-Shift--");

		BootstrapMenu.getMenu("View").addMenuItem("Reset", 4, function ():Void
		{
			window.zoomLevel = 0;
		}
		, "Ctrl-Shift-0");
	}
	
}
