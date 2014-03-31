package parser;
import core.ProcessHelper;
import dialogs.BrowseFolderDialog;
import dialogs.DialogManager;
import dialogs.ModalDialog;
import haxe.ds.StringMap.StringMap;
import js.Browser;
import js.Node;
import js.node.Walkdir;
import openflproject.OpenFLTools;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import watchers.LocaleWatcher;

/**
 * ...
 * @author 
 */
class ClasspathWalker
{
	public static var pathToHaxe:String;
	
	public static function load():Void 
	{
		var localStorage2 = Browser.getLocalStorage();
		
		if (localStorage2 != null) 
		{
			pathToHaxe = localStorage2.getItem("pathToHaxe");
		}
		
		if (pathToHaxe == null) 
		{
			pathToHaxe = Node.process.env.HAXEPATH;
			
			if (pathToHaxe == null) 
			{
				pathToHaxe = Node.process.env.HAXE_STD_PATH;
				
				if (pathToHaxe != null) 
				{
					pathToHaxe = Node.path.dirname(pathToHaxe);
				}
				
				//pathToHaxe = Node.process.env.HAXE_HOME;
			}
			
			DialogManager.showBrowseFolderDialog("Please specify path to Haxe compiler(parent folder of std): ", function (path:String):Void 
			{
				var pathToHaxeStd = Node.path.join(path, "std");
				
				Node.fs.exists(pathToHaxeStd, function (exists:Bool):Void 
				{
					if (exists) 
					{
						parseClasspath(pathToHaxe, true);
						localStorage2.setItem("pathToHaxe", pathToHaxe);
					}
					else 
					{
						Alertify.error(LocaleWatcher.getStringSync("Can't find 'std' folder in specified path"));
					}
				}
				);
			}, pathToHaxe);
		}
		else 
		{
			pathToHaxe = Node.path.join(pathToHaxe, "std");
			parseClasspath(pathToHaxe, true);
		}
	}
	
	public static function parseProjectArguments():Void 
	{
		ClassParser.classCompletions = new StringMap();
		ClassParser.filesList = [];
		ClassParser.classList = [];
		
		load();
		
		if (ProjectAccess.currentProject.path != null) 
		{
			switch (ProjectAccess.currentProject.type) 
			{
				case Project.HAXE:
					getClasspaths(ProjectAccess.currentProject.args);
				case Project.HXML:
					var path:String = Node.path.join(ProjectAccess.currentProject.path, ProjectAccess.currentProject.main);
					
					var options:js.Node.NodeFsFileOptions = { };
					options.encoding = js.Node.NodeC.UTF8;
					
					var data:String = Node.fs.readFileSync(path, options);
					getClasspaths(data.split("\n"));
				case Project.OPENFL:
					OpenFLTools.getParams(ProjectAccess.currentProject.path, ProjectAccess.currentProject.openFLTarget, function (stdout:String):Void 
					{
						getClasspaths(stdout.split("\n"));
					});
				default:
					
			}
		}
		
		walkProjectFolder(ProjectAccess.currentProject.path);
	}
	
	private static function getClasspaths(data:Array<String>)
	{
		var classpaths:Array<String> = [];
		
		for (arg in parseArg(data, "-cp")) 
		{
			var classpath:String = Node.path.resolve(ProjectAccess.currentProject.path, arg);
			classpaths.push(classpath);
		}
		
		for (path in classpaths) 
		{
			parseClasspath(path);
		}
		
		var libs:Array<String> = parseArg(data, "-lib");
		
		processHaxelibs(libs, function (path:String):Void 
		{
			parseClasspath(path);
		});
	}
	
	static function processHaxelibs(libs:Array<String>, onPath:String->Void):Void 
	{		
		for (arg in libs) 
		{
			ProcessHelper.runProcess("haxelib", ["path", arg], function (stdout:String, stderr:String):Void 
			{
				for (path in stdout.split("\n")) 
				{
					if (path.indexOf(Node.path.sep) != -1) 
					{
						path = StringTools.trim(path);
						path = Node.path.normalize(path);
						
						Node.fs.exists(path, function (exists:Bool)
						{
							if (exists) 
							{
								onPath(path);
							}
						}
						);
					}
				}
			}
			);
		}
	}
	
	private static function parseArg(args:Array<String>, type:String):Array<String>
	{
		var result:Array<String> = [];
		
		for (arg in args)
		{
			arg = StringTools.trim(arg);
			
			if (StringTools.startsWith(arg, type)) 
			{
				result.push(arg.substr(type.length + 1));
			}
		}
		
		return result;
	}
	
	static function parseClasspath(path:String, ?std:Bool = false):Void
	{
		var emitter = Walkdir.walk(path);
		
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		emitter.on("file", function (path, stat):Void 
		{
			var pathToFile;
			
			if (ProjectAccess.currentProject.path != null) 
			{
				pathToFile = Node.path.relative(ProjectAccess.currentProject.path, path);
			}
			else 
			{
				pathToFile = path;
			}
			
			if (ClassParser.filesList.indexOf(pathToFile) == -1) 
			{
				ClassParser.filesList.push(pathToFile);
			}
			
			if (Node.path.extname(path) == ".hx") 
			{
				Node.fs.readFile(path, options, function (error:NodeErr, data:String):Void 
				{
					if (error == null) 
					{
						ClassParser.processFile(data, path);
					}
				}
				);
			}
		}
		);
		
		emitter.on("end", function ():Void 
		{
			//trace("end");
		}
		);
		
		emitter.on("error", function (path:String, stat):Void 
		{
			trace(path);
		}
		);
	}
	
	static function walkProjectFolder(path:String):Void 
	{
		var emitter = Walkdir.walk(path);
		
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		emitter.on("file", function (path, stat):Void 
		{
			if (!StringTools.startsWith(path, ".git")) 
			{
				var relativePath = Node.path.relative(ProjectAccess.currentProject.path, path);
				
				if (ClassParser.filesList.indexOf(relativePath) == -1 && ClassParser.filesList.indexOf(path) == -1) 
				{
					ClassParser.filesList.push(relativePath);
				}
			}
		}
		);
		
		emitter.on("error", function (path:String, stat):Void 
		{
			trace(path);
		}
		);
	}
	
}