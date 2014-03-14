package ;
import js.Browser;
import js.html.svg.TextElement;
import js.html.TextAreaElement;
import js.Lib;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.codemirror.editor";
	public static var dependencies:Array<String> = ["boyan.jquery.layout", "boyan.window.splitpane"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{	
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, load, true);
	}
	
	private static function load():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, ["boyan.bootstrap.tab-manager", "boyan.bootstrap.menu"], function ():Void
		{
			HIDE.loadCSS(name, [
			"bin/includes/codemirror-3.22/lib/codemirror.css", 
			"bin/includes/codemirror-3.22/addon/hint/show-hint.css",
			"bin/includes/codemirror-3.22/addon/dialog/dialog.css",
			"bin/includes/codemirror-3.22/addon/tern/tern.css",
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
			], loadTheme);
			
			var modes:Array<String> = [
			"haxe/haxe.js",
			"javascript/javascript.js",
			"css/css.js",
			"xml/xml.js",
			"htmlmixed/htmlmixed.js",
			"markdown/markdown.js",
			"shell/shell.js",
			];
			
			for (i in 0...modes.length)
			{
				modes[i] = "bin/includes/codemirror-3.22/mode/" + modes[i];
			}
			
			HIDE.loadJS(name, [
			"bin/includes/codemirror-3.22/lib/codemirror.js",
			"bin/includes/codemirror/addon/hint/show-hint.js",
			"bin/includes/codemirror-3.22/addon/edit/matchbrackets.js",
			"bin/includes/codemirror-3.22/addon/edit/closebrackets.js",
			"bin/includes/codemirror-3.22/addon/comment/comment.js",
			"bin/includes/codemirror-3.22/addon/fold/foldcode.js",
			"bin/includes/codemirror-3.22/addon/fold/foldgutter.js",
			"bin/includes/codemirror-3.22/addon/fold/brace-fold.js",
			"bin/includes/codemirror-3.22/addon/fold/comment-fold.js",
			"bin/includes/codemirror-3.22/addon/selection/active-line.js",
			//CodeMirror addons for Tern
			"bin/includes/codemirror-3.22/addon/search/searchcursor.js",
			"bin/includes/codemirror-3.22/addon/search/search.js",
			"bin/includes/codemirror-3.22/addon/dialog/dialog.js",
			"bin/includes/codemirror-3.18/addon/tern/tern.js",
			"bin/includes/codemirror-3.22/addon/search/match-highlighter.js",
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
					indentUnit: 4,
					tabSize: 4,
					mode: 'haxe',
					lineWrapping: true,
					highlightSelectionMatches: untyped __js__("{ showToken: /\\w/}")
                 });
				 
				editor.getWrapperElement().style.display = "none";
				
				CM.editor = editor;
				TabManager.editor = CM.editor;
				 
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			}
			);
		}
		);
	}
	
	private static function loadTheme() 
	{
		var localStorage = Browser.getLocalStorage();
		
		if (localStorage != null)
		{
			var theme:String = localStorage.getItem("theme");
			
			if (theme != null) 
			{
				setTheme(theme);
			}
		}
		
	}
	
	private static function loadThemes(themes:Array<String>, onComplete:Dynamic):Void
	{
		var themesSubmenu = BootstrapMenu.getMenu("View").getSubmenu("Themes");
		var theme:String;
		
		var pathToThemeArray:Array<String> = new Array();
		
		themesSubmenu.addMenuItem("default", 0, setTheme.bind("default"));
		
		for (i in 0...themes.length)
		{
			theme = themes[i];
			pathToThemeArray.push("bin/includes/codemirror-3.22/theme/" + theme + ".css");
			themesSubmenu.addMenuItem(theme, i + 1, setTheme.bind(theme));
		}
		
		HIDE.loadCSS(name, pathToThemeArray, onComplete);
	}
	
	private static function setTheme(theme:String):Void
	{
		CM.editor.setOption("theme", theme);
		Browser.getLocalStorage().setItem("theme", theme);
	}
	
}