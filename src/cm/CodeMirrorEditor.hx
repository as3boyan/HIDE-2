package cm;
import core.Completion;
import core.FunctionParametersHelper;
import core.HaxeParserProvider;
import haxe.Json;
import haxe.Timer;
import js.Browser;
import js.html.svg.TextElement;
import js.html.TextAreaElement;
import js.Lib;
import js.Node;
import menu.BootstrapMenu;
import tabmanager.TabManager;
import tjson.TJSON;

/**
 * ...
 * @author AS3Boyan
 */
class CodeMirrorEditor
{	
	public static var editor:CodeMirror;
	
	public static function load():Void
	{		
		var textarea:TextAreaElement = Browser.document.createTextAreaElement();
		textarea.id = "code";
		
		new jQuery.JQuery("#editor").append(textarea);
		
		var readFileOptions:NodeFsFileOptions = {};
		readFileOptions.encoding = NodeC.UTF8;
		
		var options:Dynamic = { };
		
		try 
		{
			options = TJSON.parse(Node.fs.readFileSync("editor.json", readFileOptions));
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
					untyped setTimeout(function() { triggerCompletion(cm); }, 100);
					untyped __js__("return CodeMirror.Pass");
				}
		}
		
		editor = CodeMirror.fromTextArea(textarea, options);
		 
		editor.getWrapperElement().style.display = "none";
		
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
		
		Node.fs.writeFileSync("bindings.txt", value, NodeC.UTF8);
		
		BootstrapMenu.getMenu("Help").addMenuItem("Show code editor key bindings", 2, TabManager.openFileInNewTab.bind("bindings.txt"));
		
		var timer:Timer = null;
		
		Browser.window.addEventListener("resize", function (e)
		{
			if (timer != null) 
			{
				timer.stop();
			}
			
			timer = new Timer(500);
			timer.run = function ()
			{
				editor.refresh();
				timer.stop();
			};
		}
		);
		
		editor.on("cursorActivity", function (cm:CodeMirror)
		{
			var extname:String = Node.path.extname(TabManager.getCurrentDocumentPath());
			
			if (extname == ".hx") 
			{
				var cursor = cm.getCursor();
				var data = cm.getLine(cursor.line);
				
				if (data.charAt(cursor.ch - 1) == "(") 
				{
					var pos = cursor.ch -1;
					var p = untyped __js__("CodeMirror.Pos");
					
					Completion.getCompletion(function ()
					{
						var found:Bool = false;
						
						for (completion in Completion.completions) 
						{
							if (Completion.curWord == completion.n) 
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
								
								FunctionParametersHelper.clear();
								FunctionParametersHelper.addWidget("function " + completion.n + info, editor.getCursor().line);
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
					, untyped p(cursor.line, pos));
				}
				else 
				{
					FunctionParametersHelper.clear();
				}
			}
		}
		);
		
		trace(editor);
		
		var timer:Timer = null;
		
		editor.on("change", function (cm:CodeMirror):Void 
		{			
			var extname:String = Node.path.extname(TabManager.getCurrentDocumentPath());
			
			if (extname == ".hx") 
			{
				if (timer != null) 
				{
					timer.stop();
					timer = null;
				}
				
				timer = new Timer(500);
				timer.run = function ():Void 
				{
					timer.stop();
					//HaxeParserProvider.getClassName();
                    CodeMirrorEditor.editor.setOption("lint", "true");
				};
			}
		}
		);
	}
	
	private static function triggerCompletion(cm:Dynamic) 
	{
		var extname:String = Node.path.extname(TabManager.getCurrentDocumentPath());
		
		switch (extname) 
		{
			case ".hx":
				HaxeParserProvider.getClassName();
		
				//TabManager.saveActiveFile(function ():Void 
				//{
					//Completion.getCompletion(function ()
					//{
						//cm.execCommand("autocomplete");
					//}
					//);
				//});
			default:
				trace(extname);
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