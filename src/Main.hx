package ;

import jQuery.JQuery;
import jQuery.JQueryStatic;
import js.Browser;
import js.html.KeyboardEvent;
import js.html.LinkElement;
import js.Lib;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	
	static function main() 
	{
		js.Node.require('nw.gui').Window.get().showDevTools();
		
		Browser.window.onload = function (e)
		{
			js.Node.require('nw.gui').Window.get().show();
			
			var pathToPlugins:String = js.Node.path.join("..", "plugins");
			
			js.Node.fs.readdir(pathToPlugins, function (error:js.Node.NodeErr, folders:Array<String>)
			{				
				for (folder in folders)
				{
					js.Node.fs.readdir(js.Node.path.join(pathToPlugins, folder), function (error:js.Node.NodeErr, subfolders:Array<String>)
					{
						trace(subfolders);
					}
					);
				}
			}
			);
		};
	}
	
}