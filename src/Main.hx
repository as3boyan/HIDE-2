package ;

import jQuery.JQuery;
import jQuery.JQueryStatic;
import js.Browser;
import js.html.KeyboardEvent;
import js.html.LinkElement;
import js.Lib;

/**
 * ...
 * @author AS3Boyan
 */

class Main 
{
	
	static function main() 
	{
		js.Node.require('nw.gui').Window.get().showDevTools();
		
		Browser.window.onload = function (e)
		{
			js.Node.require('nw.gui').Window.get().show();	
		};
	}
	
}