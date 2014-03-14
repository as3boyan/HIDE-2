package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.source.autoformat";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu", "boyan.bootstrap.tab-manager"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			BootstrapMenu.getMenu("Source", 3).addMenuItem("Autoformat", 1, function ()
			{
				if (js.Node.path.extname(TabManager.getCurrentDocumentPath()) == ".hx") 
				{
					var data:String = TabManager.editor.getValue();
					
					if (data != "") 
					{
						data = HaxePrinter.formatSource(data);
						TabManager.editor.setValue(data);
					}
				}
			}
			, "Ctrl-Shift-F");
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}