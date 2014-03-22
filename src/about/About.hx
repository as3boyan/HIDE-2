package about;
import menu.BootstrapMenu;

/**
 * ...
 * @author AS3Boyan
 */
class About
{
	public static function addToMenu():Void
	{		
		BootstrapMenu.getMenu("Help").addMenuItem("About HIDE...", 3, HIDE.openPageInNewWindow.bind(null, "about.html", {toolbar:false}));
	}
	
}