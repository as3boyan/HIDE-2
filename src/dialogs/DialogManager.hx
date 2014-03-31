package dialogs;

/**
 * ...
 * @author AS3Boyan
 */
class DialogManager
{
	static var browseFolderDialog:BrowseFolderDialog;
	
	public static function load():Void
	{
		browseFolderDialog =  new BrowseFolderDialog();
	}
	
	public static function showBrowseFolderDialog(title:String, onComplete:String->Void, defaultValue:String):Void
	{
		browseFolderDialog.setTitle(title);
		browseFolderDialog.setCallback(onComplete);
		browseFolderDialog.setDefaultValue(defaultValue);
		browseFolderDialog.show();
	}
}