package ui.menu.basic;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.Element;
import js.html.LIElement;
import js.html.LinkElement;
import js.html.MouseEvent;
import js.html.NodeList;
import js.html.SpanElement;
import js.html.UListElement;
import ui.menu.basic.Menu.MenuButtonItem;

/**
 * ...
 * @author AS3Boyan
 */

interface MenuItem
{
	public function getElement():Element;
}

//@:keepSub prevents -dce full from deleting unused functions, so they still can be used in other plugins
//alternatively you can just remove -dce full flag from plugin.hxml
//more info about meta tags can be obtained at Haxe website: 
//http://haxe.org/manual/tips_and_tricks
@:keepSub class MenuButtonItem implements MenuItem
{	
	var li:LIElement;
	public var position:Int;
	
	public function new(_text:String, _onClickFunction:Dynamic, ?_hotkey:String, ?_keyCode:Int, ?_ctrl:Bool, ?_shift:Bool, ?_alt:Bool)
	{		
		var span:SpanElement = null;
		
		if (_hotkey != null)
		{
			span = Browser.document.createSpanElement();
			span.style.color = "silver";
			span.style.float = "right";
			span.innerText = _hotkey;
		}
		
		li = Browser.document.createLIElement();		
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.style.left = "0";
		a.setAttribute("text", _text);
		
		if (_onClickFunction != null) 
		{
			a.onclick = function (e)
			{
				if (li.className != "disabled")
				{
					_onClickFunction();
				}
			};
			
			if (_hotkey != null && _keyCode != null)
			{
				Hotkeys.addHotkey(_keyCode, _ctrl, _shift, _alt, _onClickFunction);
			}
		}
		
		a.innerText = _text;
		
		if (span != null)
		{
			a.appendChild(span);
		}
		
		li.appendChild(a);
	}
	
	public function getElement():LIElement
	{
		return li;
	}
}

//@:keepSub prevents -dce full from deleting unused functions, so they still can be used in other plugins
@:keepSub class Separator implements MenuItem
{
	var li:LIElement;
	
	public function new()
	{
		li = Browser.document.createLIElement();
		li.className = "divider";
	}
	
	public function getElement():Element
	{
		return li;
	}
}
 
//@:expose makes this class available in global scope
//@:keepSub prevents -dce full from deleting unused functions, so they still can be used in other plugins
@:keepSub @:expose class Menu
{
	var li:LIElement;
	var ul:UListElement;
	var items:Array<MenuButtonItem>;
	public var position:Int;
	
	public function new(_text:String, ?_headerText:String) 
	{
		li = Browser.document.createLIElement();
		li.className = "dropdown";
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.href = "#";
		a.className = "dropdown-toggle";
		a.setAttribute("data-toggle", "dropdown");
		a.innerText = _text;
		li.appendChild(a);
		
		ul = Browser.document.createUListElement();
		ul.className = "dropdown-menu";
		ul.classList.add("dropdown-menu-form");
		
		if (_headerText != null)
		{
			var li_header:LIElement = Browser.document.createLIElement();
			li_header.className = "dropdown-header";
			li_header.innerText = _headerText;
			ul.appendChild(li_header);
		}
		
		li.appendChild(ul);
		
		items = new Array();
	}
	
	public function addMenuItem(_text:String, _position:Int, _onClickFunction:Dynamic, ?_hotkey:String, ?_keyCode:Int, ?_ctrl:Bool = false, ?_shift:Bool = false, ?_alt:Bool = false):Void
	{
		var menuButtonItem:MenuButtonItem = new MenuButtonItem(_text, _onClickFunction, _hotkey, _keyCode, _ctrl, _shift, _alt);
				
		menuButtonItem.position = _position;
		
		if (menuButtonItem.position != null && items.length > 0 && ul.childNodes.length > 0)
		{
			var currentMenuButtonItem:MenuButtonItem;

			var added:Bool = false;

			for (i in 0...items.length)
			{
				currentMenuButtonItem = items[i];

				if (currentMenuButtonItem != menuButtonItem && currentMenuButtonItem.position == null || menuButtonItem.position < currentMenuButtonItem.position)
				{
					ul.insertBefore(menuButtonItem.getElement(), currentMenuButtonItem.getElement());
					items.insert(i, menuButtonItem);
					added = true;
					break;
				}
			}

			if (!added)
			{
				ul.appendChild(menuButtonItem.getElement());
				items.push(menuButtonItem);
			}
		}
		else
		{
			ul.appendChild(menuButtonItem.getElement());
			items.push(menuButtonItem);
		}
	}
	
	public function addSeparator():Void
	{
		ul.appendChild(new Separator().getElement());
	}
	
	public function addToDocument():Void
	{	
		var div:Element = cast(Browser.document.getElementById("position-navbar"), Element);
		div.appendChild(li);
	}

	public function removeFromDocument():Void
	{
		li.remove();
	}

	public function setPosition(_position:Int):Void
	{
		position = _position;
	}
	
	public function setDisabled(menuItemNames:Array<String>):Void
	{
		var childNodes:NodeList = ul.childNodes;
		
		for (i in 0...childNodes.length)
		{
			var child:Element = cast(childNodes[i], Element);
			
			if (child.className != "divider")
			{				
				var a:AnchorElement = cast(child.firstChild, AnchorElement);
								
				if (Lambda.indexOf(menuItemNames, a.getAttribute("text")) == -1)
				{
					child.className = "";
				}
				else
				{
					child.className = "disabled";
				}
			}
		}
	}
	
	public function setMenuEnabled(enabled:Bool):Void
	{
		var childNodes:NodeList = ul.childNodes;
		
		for (i in 0...childNodes.length)
		{
			var child:Element = cast(childNodes[i], Element);
			
			if (child.className != "divider")
			{
				if (enabled)
				{
					child.className = "";
				}
				else
				{
					child.className = "disabled";
				}
			}
			
		}
	}
	
	public function getElement():Element
	{
		return li;
	}
}