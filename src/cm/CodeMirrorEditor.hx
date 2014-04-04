package cm;
import core.Completion;
import core.FunctionParametersHelper;
import core.HaxeLint;
import core.HaxeParserProvider;
import core.Helper;
import haxe.Json;
import haxe.Timer;
import jQuery.JQuery;
import js.Browser;
import js.html.DivElement;
import js.html.svg.TextElement;
import js.html.TextAreaElement;
import js.Lib;
import js.Node;
import menu.BootstrapMenu;
import projectaccess.ProjectAccess;
import tabmanager.TabManager;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
class CodeMirrorEditor
{	
	public static var editor:CodeMirror;
	public static var regenerateCompletionOnDot:Bool;
	
	public static function load():Void
	{		
		regenerateCompletionOnDot = true;
		
		var readFileOptions:NodeFsFileOptions = {};
		readFileOptions.encoding = NodeC.UTF8;
		
		var options:Dynamic = { };
		
		try 
		{
			options = TJSON.parse(Node.fs.readFileSync(Node.path.join("config","editor.json"), readFileOptions));
		}
		catch (err:Error)
		{
			trace(err);
		}
		
		walk(options);
		
		options.extraKeys = 
		{
			"Ctrl-Space": triggerCompletion,
			"Ctrl-Q": "toggleComment",
			"." : 
				function passAndHint(cm) 
				{
					untyped setTimeout(function() { triggerCompletion(cm, true); }, 100);
					untyped __js__("return CodeMirror.Pass");
				}
		}
		
		editor = CodeMirror.fromTextArea(Browser.document.getElementById("code"), options);
		
		new JQuery("#editor").hide();
		
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
		
		var value:String = "";
		var map = CodeMirror.keyMap.sublime;
		var mapK = untyped CodeMirror.keyMap["sublime-Ctrl-K"];
		
		  for (key in Reflect.fields(map)) 
		  {
			  //&& !/find/.test(map[key])
			if (key != "Ctrl-K" && key != "fallthrough")
			{
				value += "  \"" + key + "\": \"" + Reflect.field(map, key) + "\",\n";
			}
			  
		  }
		  for (key in Reflect.fields(mapK)) 
		  {
			if (key != "auto" && key != "nofallthrough")
			{
				value += "  \"Ctrl-K " + key + "\": \"" + Reflect.field(mapK, key) + "\",\n";
			}
			  
		  }
		
		trace(CodeMirrorEditor.editor);
		  
		Node.fs.writeFileSync("bindings.txt", value, NodeC.UTF8);
		
		Browser.window.addEventListener("resize", function (e)
		{
			Helper.debounce("resize", function ():Void 
			{
				editor.refresh();
			}, 100);
			
			resize();
		}
		);
		
		new JQuery('#thirdNested').on('resize', 
		function (event) {       
			var panels = event.args.panels;
			
			resize();
		});
		
		ColorPreview.create(editor);
		
		editor.on("cursorActivity", function (cm:CodeMirror)
		{
			Helper.debounce("cursorActivity", FunctionParametersHelper.update.bind(cm), 100);
			
			ColorPreview.update(editor);
		}
		);
		
		editor.on("scroll", function (cm:CodeMirror):Void 
		{
			ColorPreview.scroll(editor);
		}
		);
		
		var timer:Timer = null;
		
		var basicTypes = ["Array", "Map", "StringMap"];
		
		editor.on("change", function (cm:CodeMirror):Void 
		{			
			var extname:String = Node.path.extname(TabManager.getCurrentDocumentPath());
			
			if (extname == ".hx") 
			{
				Helper.debounce("change", function ():Void 
				{
					HaxeParserProvider.getClassName();
					HaxeLint.updateLinting();
				}, 100);
				
				var cursor = cm.getCursor();
				var data = cm.getLine(cursor.line);
				
				if (data.charAt(cursor.ch - 1) == ":") 
				{
					if (data.charAt(cursor.ch - 2) == "@")
					{
						Completion.showMetaTagsCompletion();
					}
					else 
					{
						Completion.showClassList();
					}
				}
				else if (data.charAt(cursor.ch - 1) == "<")
				{
					for (type in basicTypes) 
					{
						if (StringTools.endsWith(data.substr(0, cursor.ch - 1), type)) 
						{
							Completion.showClassList();
							break;
						}
					}
				}
				else if (StringTools.endsWith(data, "import ")) 
				{
					Completion.showClassList(true);
				}
			}
			else if (extname == ".hxml") 
			{
				var cursor = cm.getCursor();
				var data = cm.getLine(cursor.line);
				
				if (data.charAt(cursor.ch - 1) == "-")
				{
					Completion.showHxmlCompletion();
				}
			}
			
			TabManager.tabMap.get(TabManager.selectedPath).setChanged(true);
		}
		);
		
		//var timer = new Timer(100);
		//timer.run = CodeMirrorEditor.editor.setOption.bind("lint", true);
		
		CodeMirror.prototype.centerOnLine = function(line) 
		{
			untyped __js__(" var h = this.getScrollInfo().clientHeight;  var coords = this.charCoords({line: line, ch: 0}, 'local'); this.scrollTo(null, (coords.top + coords.bottom - h) / 2); ");
		};
	}
	
	private static function triggerCompletion(cm:CodeMirror, ?dot:Bool = false) 
	{
		var extname:String = Node.path.extname(TabManager.getCurrentDocumentPath());
		
		switch (extname) 
		{
			case ".hx":
				//HaxeParserProvider.getClassName();
				
				if (!dot || regenerateCompletionOnDot || (dot && !cm.state.completionActive)) 
				{
					TabManager.saveActiveFile(function ():Void 
					{
						Completion.getCompletion(Completion.showRegularCompletion);
					});
				}
			case ".hxml":
				Completion.showHxmlCompletion();
			default:
				
		}
	}
	
	private static function walk(object:Dynamic)
	{		
		var regexp = untyped __js__("RegExp");
		
		for (field in Reflect.fields(object))
		{
			var value = Reflect.field(object, field);
			
			if (Std.is(value, String)) 
			{
				if (StringTools.startsWith(value, "regexp")) 
				{
					try
					{
						Reflect.setField(object, field, Type.createInstance(regexp, [value.substring(6)]));
					}
					catch (err:Error)
					{
						trace(err);
					}
				}
				else if (StringTools.startsWith(value, "eval")) 
				{
					try 
					{
						Reflect.setField(object, field, Lib.eval(value.substring(4)));
					}
					catch (err:Error)
					{
						trace(err);
					}
				}
				
			}

			if (Reflect.isObject(value) && !Std.is(value, Array) && Type.typeof(value).getName() == "TObject") 
			{
				walk(value);
			}
		}
	}
	
	public static function resize():Void 
	{
		var height = Browser.window.innerHeight - 50 - new JQuery("ul.tabs").height() - new JQuery("#tabs1").height() - 5;
		new JQuery(".CodeMirror").css("height", Std.string(Std.int(height)) + "px");
	}
	
	private static function loadTheme() 
	{
		var localStorage2 = Browser.getLocalStorage();
		
		if (localStorage2 != null)
		{
			var theme:String = localStorage2.getItem("theme");
			
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
			themesSubmenu.addMenuItem(theme, i + 1, setTheme.bind(theme));
		}
		
		onComplete();
	}
	
	private static function setTheme(theme:String):Void
	{
		editor.setOption("theme", theme);
		Browser.getLocalStorage().setItem("theme", theme);
	}
}