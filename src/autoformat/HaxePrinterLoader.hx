package autoformat;
import cm.CodeMirrorEditor;
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
		BootstrapMenu.getMenu("Source", 3).addMenuItem("Autoformat", 1, function ()
		{
			if (js.Node.path.extname(TabManager.getCurrentDocumentPath()) == ".hx") 
			{
				var data:String = CodeMirrorEditor.editor.getValue();
				
				if (data != "") 
				{
					data = HaxePrinter.formatSource(data);
					CodeMirrorEditor.editor.setValue(data);
				}
			}
		}
		, "Ctrl-Shift-F");
		
		BootstrapMenu.getMenu("Options").addMenuItem("Open autoformat configuration file", 1, TabManager.openFileInNewTab.bind(Node.path.join("config","autoformat.json")));
	}
	
}