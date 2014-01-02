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
			HIDE.loadCSS(name, [
			"bin/includes/codemirror-3.18/lib/codemirror.css", 
			"bin/includes/codemirror-3.18/addon/hint/show-hint.css",
			"bin/includes/codemirror-git/addon/dialog/dialog.css",
			"bin/includes/codemirror-git/addon/tern/tern.css",
			"bin/includes/css/editor.css"
			]);
			
			loadThemes([
			"3024-day",
			"3024-night",
			"ambiance",
			"base16-dark",
			"base16-light",
			"blackboard",
			"cobalt",
			"eclipse",
			"elegant",
			"erlang-dark",
			"lesser-dark",
			"midnight",
			"monokai",
			"neat",
			"night",
			"paraiso-dark",
			"paraiso-light",
			"rubyblue",
			"solarized",
			"the-matrix",
			"tomorrow-night-eighties",
			"twilight",
			"vibrant-ink",
			"xq-dark",
			"xq-light",
			]);
			
			var modes:Array<String> = [
			"haxe/haxe.js",
			"javascript/javascript.js",
			"css/css.js",
			"xml/xml.js",
			"htmlmixed/htmlmixed.js",
			"markdown/markdown.js",
			"shell/shell.js",
			"ocaml/ocaml.js",
			];
			
			for (i in 0...modes.length)
			{
				modes[i] = "bin/includes/codemirror-git/mode/" + modes[i];
			}
			
			HIDE.loadJS(name, [
			"bin/includes/codemirror-git/lib/codemirror.js",
			"bin/includes/codemirror/addon/hint/show-hint.js",
			"bin/includes/codemirror-git/addon/edit/matchbrackets.js",
			"bin/includes/codemirror-git/addon/edit/closebrackets.js",
			"bin/includes/codemirror-git/addon/comment/comment.js",
			"bin/includes/codemirror-git/addon/fold/foldcode.js",
			"bin/includes/codemirror-git/addon/fold/foldgutter.js",
			"bin/includes/codemirror-git/addon/fold/brace-fold.js",
			"bin/includes/codemirror-git/addon/fold/comment-fold.js",
			"bin/includes/codemirror-git/addon/selection/active-line.js",
			//CodeMirror addons for Tern
			"bin/includes/codemirror-git/addon/search/searchcursor.js",
			"bin/includes/codemirror-git/addon/search/search.js",
			"bin/includes/codemirror-git/addon/dialog/dialog.js",
			"bin/includes/codemirror-3.18/addon/tern/tern.js",
			].concat(modes), function ():Void
			{
				var textarea:TextAreaElement = Browser.document.createTextAreaElement();
				textarea.id = "code";
				
				Splitpane.components[1].appendChild(textarea);
				
				var editor:Dynamic = CodeMirror.fromTextArea(textarea, {
					lineNumbers: true,
					//extraKeys: keyMap,
					matchBrackets: true,
					dragDrop: false,
					autoCloseBrackets: true,
					foldGutter: {
						rangeFinder: untyped __js__("new CodeMirror.fold.combine(CodeMirror.fold.brace, CodeMirror.fold.comment)")
					},
					gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
					indentUnit:4,
					tabSize:4,
					mode:'haxe',
                 });
				 
				CM.editor = editor;
				TabManager.editor = CM.editor;
				 
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			}
			);
		}
		);
	}
	
	private static function loadThemes(themes:Array<String>):Void
	{
		for (theme in themes)
		{
			HIDE.loadCSS(name, ["bin/includes/codemirror-git/theme/" + theme + ".css"]);
		}
	}
	
}