package autoformat;
import cm.Editor;
import js.Node;
import menu.BootstrapMenu;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class HaxePrinterLoader
{
	public static function load():Void
	{
		BootstrapMenu.getMenu("Source", 5).addMenuItem("Autoformat", 1, function ()
		{
			if (js.Node.path.extname(TabManager.getCurrentDocumentPath()) == ".hx") 
			{
				var data:String = Editor.editor.getValue();
				
				if (data != "") 
				{
					data = HaxePrinter.formatSource(data);
					Editor.editor.setValue(data);
				}
			}
		}
		, "Ctrl-Shift-F");
		
		BootstrapMenu.getMenu("Options").addMenuItem("Open autoformat configuration file", 1, TabManager.openFileInNewTab.bind(Node.path.join("core", "config","autoformat.json")));
	}
	
}