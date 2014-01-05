package ;

/**
 * ...
 * @author AS3Boyan
 */
class OpenProject
{

	public function new() 
	{
		
	}
	
	public static function openProject():Void
	{
		FileDialog.openFile(function (path:String) 
		{ 
			var filename:String = js.Node.path.basename(path);
			
			switch (filename) 
			{
				case "project.hide":
					
				case "project.xml":
					
				default:
					
					var extension:String = js.Node.path.extname(filename);
			
					switch (extension) 
					{
						case ".hxml":
							
						default:
							
					}
			}
		} 
		);
	}
	
}