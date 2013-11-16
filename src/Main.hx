package ;

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
					var path:String = js.Node.path.join(pathToPlugins, folder);
					
					js.Node.fs.readdir(path, function (error:js.Node.NodeErr, subfolders:Array<String>)
					{
						for (subfolder in subfolders)
						{
							var pathToPlugin:String = js.Node.path.join(path, subfolder);
							pathToPlugin = js.Node.require("path").resolve(pathToPlugin);
							
							var haxeCompilerProcess:js.Node.NodeChildProcess = js.Node.childProcess.spawn("haxe", ["--cwd", pathToPlugin, "plugin.hxml"]);
							
							haxeCompilerProcess.stderr.on('data', function (data:String):Void {
								trace(pathToPlugin + ' stderr: ' + data);
							});
							
							haxeCompilerProcess.on("close", function (code:Int):Void
							{
								trace(code);
								var pathToMain:String = js.Node.path.join(path, subfolder, "bin");
								pathToMain = js.Node.path.join(pathToMain, "Main.js");
								HIDE.loadJS(pathToMain);
							}
							);
						}
					}
					);
				}
			}
			);
		};
	}
	
}