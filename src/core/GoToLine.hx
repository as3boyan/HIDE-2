package core;
import cm.Editor;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
class GoToLine
{
	public static function show()
	{
		if (TabManager.selectedPath != null) 
		{
			Alertify.prompt("Go to Line", function (e:Bool, str:String):Void 
			{
				Editor.editor.centerOnLine(Std.parseInt(str));
			}
			);
		}
	}
}