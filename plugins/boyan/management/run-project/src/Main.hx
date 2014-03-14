package ;
import js.Browser;
import js.html.TextAreaElement;
import js.Node;
import nodejs.webkit.Shell;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.management.run-project";
	public static var dependencies:Array<String> = [
	"boyan.bootstrap.project-options",
	"boyan.compilation.client",
	"boyan.management.project-access", 
	"boyan.bootstrap.menu",
	"boyan.bootstrap.tab-manager",
	"boyan.bootstrap.alerts",
	"boyan.utils",
	"boyan.codemirror.editor"
	];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ()
		{
			BootstrapMenu.getMenu("Project", 80).addMenuItem("Run", 1, runProject, "F5");
			BootstrapMenu.getMenu("Project").addMenuItem("Build", 2, buildProject, "F8");
			BootstrapMenu.getMenu("Project").addMenuItem("Set this hxml as project build file", 3, setHxmlAsProjectBuildFile);
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
			HIDE.notifyLoadingComplete(name);
		}
		);
	}
	
	private static function setHxmlAsProjectBuildFile():Void
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
			Alerts.showAlert("Done");
		}
		else 
		{
			Alerts.showAlert("Currently active document is not a hxml file");
		}
	}
	
	private static function runProject():Void
	{		
		buildProject(function ()
		{			
			switch (ProjectAccess.currentProject.runActionType) 
			{
				case Project.URL:
					Shell.openExternal(ProjectAccess.currentProject.runActionText);
				case Project.FILE:
					var path:String = ProjectAccess.currentProject.runActionText;
					
					js.Node.fs.exists(path, function (exists:Bool)
					{
						if (!exists)
						{
							path = js.Node.path.join(ProjectAccess.currentProject.path, path);
						}
						
						Shell.openItem(path);
					}
					);
				case Project.COMMAND:
					HaxeClient.buildProject(preprocessCommand(ProjectAccess.currentProject.runActionText));
				default:
					
			}
		}
		);
	}
	
	private static function buildProject(?onComplete:Dynamic):Void
	{		
		if (ProjectAccess.currentProject.path == null)
		{
			Alerts.showAlert("Please open or create project first!");
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
								checkHxml(dirname, filename, hxmlData);
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
						hxmlData = CM.editor.getValue();	
						checkHxml(dirname, filename, hxmlData);
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
					
					HaxeClient.buildProject(command, onComplete);			
				}
			}
			);
		}
	}
	
	private static function checkHxml(dirname:String, filename:String, hxmlData:String)
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
		
		buildHxml(dirname, filename, useCompilationServer, startCommandLine);
	}
	
	private static function buildHxml(dirname:String, filename:String, ?useCompilationServer:Bool = true, ?startCommandLine:Bool = false)
	{
		var command:String = "";
		
		if (startCommandLine) 
		{
			switch (Utils.os) 
			{
				case Utils.WINDOWS:
					command = "start";
				default:
					command = "bash";
			}
			
			command += " ";
		}
		
		var compilationServer:String = "";
		
		if (useCompilationServer) 
		{
			compilationServer = "--connect 6001";
		}
		
		HaxeClient.buildProject(command + "haxe " + "--cwd " + dirname + " " + compilationServer +  " " + filename);
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
