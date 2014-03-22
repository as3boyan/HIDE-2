package core;
import menu.BootstrapMenu;

/**
 * ...
 * @author AS3Boyan
 */
class ToggleFullscreen
{
	public static function addToMenu():Void
	{	
		BootstrapMenu.getMenu("View", 2).addMenuItem("Toggle Fullscreen", 1, function ():Void
		{
			nodejs.webkit.Window.get().toggleFullscreen();
		}
		, "F11");
	}	
}