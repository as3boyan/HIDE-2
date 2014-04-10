package dialogs;

/**
 * ...
 * @author AS3Boyan
 */
class DialogManager
{
	static var browseFolderDialog:BrowseFolderDialog;
	static var haxelibManagerDialog:HaxelibManagerDialog;
	
	public static function load():Void
	{
		browseFolderDialog =  new BrowseFolderDialog();
		haxelibManagerDialog = new HaxelibManagerDialog();
	}
	
	public static function showBrowseFolderDialog(title:String, onComplete:String->Void, ?defaultValue:String = ""):Void
	{
		browseFolderDialog.setTitle(title);
		browseFolderDialog.setCallback(onComplete);
		browseFolderDialog.setDefaultValue(defaultValue);
		browseFolderDialog.show();
	}
	
	public static function showHaxelibManagerDialog()
	{
		haxelibManagerDialog.show();
	}
	
	public static function hide():Void 
	{
		browseFolderDialog.hide();
		haxelibManagerDialog.hide();
	}
}