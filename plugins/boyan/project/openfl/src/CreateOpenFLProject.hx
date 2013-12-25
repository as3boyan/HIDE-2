package ;

/**
 * ...
 * @author AS3Boyan
 */
class CreateOpenFLProject
{

	public function new() 
	{
		
	}
	
	public static function createOpenFLProject(params:Array<String>):Void
	{
		var OpenFLTools = js.Node.childProcess.spawn("haxelib", ["run", "openfl", "create"].concat(params));
										
		var log:String = "";
		
		OpenFLTools.stderr.setEncoding('utf8');
		OpenFLTools.stderr.on('data', function (data) 
		{
			var str:String = data.toString();
			log += str;
		}
		);
		
		OpenFLTools.on('close', function (code:Int) 
		{
			trace("exit code: " + Std.string(code));
			
			trace(log);
			
			//var path:String = js.Node.path.join(projectLocation.value, projectName.value);
			
			//if (list.value != projectName.value)
			//{                                
				//js.Node.fs.rename(Utils.path.join(projectLocation.value, list.value), path, function (error):Void
				//{
					//if (error != null)
					//{
						//trace(error);
					//}
					//
					//TabsManager.openFileInNewTab(Utils.path.join(path, "Source", "Main.hx"));
				//}
				//);
			//}
			//else
			//{
				//TabsManager.openFileInNewTab(Utils.path.join(path, "Source", "Main.hx"));
			//}
		}
		);
	}
	
}