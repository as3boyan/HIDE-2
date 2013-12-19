package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.developer-tools.hide";
	public static var dependencies:Array<String> = ["boyan.bootstrap.menu", "boyan.bootstrap.alerts"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			BootstrapMenu.getMenu("Developer Tools", 100).addMenuItem("Reload IDE", function ():Void
			{
				js.Node.require('nw.gui').Window.get().reloadIgnoringCache();
			}
			, "Ctrl-Shift-R", "R".code, true, true, false);

			BootstrapMenu.getMenu("Developer Tools").addMenuItem("Compile plugins and reload IDE", function ():Void
			{
				HIDE.compilePlugins(function ():Void
				{
					//Only when all plugins successfully loaded
					js.Node.require('nw.gui').Window.get().reloadIgnoringCache();
				}
				//On plugin compilation failed
				, function (data:String):Void
				{
					Alerts.showAlert(data);
				}
				);
				
			}
			, "Shift-F5", 116, false, true, false);

			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}
