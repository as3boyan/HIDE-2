package ;

import haxe.Timer;
import haxe.xml.Fast;
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
			TabManager.saveActiveFile(function ()
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
					projectArguments.push("--display");
					
					projectArguments.push(TabManager.getCurrentDocumentPath() + "@" + Std.string(data.doc.indexFromPos(data.from)));
					
					trace(projectArguments);
					trace(ProjectAccess.currentProject.path);
					
					HaxeCompletionClient.runProcess("haxe", ["--connect", "6001", "--cwd", ProjectAccess.currentProject.path].concat(projectArguments), function (stderr:String)
					{
						var xml:Xml = Xml.parse(stderr);
						
						var fast = new Fast(xml);
						
						if (fast.hasNode.list)
						{
							var list = fast.node.list;
							
							if (list.hasNode.i)
							{
								for (item in list.nodes.i) 
								{
									if (item.has.n)
									{
										var completion:Dynamic = { name:item.att.n };
										
										if (item.hasNode.d)
										{
											var str = StringTools.trim(item.node.d.innerHTML);
											str = StringTools.replace(str, "\t", "");
											str = StringTools.replace(str, "\n", "");
											str = StringTools.replace(str, "*", "");
											str = StringTools.replace(str, "&lt;", "<");
											str = StringTools.replace(str, "&gt;", ">");
											str = StringTools.trim(str);
											completion.doc = str;
										}
										
										if (item.hasNode.t)
										{
											var type = item.node.t.innerData;
											trace(type);
											switch (type) 
											{
												case "Float", "Int":
													completion.type = "number";
												case "Bool":
													completion.type = "bool";
												case "String":
													completion.type = "string";
												default:
													completion.type = "fn()";
											}
										}
										else 
										{
											completion.type = "fn()";
										}
										
										data.data.completions.push(completion);
									}
								}
							}
						}
							
						completions = data.data.completions;
						
						new JQuery(Browser.document).triggerHandler("processHint", data);
					}, 
					function (code:Int, stderr:String)
					{
						trace(code);
						trace(stderr);
					}
					);
				}
			});
			
			
		});
	}
	
}