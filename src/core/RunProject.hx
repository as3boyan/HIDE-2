package core;
import cm.CodeMirrorEditor;
import js.Browser;
import js.html.TextAreaElement;
import js.Node;
import menu.BootstrapMenu;
import nodejs.webkit.Shell;
import nodejs.webkit.Window;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;
import watchers.LocaleWatcher;

/**
 * ...
 * @author AS3Boyan
 */
class RunProject
{	
	static var runProcess:NodeChildProcess;
	
	public static function load():Void
	{
		BootstrapMenu.getMenu("Project", 80).addMenuItem("Run", 1, runProject, "F5");
		BootstrapMenu.getMenu("Project").addMenuItem("Build", 2, buildProject, "F8");
		BootstrapMenu.getMenu("Project").addMenuItem("Set this hxml as project build file", 3, setHxmlAsProjectBuildFile);
	}
	
	static function setHxmlAsProjectBuildFile():Void
	{
		var path:String = TabManager.getCurrentDocumentPath();
		var extname:String = js.Node.path.extname(path);
		var buildHxml:Bool = (extname == ".hxml");
		
		if (buildHxml) 
		{
			var project:Project = ProjectAccess.currentProject;
			project.type = Project.HXML;
			project.main = Node.path.basename(path);
			project.path = Node.path.dirname(path);
			ProjectAccess.save();
			Alertify.success(LocaleWatcher.getStringSync("Done"));
		}
		else 
		{
			Alertify.error(LocaleWatcher.getStringSync("Currently active document is not a hxml file"));
		}
	}
	
	static function runProject():Void
	{		
		buildProject(function ()
		{			
			switch (ProjectAccess.currentProject.runActionType) 
			{
				case Project.URL:
					var url:String = ProjectAccess.currentProject.runActionText;
					
					if (isValidCommand(url)) 
					{
						Shell.openExternal(url);
					}
				case Project.FILE:
					var path:String = ProjectAccess.currentProject.runActionText;
					
					if (isValidCommand(path)) 
					{
						js.Node.fs.exists(path, function (exists:Bool)
						{
							if (!exists)
							{
								path = js.Node.path.join(ProjectAccess.currentProject.path, path);
							}
							
							Shell.openItem(path);
						}
						);
					}
				case Project.COMMAND:
					var command:String = ProjectAccess.currentProject.runActionText;
					
					if (isValidCommand(command)) 
					{
						var params:Array<String> = preprocessCommand(command).split(" ");
						
						var process:String = params.shift();
						
						killRunProcess();
						
						runProcess = ProcessHelper.runProcessAndPrintOutputToConsole(process, params);
						
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
	
	static function buildProject(?onComplete:Dynamic):Void
	{		
		if (ProjectAccess.currentProject.path == null)
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
				
				if (buildHxml || ProjectAccess.currentProject.type == Project.HXML) 
				{
					var hxmlData:String;
					
					if (!buildHxml) 
					{
						dirname = ProjectAccess.currentProject.path;
						filename = ProjectAccess.currentProject.main;
						
						var options:js.Node.NodeFsFileOptions = { };
						options.encoding = js.Node.NodeC.UTF8;
						
						Node.fs.readFile(Node.path.join(dirname, filename), options, function (err:js.NodeErr, data:String):Void
						{
							if (err == null) 
							{
								hxmlData = data;
								checkHxml(dirname, filename, hxmlData, onComplete);
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
						hxmlData = CodeMirrorEditor.editor.getValue();	
						checkHxml(dirname, filename, hxmlData, onComplete);
					}
				}
				else 
				{
					var command:String = ProjectAccess.currentProject.buildActionCommand;
					command = preprocessCommand(command);
					
					if (ProjectAccess.currentProject.type == Project.HAXE)
					{
						command = [command].concat(ProjectAccess.currentProject.args).join(" ");
					}
					
					var params:Array<String> = preprocessCommand(command).split(" ");
					var process:String = params.shift();
					
					ProcessHelper.runProcessAndPrintOutputToConsole(process, params, onComplete);			
				}
			}
			);
		}
	}
	
	private static function checkHxml(dirname:String, filename:String, hxmlData:String, ?onComplete:Dynamic)
	{
		var useCompilationServer:Bool = true;
		var startCommandLine:Bool = false;
		
		if (hxmlData != null) 
		{
			if (hxmlData.indexOf("-cmd") != -1) 
			{
				startCommandLine = true;
			}
			
			if (hxmlData.indexOf("-cpp") != -1) 
			{
				useCompilationServer = false;
			}
			
		}
		
		buildHxml(dirname, filename, useCompilationServer, startCommandLine, onComplete);
	}
	
	private static function buildHxml(dirname:String, filename:String, ?useCompilationServer:Bool = true, ?startCommandLine:Bool = false, ?onComplete:Dynamic)
	{
		var params:Array<String> = [];
		
		if (startCommandLine) 
		{
			switch (Utils.os) 
			{
				case Utils.WINDOWS:
					params.push("start");
				default:
					params.push("bash");
			}
		}
		
		params = params.concat(["haxe", "--cwd", dirname]);
		
		if (useCompilationServer)
		{
			params = params.concat(["--connect", "5000"]);
		}
		
		params.push(filename);
		
		var process:String = params.shift();
		
		ProcessHelper.runProcessAndPrintOutputToConsole(process, params, onComplete);
	}
	
	private static function preprocessCommand(command:String):String
	{
		var processedCommand:String = command;
		
		processedCommand = StringTools.replace(processedCommand, "%path%", ProjectAccess.currentProject.path);
		
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
