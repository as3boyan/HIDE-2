package openproject;
import core.FileDialog;
import core.RecentProjectsList;
import core.Splitter;
import filetree.FileTree;
import haxe.Serializer;
import haxe.Unserializer;
import jQuery.JQuery;
import js.Browser;
import js.html.TextAreaElement;
import js.Node;
import openflproject.OpenFLTools;
import parser.ClasspathWalker;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import projectaccess.ProjectOptions;
import tabmanager.TabManager;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
class OpenProject
{	
	public static function openProject(?pathToProject:String, ?project:Bool = false):Void
	{
		if (pathToProject == null)
		{
			if (project) 
			{
				FileDialog.openFile(parseProject, ".json,.xml,.hxml");
			}
			else 
			{
				FileDialog.openFile(parseProject);
			}
		}
		else 
		{
			checkIfFileExists(pathToProject);
		}
	}
	
	private static function checkIfFileExists(path:String):Void
	{
		Node.fs.exists(path, function (exists:Bool)
		{
			if (exists) 
			{
				parseProject(path);
			}
			else 
			{
				trace("previously opened project: " + path + " was not found");
			}
		}
		);
	}
	
	private static function parseProject(path:String):Void
	{	
		trace("open: " + path);
		
		var filename:String = Node.path.basename(path);
			
		switch (filename) 
		{
			case "project.json":
				var options:NodeFsFileOptions = { };
				options.encoding = NodeC.UTF8;
				
				Node.fs.readFile(path, options, function (error:js.Node.NodeErr, data:String):Void
				{
					var pathToProject:String = js.Node.path.dirname(path);
					
					ProjectAccess.currentProject = parseProjectData(data);
					ProjectAccess.currentProject.path = pathToProject;
					
					if (ProjectAccess.currentProject.type == Project.HXML) 
					{
						TabManager.openFileInNewTab(Node.path.join(ProjectAccess.currentProject.path, ProjectAccess.currentProject.main));
					}
					
					ClasspathWalker.parseProjectArguments();
					
					if (ProjectAccess.currentProject.files == null) 
					{
						ProjectAccess.currentProject.files = [];
					}
					else 
					{
						for (file in ProjectAccess.currentProject.files) 
						{
							var fullPath:String = Node.path.join(pathToProject, file);
							
							Node.fs.exists(fullPath, function (exists:Bool) 
							{
								if (exists) 
								{
									TabManager.openFileInNewTab(fullPath);
								}
							}
							);
						}
						
						var activeFile = ProjectAccess.currentProject.activeFile;
						
						if (activeFile != null) 
						{
							Node.fs.exists(activeFile, function (exists:Bool)
							{
								if (exists) 
								{
									TabManager.selectDoc(Node.path.join(pathToProject, activeFile));
								}
							}
							);
						}
					}
					
					ProjectOptions.updateProjectOptions();
					//FileTree.load(ProjectAccess.currentProject.name, pathToProject);
					
					Splitter.show();
					
					Browser.getLocalStorage().setItem("pathToLastProject", path);
					RecentProjectsList.add(path);
				}
				);
			case "project.xml", "application.xml":
				var pathToProject:String = js.Node.path.dirname(path);
				
				var project:Project = new Project();
				project.name = pathToProject.substr(pathToProject.lastIndexOf(js.Node.path.sep));
				project.type = Project.OPENFL;
				project.openFLTarget = "flash";
				project.path = pathToProject;
				
				OpenFLTools.getParams(pathToProject, project.openFLTarget, function (stdout:String)
				{									
					var args:Array<String> = [];
				
					var currentLine:String;
					
					for (line in stdout.split("\n"))
					{
						currentLine = StringTools.trim(line);
						
						if (!StringTools.startsWith(currentLine, "#"))
						{
							args.push(currentLine);
						}
					}
					
					project.args = args;
					
					var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.json");
					
					ProjectAccess.currentProject = project;
					
					ProjectOptions.updateProjectOptions();
					
					ProjectAccess.save(function ()
					{
						//FileTree.load(project.name, pathToProject);
					}
					);
					
					Splitter.show();
					
					Browser.getLocalStorage().setItem("pathToLastProject", pathToProjectHide);
					RecentProjectsList.add(pathToProjectHide);
				}
				);
			default:				
				var extension:String = js.Node.path.extname(filename);
		
				switch (extension) 
				{
					case ".hxml":
						//js.Node.fs.readFile(path, js.Node.NodeC.UTF8, function (error:js.Node.NodeErr, data:String)
						//{
							var pathToProject:String = js.Node.path.dirname(path);
				//
							var project:Project = new Project();
							project.name = pathToProject.substr(pathToProject.lastIndexOf(js.Node.path.sep));
							project.type = Project.HXML;
							//project.args = data.split("\n");
							project.path = pathToProject;
							project.main = Node.path.basename(path);
							
							ProjectAccess.currentProject = project;
							ProjectOptions.updateProjectOptions();
							
							var pathToProjectHide:String = js.Node.path.join(pathToProject, "project.json");
							
							ProjectAccess.save(function ()
							{
								//FileTree.load(project.name, pathToProject);
							}
							);
							
							Splitter.show();
							
							Browser.getLocalStorage().setItem("pathToLastProject", pathToProjectHide);
							RecentProjectsList.add(pathToProjectHide);
						//}
						//);
					//case ".hx":
						//
					//case ".xml":
						//
					default:
						
				}
				
				TabManager.openFileInNewTab(path);
		}
	}
	
	public static function searchForLastProject():Void
	{
		var pathToLastProject:String = Browser.getLocalStorage().getItem("pathToLastProject");
		if (pathToLastProject != null)
		{
			openProject(pathToLastProject);
		}
	}
	
	public static function closeProject():Void
	{
		if (ProjectAccess.currentProject.path != null) 
		{
			ProjectAccess.save(updateProjectData);
		}
		else 
		{
			updateProjectData();
		}
	}
	
	static function updateProjectData()
	{
		ProjectAccess.currentProject.path = null;
		Splitter.hide();
		Browser.getLocalStorage().removeItem("pathToLastProject");
	}
	
	static function parseProjectData(data:String):Project
	{		
		var project:Project = null;
		
		try 
		{
			project = TJSON.parse(data);
		}
		catch (unknown:Dynamic)
		{
			trace(unknown);
			trace(data);
			project = Node.parse(data);
		}
		
		return project;
	}
	
}