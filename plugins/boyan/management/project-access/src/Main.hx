package ;
import js.Browser;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.management.project-access";
	public static var dependencies:Array<String> = [];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{								
			//if (ProjectAccess.currentProject.type != null) 
			//{
				//
			//}
			//
			//var pathToProjectHide:String = js.Node.path.join(ProjectAccess.currentProject.path, "project.hide");
					//
			//js.Node.fs.writeFile(pathToProjectHide, Serializer.run(ProjectAccess.currentProject.project), js.Node.NodeC.UTF8, function (error:js.Node.NodeErr)
			//{
				//FileTree.load(project.name, pathToProject);
			//}
			//);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
}