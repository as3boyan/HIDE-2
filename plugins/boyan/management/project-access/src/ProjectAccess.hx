package ;
//import haxe.Serializer;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class ProjectAccess
{
	public static var currentProject:Project = new Project();
	
	public static function save():Void
	{
		//var pathToProjectHide:String = js.Node.path.join(ProjectAccess.currentProject.path, "project.hide");
		
		//trace(Serializer.run(ProjectAccess.currentProject));
		
		//js.Node.fs.writeFile(pathToProjectHide, Serializer.run(ProjectAccess.currentProject), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
		//{
			// 
		//}
		//);
	}
}