package ;
import js.Browser;
import js.html.svg.TextElement;
import js.html.TextAreaElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.codemirror.editor";
	public static var dependencies:Array<String> = ["boyan.jquery.layout", "boyan.bootstrap.tab-manager"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			HIDE.loadCSS(name, ["bin/includes/css/lib/codemirror.css", "bin/includes/css/editor.css"]);
			
			HIDE.loadJS(name, ["bin/includes/js/lib/codemirror.js"], function ():Void
			{
				var textarea:TextAreaElement = Browser.document.createTextAreaElement();
				textarea.id = "code";
				
				Splitpane.components[1].appendChild(textarea);
				
				var editor:Dynamic = CodeMirror.fromTextArea(textarea, {
                        lineNumbers: true,
                        //extraKeys: keyMap,
                        //matchBrackets: true,
                        dragDrop: false,
                        //autoCloseBrackets: true,
                        //foldGutter: {
                                //rangeFinder: untyped __js__("new CodeMirror.fold.combine(CodeMirror.fold.brace, CodeMirror.fold.comment)")
                        //},
                        //gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
                 });
				 
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			}
			);
		}
		);
	}
	
}