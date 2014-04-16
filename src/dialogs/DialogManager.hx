package dialogs;

/**
 * ...
 * @author AS3Boyan
 */
class DialogManager
{
	static var browseFolderDialog:BrowseFolderDialog;
	static var haxelibManagerDialog:HaxelibManagerDialog;
	static var projectOptionsDialog:ProjectOptionsDialog;
	
	public static function load():Void
	{
		browseFolderDialog =  new BrowseFolderDialog();
		haxelibManagerDialog = new HaxelibManagerDialog();
		projectOptionsDialog = new ProjectOptionsDialog();
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
	
	public static function showProjectOptions()
	{
		projectOptionsDialog.show();
	}
	
	public static function hide():Void 
	{
		browseFolderDialog.hide();
		haxelibManagerDialog.hide();
	}
}