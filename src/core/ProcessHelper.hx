package core;
import haxe.ds.StringMap;
import jQuery.JQuery;
import js.Browser;
import js.html.AnchorElement;
import js.html.TextAreaElement;
import js.Node;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;

/**
 * ...
 * @author 
 */
@:keepSub @:expose("ProcessHelper") class ProcessHelper
{
	private static var processStdout:String;
	private static var processStderr:String;
	
	public static function runProcess(process:String, params:Array<String>, onComplete:String->String->Void, ?onFailed:Int->String->String->Void):NodeChildProcess
	{		
		var command:String = process + " " + params.join(" ");
		
		//trace(command);
		
		var process:NodeChildProcess = Node.child_process.exec(command, { }, function (error, stdout:String, stderr:String):Void
		{			
			//if (stdout != "")
			//{
				//trace("stdout:\n" + stdout);
			//}
			//
			//if (stderr != "")
			//{
				//trace("stderr:\n" + stderr);
			//}
			
			if (error == null)
			{				
				onComplete(stdout, stderr);
			}
			else if (onFailed != null)
			{
				onFailed(error.code, stdout, stderr);
			}
		}
		);
		
		return process;
	}
	
	public static function runProcessAndPrintOutputToConsole(process:String, params:Array<String>, ?onComplete:Void->Void):NodeChildProcess
	{
		var command:String = process + " " + params.join(" ");
		
		var textarea = cast(Browser.document.getElementById("outputTextArea"), TextAreaElement);
		textarea.value = "Build started\n";
		textarea.value += command + "\n";
		
		new JQuery("#errors").html("");
		
		var process:NodeChildProcess = Node.child_process.exec(command, { }, function (error, stdout:String, stderr:String):Void
		{
			if (StringTools.trim(stdout) != "")
			{
				textarea.value += "stdout:\n" + stdout;
				trace("stdout:\n" + stdout);
			}
			
			HaxeLint.fileData = new StringMap();
			
			if (stderr != "")
			{
				var lines = stderr.split("\n");
				
				for (line in lines) 
				{
					if (line.indexOf(":") != 0) 
					{
						var args:Array<String> = line.split(":");
						
						if (args.length > 3) 
						{
							var relativePath:String = args[0];
							var fullPath:String = Node.path.join(ProjectAccess.currentProject.path, relativePath);
							
							var data:Array<HaxeLint.Info> = [];
							
							HaxeLint.fileData.set(fullPath, data);
							
							var lineNumber:Int = Std.parseInt(args[1]) - 1;
							
							var charsData:Array<String> = StringTools.trim(args[2]).split(" ")[1].split("-");
							
							var start:Int = Std.parseInt(charsData[0]);
							var end:Int = Std.parseInt(charsData[1]);
							
							var message:String = "";
							
							for (i in 3...args.length) 
							{
								message += args[i];
								
								if (i != args.length - 1) 
								{
									message += ":";
								}
							}
							
							var a:AnchorElement = Browser.document.createAnchorElement();
							a.href = "#";
							a.className = "list-group-item";
							a.innerText = line;
							a.onclick = function (e)
							{
								TabManager.openFileInNewTab(fullPath, true, function ():Void 
								{
									untyped CodeMirrorEditor.editor.centerOnLine(lineNumber);
								});
								
							};
							
							new JQuery("#errors").append(a);
							
							var info:HaxeLint.Info = { from: CodeMirrorPos.from(lineNumber, start), to: CodeMirrorPos.from(lineNumber, end), message: message, severity: "error" };
							trace(info);
							data.push(info);
							
							//Check if it's open
							//Show hints when swithing document
							TabManager.openFileInNewTab(fullPath, false);
						}
					}
				}
                
				cm.CodeMirrorEditor.editor.setOption("lint", true);                                                                                     
				
				textarea.value += "stderr:\n" + stderr;
				trace("stderr:\n" + stderr);
			}
			
			if (error == null) 
			{
				textarea.value += "Build complete\n";
				
				if (onComplete != null)
				{
					onComplete();
				}
				
				new JQuery("#buildStatus").fadeIn();
			}
			else 
			{
				trace(command);
				textarea.value += "Build failed (exit code: " + Std.string(error.code) +  ")\n" ;
				
				new JQuery("#buildStatus").fadeOut();
			}
		}
		);
		
		return process;
	}
	
	public static function runPersistentProcess(process:String, params:Array<String>, ?onClose:String->String->Void):NodeChildProcess
	{
		processStdout = "";
		processStderr = "";
		
		var process:NodeChildProcess = Node.child_process.spawn(process, params, { } );
		
		process.stdout.setEncoding(NodeC.UTF8);
		process.stdout.on("data", function (data:String)
		{
			processStdout += data;
		}
		);
		
		process.stderr.setEncoding(NodeC.UTF8);
		process.stderr.on("data", function (data:String)
		{
			processStderr += data;
		}
		);
		
		process.on("close", function (code:Int)
		{
			trace(processStdout);
			trace(processStderr);
			
			if (onClose != null) 
			{
				onClose(processStdout, processStderr);
			}
			
			if (code != 0)
			{
				process = null;
			}
			
			trace('started process quit with exit code ' + code);
		}
		);	
		
		return process;
	}
}