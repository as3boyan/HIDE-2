package core;
import cm.CodeMirrorEditor;
import js.Browser;
import js.html.DivElement;
import js.html.SpanElement;

/**
 * ...
 * @author AS3
 */
class FunctionParametersHelper
{
	public static var widgets:Array<Dynamic> = [];
	
	public static function addWidget(text:String, lineNumber:Int):Void
	{
		var msg:DivElement = Browser.document.createDivElement();
		//var icon:SpanElement = Browser.document.createSpanElement();
		//msg.appendChild(icon);
		//icon.className = "lint-error-icon";
		msg.appendChild(Browser.document.createTextNode(text));
		msg.className = "lint-error";
		widgets.push(CodeMirrorEditor.editor.addLineWidget(lineNumber, msg, {coverGutter: false, noHScroll: true}));
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
	}
}