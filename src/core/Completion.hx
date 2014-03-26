package core;
import cm.CodeMirrorEditor;
import CodeMirror;
import haxe.ds.StringMap.StringMap;
import haxe.xml.Fast;
import parser.ClassParser;
import projectaccess.Project;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;
/**
 * ...
 * @author AS3Boyan
 */

typedef CompletionItem = 
{
	@:optional
	var d:String;
	@:optional
	var t:String;
	var n:String;
}
 
class Completion
{
	static var list:Array<String>;
	static var seen:StringMap<Bool>;
	static var editor:CodeMirror;
	static var word:EReg;
	static var range:Int;
	static var cur:Pos;
	static private var end:Int;
	static private var start:Int;
	static var WORD:EReg = ~/[A-Z]+$/i;
	static var RANGE = 500;
	public static var curWord:String;
	public static var completions:Array<CompletionItem> = [];
	
	public static function registerHelper() 
	{
		CodeMirror.registerHelper("hint", "haxe", function(cm:CodeMirror, options) {			
			word = null;
			
			range = null;
			
			if (options != null && options.range != null)
			{
				range = options.range;
			}
			else if (RANGE != null)
			{
				range = RANGE;
			}
			
			getCurrentWord(cm, options);

			list = new Array();
			seen = new StringMap();
			
			for (completion in completions) 
			{
				list.push(completion.n);
			}
			
			//if (list.length == 0) 
			//{
				//scan(cm, -1);
				//scan(cm, 1);
			//}
			
			list = list.concat(ClassParser.classList);
			
			filterCompletion();
			
			return {list: list, from: CodeMirrorPos.from(cur.line, start), to: CodeMirrorPos.from(cur.line, end)};
		});
	}
	
	public static function getCurrentWord(cm:CodeMirror, ?options:Dynamic, ?pos:Pos):String
	{
		if (options != null && options.word != null)
		{
			word = options.word;
		}
		else if (WORD != null)
		{
			word = WORD;
		}
		
		if (pos != null) 
		{
			cur = pos;
		}
		
		var curLine:String = cm.getLine(cur.line);
		start = cur.ch;
		
		end = start;
		
		while (end < curLine.length && word.match(curLine.charAt(end))) ++end;
		while (start > 0 && word.match(curLine.charAt(start - 1))) --start;
		
		curWord = null;
		
		if (start != end) 
		{
			curWord = curLine.substring(start, end);
		}
		
		return curWord;
	}
	
	private static function scan(cm:Dynamic, dir:Int):Void
	{			
		var line:Int = cur.line;
		var end2 = Math.min(Math.max(line + dir * range, cm.firstLine()), cm.lastLine()) + dir;
		while (line != end2) 
		{
			var text = cm.getLine(line);
			var m:Dynamic = null;
			
			var re:EReg = ~/([A-Z]+)/ig;
			
			re.map(text, function(e:EReg):String
			{
				m = e.matched(0);
				
				if (!(line == cur.line) || !(m == curWord))
				{
					if ((curWord == null || m.indexOf(curWord) == 0) && !seen.exists(m)) 
					{
						seen.set(m, true);
						list.push(m);
					}
				}
				
				return e.matched(0);
			}
			);
			
			line += dir;
		}
	}
	
	public static function getCompletion(onComplete:Dynamic, ?_pos:Pos)
	{
		var projectArguments:Array<String> = ProjectAccess.currentProject.args.copy();
					
		if (ProjectAccess.currentProject.type == Project.HXML) 
		{
			projectArguments.push(ProjectAccess.currentProject.main);
		}
		
		projectArguments.push("--display");
		
		var cm:CodeMirror = CodeMirrorEditor.editor;
		cur = _pos;
		
		if (_pos == null) 
		{
			cur = cm.getCursor();
		}
		
		getCurrentWord(cm, null);
		
		if (curWord != null) 
		{
			cur = CodeMirrorPos.from(cur.line, start);
		}
		
		projectArguments.push(TabManager.getCurrentDocumentPath() + "@" + Std.string(cm.indexFromPos(cur)));
		
		Completion.completions = [];
		
		ProcessHelper.runProcess("haxe", ["--connect", "5000", "--cwd", HIDE.surroundWithQuotes(ProjectAccess.currentProject.path)].concat(projectArguments), function (stdout:String, stderr:String)
		{
			var xml:Xml = Xml.parse(stderr);
			
			var fast = new Fast(xml);
			
			if (fast.hasNode.list)
			{
				var list = fast.node.list;
				
				var completion:CompletionItem;
				
				if (list.hasNode.i)
				{
					for (item in list.nodes.i) 
					{
						if (item.has.n)
						{
							completion = {n: item.att.n};
														
							if (item.hasNode.d)
							{
								var str = StringTools.trim(item.node.d.innerHTML);
								str = StringTools.replace(str, "\t", "");
								str = StringTools.replace(str, "\n", "");
								str = StringTools.replace(str, "*", "");
								str = StringTools.replace(str, "&lt;", "<");
								str = StringTools.replace(str, "&gt;", ">");
								str = StringTools.trim(str);
								completion.d = str;
							}
							
							if (item.hasNode.t)
							{
								completion.t = item.node.t.innerData;
								//var type = item.node.t.innerData;
								//switch (type) 
								//{
									//case "Float", "Int":
										//completion.type = "number";
									//case "Bool":
										//completion.type = "bool";
									//case "String":
										//completion.type = "string";
									//default:
										//completion.type = "fn()";
								//}
							}
							//else 
							//{
								//completion.type = "fn()";
							//}
							
							completions.push(completion);
						}
					}
				}
			}
			
			onComplete();
		}, 
		function (code:Int, stdout:String, stderr:String)
		{
			trace(code);
			trace(stderr);
			
			onComplete();
		}
		);
	}
	
	private static function filterCompletion()
	{
		if (curWord != null) 
		{
			var filtered_results = [];
			var sorted_results = [];
			
			var word:String = curWord.toLowerCase();
			
			for (completion in list) 
			{
				var n = completion.toLowerCase();
				var b = true;
			  
				  for (j in 0...word.length)
				  {
					  if (n.indexOf(word.charAt(j)) == -1)
					  {
						  b = false;
						  break;
					  }
				  }

				if (b)
				{
					filtered_results.push(completion);
				}
			}
			
			var results = [];
			
			for (i in 0...filtered_results.length) 
			{
				if (filtered_results[i].toLowerCase().indexOf(word) == 0)
				{
					sorted_results.push(filtered_results[i]);
				}
				else 
				{
					results.push(filtered_results[i]);
				}
			}
			
			list = [];
			
			for (completion in sorted_results) 
			{
				list.push(completion);
			}
			
			for (completion in results) 
			{
				list.push(completion);
			}
		}
	}
}