package core;
import haxe.ds.StringMap.StringMap;
import tabmanager.TabManager;

typedef Info = {
	var from:CodeMirror.Pos;
	var to:CodeMirror.Pos;
	var message:String;
	var severity:String;
}

/**
 * ...
 * @author 
 */
class HaxeLint
{
	public static var fileData:StringMap<Array<Info>> = new StringMap();
	public static var parserData:StringMap<Array<Info>> = new StringMap();

	public static function prepare():Void
	{
		CodeMirror.registerHelper("lint", "haxe", function (text:String) 
		{
			var found = [];
			
			var path:String = TabManager.getCurrentDocumentPath();
			
			if (fileData.exists(path)) 
			{
				var data:Array<Info> = fileData.get(path);
				
				found = found.concat(data);
			}
			
			if (parserData.exists(path)) 
			{
				var data:Array<Info> = parserData.get(path);
				
				found = found.concat(data);
			}
			
			return found;
		}
		);
	}
	
}