package parser;
import core.ProcessHelper;
import js.Node;
import js.node.Walkdir;
import projectaccess.Project;
import projectaccess.ProjectAccess;

/**
 * ...
 * @author 
 */
class ClasspathWalker
{
	public static function parseProjectArguments():Void 
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
			default:
				
		}
	}
	
	private static function getClasspaths(data:Array<String>)
	{
		var classpaths:Array<String> = [];
		
		classpaths.push("C:\\HaxeToolkit\\haxe\\std");
		
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
	
	static function parseClasspath(path:String):Void 
	{
		var emitter = Walkdir.walk(path);
		
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		
		emitter.on("file", function (path, stat):Void 
		{
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
		
		emitter.on("error", function (path:String, stat):Void 
		{
			trace(path);
		}
		);
	}
	
}