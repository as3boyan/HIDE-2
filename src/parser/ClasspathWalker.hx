package parser;
import core.ProcessHelper;
import core.Utils;
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
	public static var pathToHaxeStd:String;
	public static var haxeStdFileList:Array<String>;
	public static var haxeStdClassList:Array<String>;
	
	public static function load():Void 
	{
		haxeStdFileList = [];
		haxeStdClassList = [];
		
		var localStorage2 = Browser.getLocalStorage();
		
		var paths:Array<String> = [Node.process.env.HAXEPATH, Node.process.env.HAXE_STD_PATH, Node.process.env.HAXE_HOME];
		
		if (localStorage2 != null) 
		{
			paths.insert(0, localStorage2.getItem("pathToHaxe"));
		}
		
		switch (Utils.os) 
		{
			case Utils.WINDOWS:
				paths.push("C:/HaxeToolkit/haxe");
			case Utils.LINUX, Utils.MAC:
				paths.push("/usr/lib/haxe");
			default:
				
		}
		
		for (envVar in paths)
		{
			if (envVar != null) 
			{
				pathToHaxeStd = getHaxeStdFolder(envVar);
				
				if (pathToHaxeStd != null) 
				{
					localStorage2.setItem("pathToHaxe", pathToHaxeStd);
					break;
				}
			}
		}
		
		if (pathToHaxeStd == null) 
		{
			DialogManager.showBrowseFolderDialog("Please specify path to Haxe compiler(parent folder of std): ", function (path:String):Void 
			{
				pathToHaxeStd = getHaxeStdFolder(path);
				
				if (pathToHaxeStd != null) 
				{
					parseClasspath(pathToHaxeStd, true);
					localStorage2.setItem("pathToHaxe", pathToHaxeStd);
					DialogManager.hide();
				}
				else 
				{
					Alertify.error(LocaleWatcher.getStringSync("Can't find 'std' folder in specified path"));
				}
			});
		}
		else 
		{
			parseClasspath(pathToHaxeStd, true);
		}
	}
	
	static function getHaxeStdFolder(path:String):String
	{
		var pathToStd:String = null;
		
		if (Node.fs.existsSync(path)) 
		{
			if (Node.fs.existsSync(Node.path.join(path, "Std.hx"))) 
			{
				pathToStd = path;
			}
			else 
			{
				path = Node.path.join(path, "std");
				
				if (Node.fs.existsSync(path))
				{
					pathToStd = getHaxeStdFolder(path);
				}
			}
		}
		
		return pathToStd;
	}
	
	public static function parseProjectArguments():Void 
	{
		ClassParser.classCompletions = new StringMap();
		ClassParser.filesList = [];
		
		var relativePath:String;
		
		for (item in haxeStdFileList) 
		{
			relativePath = Node.path.relative(ProjectAccess.path, item);
			
			ClassParser.filesList.push(relativePath);
		}
		
		ClassParser.classList = haxeStdClassList.copy();
		
		if (ProjectAccess.path != null) 
		{
			switch (ProjectAccess.currentProject.type) 
			{
				case Project.HAXE:
					getClasspaths(ProjectAccess.currentProject.args);
				case Project.HXML:
					var path:String = Node.path.join(ProjectAccess.path, ProjectAccess.currentProject.main);
					
					var options:js.Node.NodeFsFileOptions = { };
					options.encoding = NodeC.UTF8;
					
					var data:String = Node.fs.readFileSync(path, options);
					getClasspaths(data.split("\n"));
				case Project.OPENFL:
					OpenFLTools.getParams(ProjectAccess.path, ProjectAccess.currentProject.openFLTarget, function (stdout:String):Void 
					{
						getClasspaths(stdout.split("\n"));
					});
				default:
					
			}
		}
		
		walkProjectFolder(ProjectAccess.path);
	}
	
	static function getClasspaths(data:Array<String>)
	{
		var classpaths:Array<String> = [];
		
		for (arg in parseArg(data, "-cp")) 
		{
			var classpath:String = Node.path.resolve(ProjectAccess.path, arg);
			classpaths.push(classpath);
		}
		
		for (path in classpaths) 
		{
			parseClasspath(path);
		}
		
		var libs:Array<String> = parseArg(data, "-lib");
		
		processHaxelibs(libs, parseClasspath);
	}
	
	static function processHaxelibs(libs:Array<String>, onPath:String->Bool->Void):Void 
	{		
		for (arg in libs) 
		{
			ProcessHelper.runProcess("haxelib", ["path", arg], null, function (stdout:String, stderr:String):Void 
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
								onPath(path, false);
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
		var emitter = Walkdir.walk(path, {});
		
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		emitter.on("file", function (path, stat):Void 
		{
			var pathToFile;
			
			if (std) 
			{
				haxeStdFileList.push(path);
			}

			if (ProjectAccess.path != null) 
			{
				pathToFile = Node.path.relative(ProjectAccess.path, path);
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
						ClassParser.processFile(data, path, std);
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
		var emitter = Walkdir.walk(path, {});
		
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		emitter.on("file", function (path, stat):Void 
		{
			if (!StringTools.startsWith(path, ".git")) 
			{
				var relativePath = Node.path.relative(ProjectAccess.path, path);
				
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