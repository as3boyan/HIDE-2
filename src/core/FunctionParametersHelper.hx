package core;
import cm.CodeMirrorEditor;
import core.Completion.CompletionItem;
import js.Browser;
import js.html.DivElement;
import js.html.SpanElement;
import js.Node;
import tabmanager.TabManager;

/**
 * ...
 * @author AS3
 */
class FunctionParametersHelper
{
	public static var widgets:Array<Dynamic> = [];
	static var lines:Array<Int> = [];
	
	public static function addWidget(text:String, description:String, lineNumber:Int):Void
	{
		var msg:DivElement = Browser.document.createDivElement();
		//var icon:SpanElement = Browser.document.createSpanElement();
		//msg.appendChild(icon);
		//icon.className = "lint-error-icon";
		msg.className = "lint-error";
		
		var spanText:SpanElement = Browser.document.createSpanElement();
		spanText.textContent = text;
		msg.appendChild(spanText);
		
		if (description != null) 
		{
			msg.appendChild(Browser.document.createBRElement());
			var spanDescription:SpanElement = Browser.document.createSpanElement();
			spanDescription.textContent = description;
			msg.appendChild(spanDescription);
		}
		
		var widget = CodeMirrorEditor.editor.addLineWidget(lineNumber, msg, { coverGutter: false, noHScroll: true } );
		widgets.push(widget);
		
		lines.push(lineNumber);
	}
	
	public static function alreadyShown(lineNumber:Int):Bool
	{
		return lines.indexOf(lineNumber) != -1;
	}
	
	public static function updateScroll():Void
	{
		var info = CodeMirrorEditor.editor.getScrollInfo();
		var after = CodeMirrorEditor.editor.charCoords( { line: CodeMirrorEditor.editor.getCursor().line + 1, ch: 0 }, "local").top;
		
		if (info.top + info.clientHeight < after)
		{
			CodeMirrorEditor.editor.scrollTo(null, after - info.clientHeight + 3);
		}
	}
	
	public static function clear():Void
	{
		for (widget in widgets) 
		{
			CodeMirrorEditor.editor.removeLineWidget(widget);
		}
		
		lines = [];
	}
	
	public static function update(cm:CodeMirror):Void
	{
		var extname:String = Node.path.extname(TabManager.getCurrentDocumentPath());
			
		if (extname == ".hx" && !cm.state.completionActive) 
		{			
			var cursor = cm.getCursor();
			var data = cm.getLine(cursor.line);			
			
			if (cursor != null && data.charAt(cursor.ch - 1) != ".")
			{
				scanForBracket(cm, cursor);
			}
		}
	}
	
	static function scanForBracket(cm:CodeMirror, cursor:CodeMirror.Pos):Void
	{
		//{bracketRegex: untyped __js__("/[([\\]]/")}
		var bracketsData = cm.scanForBracket(cursor, -1, null);
		
		if (bracketsData != null && bracketsData.ch == "(") 
		{
			var pos = {line:bracketsData.pos.line, ch:bracketsData.pos.ch};
			
			if (!FunctionParametersHelper.alreadyShown(pos.line)) 
			{						
				getFunctionParams(cm, pos);				
			}
		}
		else 
		{
			FunctionParametersHelper.clear();
		}
	}
	
	static function getFunctionParams(cm:CodeMirror, pos:CodeMirror.Pos):Void
	{
		var word = Completion.getCurrentWord(cm, {}, {line:pos.line, ch:pos.ch - 1});
				
		TabManager.saveActiveFile(function ():Void 
		{
			Completion.getCompletion(function ()
			{
				var found:Bool = false;
				
				for (completion in Completion.completions) 
				{							
					if (word == completion.n) 
					{							
						var text = parseFunctionParams(completion);
						
						var description = parseDescription(completion);
						
						FunctionParametersHelper.clear();
						FunctionParametersHelper.addWidget(text, description, cm.getCursor().line);
						FunctionParametersHelper.updateScroll();
						found = true;
						break;
					}
				}
				
				if (!found) 
				{
					FunctionParametersHelper.clear();
				}
			}
			, {line: pos.line, ch: pos.ch - 1});
		}
		);
	}
	
	static function parseDescription(completion:CompletionItem)
	{
		var description = completion.d;
						
		if (description != null) 
		{
			if (description.indexOf(".") != -1) 
			{
				description = description.split(".")[0];
			}
		}
		
		return description;
	}
	
	static function parseFunctionParams(completion:CompletionItem)
	{
		var info:String = "(";
						
		var args:Array<String> = completion.t.split("->");
		
		if (args.length > 2) 
		{
			for (i in 0...args.length - 1) 
			{
				info += args[i];
				
				if (i != args.length - 2) 
				{
					info += ", ";
				}
			}
			
			info += "):" + args[args.length - 1];
		}
		else 
		{
			info += "):" + args[args.length - 1];
		}
		
		return "function " + completion.n + info;
	}
}