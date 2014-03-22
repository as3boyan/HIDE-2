package core;

/**
 * ...
 * @author AS3Boyan
 */
class FileTools
{
	public static function createDirectoryRecursively(path:String, folderPath:Array<String>, ?onCreated:Dynamic):Void
	{
		var fullPath:String = js.Node.path.join(path, folderPath[0]);
		
		createDirectory(fullPath, function ():Void
		{
			folderPath.splice(0, 1);
			
			if (folderPath.length > 0)
			{
				createDirectoryRecursively(fullPath, folderPath, onCreated);
			}
			else
			{
				onCreated();
			}
		}
		);
	}
	
	public static function createDirectory(path:String, ?onCreated:Dynamic):Void
	{
		js.Node.fs.mkdir(path, function (error):Void
		{								
			if (error != null)
			{
				trace(error);
			}
			
			if (onCreated != null)
			{
				onCreated();
			}
		}
		);
	}
}