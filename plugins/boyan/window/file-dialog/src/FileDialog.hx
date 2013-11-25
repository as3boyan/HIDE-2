package ;
import js.Browser;
import js.html.InputElement;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class FileDialog
{
	private static var input:InputElement;
	private static var onClick:Dynamic;
	
	public static function create():Void
	{
		input = Browser.document.createInputElement();
		input.type = "file";
		input.style.display = "none";
		input.addEventListener("change", function(e) 
		{
			var value:String = input.value;
			if (value != "") 
			{
				onClick(value);
			}
		});
		
		Browser.document.body.appendChild(input);
	}
	
	public static function openFile(_onClick:Dynamic):Void
	{
		input.value = "";
		
		onClick = _onClick;
		
		if (input.hasAttribute("nwsaveas"))
		{
			input.removeAttribute("nwsaveas");
		}
		
		if (input.hasAttribute("nwdirectory"))
		{
			input.removeAttribute("nwdirectory");
		}
		
		input.click();
	}
	
	public static function saveFile(_onClick:Dynamic, ?_name:String):Void
	{
		input.value = "";
		
		onClick = _onClick;
		
		if (_name == null)
		{
			_name = "";
		}
		
		if (input.hasAttribute("nwdirectory"))
		{
			input.removeAttribute("nwdirectory");
		}
		
		input.setAttribute("nwsaveas", _name);
		input.click();
	}
	
	public static function openFolder(_onClick:Dynamic):Void
	{
		input.value = "";
		
		onClick = _onClick;
		
		if (input.hasAttribute("nwsaveas"))
		{
			input.removeAttribute("nwsaveas");
		}
		
		input.setAttribute("nwdirectory", "");
		input.click();
	}
	
}