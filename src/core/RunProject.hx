package core;
import build.Hxml;
import cm.Editor;
import js.Browser;
import js.html.TextAreaElement;
import js.Node;
import menu.BootstrapMenu;
import nodejs.webkit.Shell;
import nodejs.webkit.Window;
import openproject.OpenProject;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;
import tjson.TJSON;
import watchers.LocaleWatcher;

/**
 * ...
 * @author AS3Boyan
 */
class RunProject
{	
	static var runProcess:NodeChildProcess;
	
	public static function cleanProject() 
	{
		
	}
	
	public static function setHxmlAsProjectBuildFile():Void
	{
		var path:String = TabManager.getCurrentDocumentPath();
		var extname:String = js.Node.path.extname(path);
		var isHxml:Bool = (extname == ".hxml");
		
		if (isHxml) 
		{
			var noproject:Bool = ProjectAccess.path == null;
			
			var project:Project = ProjectAccess.currentProject;
			project.type = Project.HXML;
			project.main = Node.path.basename(path);
			ProjectAccess.path = Node.path.dirname(path);
			ProjectAccess.save(function ():Void 
			{
				if (noproject) 
				{
					OpenProject.openProject(Node.path.join(ProjectAccess.path, "project.hide"));
				}
			}
			);
			Alertify.success(LocaleWatcher.getStringSync("Done"));
		}
		else 
		{
			Alertify.error(LocaleWatcher.getStringSync("Currently active document is not a hxml file"));
		}
	}
	
	public static function runProject():Void
	{		
		buildProject(null, function ()
		{
			var project = ProjectAccess.currentProject;
			
			var runActionType;
			var runActionText;
			
			switch (project.type) 
			{
				case Project.HAXE:
					var targetData:TargetData = project.targetData[project.target];
					
					runActionType = targetData.runActionType;
					runActionText = targetData.runActionText;
				default:
					runActionType = project.runActionType;
					runActionText = project.runActionText;
			}
			
			switch (runActionType) 
			{
				case Project.URL:
					var url:String = runActionText;
					
					if (isValidCommand(url)) 
					{
						Shell.openExternal(url);
					}
				case Project.FILE:
					var path:String = runActionText;
					
					if (isValidCommand(path)) 
					{
						js.Node.fs.exists(path, function (exists:Bool)
						{
							if (!exists)
							{
								path = js.Node.path.join(ProjectAccess.path, path);
							}
							
							Shell.openItem(path);
						}
						);
					}
				case Project.COMMAND:
					var command:String = runActionText;
					
					if (isValidCommand(command)) 
					{
						var params:Array<String> = preprocessCommand(command, ProjectAccess.path).split(" ");
						
						var process:String = params.shift();
						
						killRunProcess();
						
						runProcess = ProcessHelper.runPersistentProcess(process, params, null, true);
						
						var window:Window = Window.get();
		
						window.on("close", function (e)
						{
							killRunProcess();
							window.close();
						}
						);
					}
				default:
					
			}
		}
		);
	}
	
	static function killRunProcess():Void
	{
		trace(runProcess);
		
		if (runProcess != null) 
		{
			trace("kill");
			runProcess.kill();
		}
	}
	
	static function isValidCommand(command:String):Bool
	{
		var valid = false;
		
		if (command != null && StringTools.trim(command) != "")  
		{
			valid = true;
		}
		
		return valid;
	}
	
	public static function buildProject(?pathToProject:String, ?onComplete:Dynamic):Void
	{		
		var project:Project;
		
		if (pathToProject != null) 
		{
			var options:NodeFsFileOptions = { };
			options.encoding = NodeC.UTF8;
			
			var data:String = Node.fs.readFileSync(pathToProject, options);
			project = TJSON.parse(data);
			
			pathToProject = Node.path.dirname(pathToProject);
		}
		else 
		{
			project = ProjectAccess.currentProject;
			pathToProject = ProjectAccess.path;
		}
		
		buildSpecifiedProject(project, pathToProject, onComplete);
	}
	
	static function buildSpecifiedProject(project:Project, pathToProject:String,  onComplete:Dynamic)
	{
		if (pathToProject == null)
		{
			Alertify.error(LocaleWatcher.getStringSync("Please open or create project first!"));
		}
		else 
		{
			TabManager.saveAll(function ()
			{
				var path:String = TabManager.getCurrentDocumentPath();
				var extname:String = Node.path.extname(path);
				var buildHxml:Bool = (extname == ".hxml");
				
				var dirname:String = Node.path.dirname(path);
				var filename:String = Node.path.basename(path);
				
				if (buildHxml || project.type == Project.HXML || project.type == Project.HAXE)
				{
					var hxmlData:String;
					
					if (!buildHxml) 
					{
						dirname = pathToProject;
						
						switch (project.type) 
						{
							case Project.HXML:
								filename = project.main;
							case Project.HAXE:
								filename = project.targetData[project.target].pathToHxml;
							default:
								
						}
						
						var options:NodeFsFileOptions = { };
						options.encoding = NodeC.UTF8;
						
						Node.fs.readFile(Node.path.join(dirname, filename), options, function (err:js.NodeErr, data:String):Void
						{
							if (err == null) 
							{
								hxmlData = data;
								Hxml.checkHxml(dirname, filename, hxmlData, onComplete);
							}
							else 
							{
								trace(err);
							}
						}
						);
					}
					else 
					{
						hxmlData = Editor.editor.getValue();	
						Hxml.checkHxml(dirname, filename, hxmlData, onComplete);
					}
				}
				else
				{
					var command:String = project.buildActionCommand;
					command = preprocessCommand(command, pathToProject);
					
					//if (project.type == Project.HAXE)
					//{
						//command = [command].concat(project.args).join(" ");
					//}
					
					var params:Array<String> = preprocessCommand(command, pathToProject).split(" ");
					var process:String = params.shift();
					
					ProcessHelper.runProcessAndPrintOutputToConsole(process, params, onComplete);			
				}
			}
			);
		}
	}
	
	static function preprocessCommand(command:String, path:String):String
	{
		var processedCommand:String = command;
		
		processedCommand = StringTools.replace(processedCommand, "%path%", path);
		
		var ereg:EReg = ~/%join%[(](.+)[)]/;
		
		if (ereg.match(processedCommand))
		{
			var matchedString:String = ereg.matched(1);
			var arguments = matchedString.split(",");
			
			processedCommand = StringTools.replace(processedCommand, ereg.matched(0), js.Node.path.join(arguments[0], arguments[1]));
		}
		
		return processedCommand;
	}
}
