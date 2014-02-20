package ;

import jQuery.JQuery;
import js.Browser;

/**
 * ...
 * @author AS3Boyan
 */

typedef CompletionItem = 
{
	var d:String;
	var t:String;
	var n:String;
}
 
class Completion
{
	static var completions:Dynamic;
	
	public function new() 
	{
		
	}
	
	public static function registerHandlers():Void
	{
		new JQuery(Browser.document).on("getCompletion", function (event, data:Dynamic):Void
		{                        
			if (CM.editor.state.completionActive != null && CM.editor.state.completionActive.widget != null)
			{
				data.data.completions = completions;
				new JQuery(Browser.document).triggerHandler("processHint", data);
			}
			else
			{                
				trace("get Haxe completion");
				
				var projectArguments:Array<String> = ProjectAccess.currentProject.args.copy();
		
				//projectArguments.push("-cp");
				//projectArguments.push("src");
				//
				//projectArguments.push("-lib");
				//projectArguments.push("jQueryExtern");
				//
				//projectArguments.push("-lib");
				//projectArguments.push("hxparse");
				//
				//projectArguments.push("-js");
				//projectArguments.push("./bin/includes / js / ide.js");
				//
				//projectArguments.push("-main");
				//projectArguments.push("Main");
				//
				//projectArguments.push("-cp");
				//projectArguments.push("./externs/nodejs - std / src");
				//
				//projectArguments.push("-cp");
				//projectArguments.push("./externs/codemirror");
				//
				//projectArguments.push("-cp");
				//projectArguments.push("./externs/json");
				//
				//projectArguments.push("-dce");
				//projectArguments.push("full");
				
				//projectArguments.push("-main Main2");
				//projectArguments.push("-swf Main2.swf");
				//projectArguments.push("-cp src");
				//
				
				//projectArguments = projectArguments.concat(ProjectAccess.currentProject.args);
				
				projectArguments.push("--display");
				
				//js.Node.path.basename
				//js.Node.path.join(ProjectAccess.currentProject.path,
				projectArguments.push(TabManager.getCurrentDocumentPath() + "@" + Std.string(data.doc.indexFromPos(data.from)));
				
				trace(projectArguments);
				trace(ProjectAccess.currentProject.path);
				
				HaxeCompletionClient.runProcess("haxe", ["--connect", "6001", "--cwd", ProjectAccess.currentProject.path].concat(projectArguments), function (stderr:String)
				{
					trace(stderr);
				}, 
				function (code:Int, stderr:String)
				{
					trace(code);
					trace(stderr);
				}
				);
				
				//HaxeClient.buildProject(process:String, projectArguments, ?onComplete:Dynamic);
				
				//HaxeClient.buildProject("haxe", ["--connect", "6001", "--cwd", js.Node.process.cwd()].concat(args), onComplete);
				
				//var haxeCompilerClient = js.Node.childProcess.spawn("haxe", ["--connect", "6001"].concat(projectArguments));
				//
				//var xml:String = "";
				//
				//haxeCompilerClient.stderr.setEncoding('utf8');
				//haxeCompilerClient.stderr.on('data', function (data) 
				//{
					//var str:String = data.toString();
					//xml += str;
				//});

				//haxeCompilerClient.on('close', function (code:Int) 
				//{				
					//if (code == 0)
					//{
						//var obj = untyped JQuery.xml2json(xml);
						//var array:Array<Dynamic> = cast(obj.i, Array<Dynamic>);
						//
						//var completionItem:CompletionItem;
						//
						//for (o in array)
						//{                        
							//data.data.completions.push( {name:o.n, type: "fn()" } );
						//}
						//
						//completions = data.data.completions;
						//
						//new JQuery(Browser.document).triggerHandler("processHint", data);
					//}
					//else
					//{
						//trace('haxeCompilerClient process exit code ' + Std.string(code));
						//trace(xml);
					//}
				//});
			}
		});
	}
	
}