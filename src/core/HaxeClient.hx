package core;
import core.HaxeLint.Info;
import haxe.ds.StringMap.StringMap;
import js.Browser;
import js.html.TextAreaElement;
import js.Node;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeClient
{	
	public static function buildProject(command:String, ?onComplete:Dynamic):Void
	{		
		var textarea = cast(Browser.document.getElementById("outputTextArea"), TextAreaElement);
		textarea.value = "Build started\n";
		textarea.value += command + "\n";
		
		var haxeCompilerClient:js.Node.NodeChildProcess = js.Node.child_process.exec(command, { }, function (error, stdout:String, stderr:String):Void
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
							
							var data:Array<Info> = [];
							
							HaxeLint.fileData.set(fullPath, data);
							
							var pos = untyped __js__("CodeMirror.Pos");
							
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
							
							var info:Info = { from: pos(lineNumber, start), to: pos(lineNumber, end), message: message, severity: "error" };
							trace(info);
							data.push(info);
							
							//Check if it's open
							//Show hints when swithing document
							TabManager.openFileInNewTab(fullPath, false);
						}
					}
				}
                                                                                     
				cm.CodeMirrorEditor.editor.setOption("lint", "true");                                                                                     
				
				textarea.value += "stderr:\n" + stderr;
				trace("stderr:\n" + stderr);
			}
		}
		);
		
		haxeCompilerClient.on("close", function (code:Int):Void
		{
			if (code == 0)
			{
				textarea.value += "Build complete\n";
				
				if (onComplete != null)
				{
					onComplete();
				}
			}
			else 
			{
				trace(command);
				textarea.value += "Build failed (exit code: " + Std.string(code) +  ")\n" ;
			}
		}
		);
	}
}