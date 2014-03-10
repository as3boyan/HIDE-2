package ;
import js.Browser;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.window.drag-and-drop";
	public static var dependencies:Array<String> = ["boyan.bootstrap.tab-manager", "boyan.bootstrap.file-tree"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{		
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			Browser.window.addEventListener("dragover", function(e) 
			{
				e.preventDefault();
				e.stopPropagation();
				return false;
			}
			);
			
			Browser.window.addEventListener("drop", function(e:Dynamic) 
			{
				e.preventDefault();
				e.stopPropagation();
				
				for (i in 0...e.dataTransfer.files.length) 
				{
					var path:String = e.dataTransfer.files[i].path;
					js.Node.fs.stat(path, function (err, stats:js.Node.NodeStat)
					{
						if (stats.isDirectory())
						{
							FileTree.load(js.Node.path.basename(path), path);
						}
						else 
						{
							TabManager.openFileInNewTab(path);
						}
					}
					);
					
					
				}

				return false;
			}
			);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}