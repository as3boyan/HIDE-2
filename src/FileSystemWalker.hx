package ;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author 
 */
class FileSystemWalker
{
	public static function main():Void 
	{
		walk("../src");
	}
	
	public static function walk(path:String):Void 
	{
		var pathToItem:String;
		
		for (item in FileSystem.readDirectory(path)) 
		{
			pathToItem = path + "/" + item;
			
			if (FileSystem.isDirectory(pathToItem)) 
			{
				walk(pathToItem);
			}
			else if(item.split(".").pop() == "hx") 
			{
				trace(File.getContent(pathToItem));
			}
		}
	}
}