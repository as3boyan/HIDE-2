package ;
import haxe.ds.StringMap.StringMap;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.UListElement;
import ui.menu.basic.Menu;

/**
 * ...
 * @author AS3Boyan
 */

//@:expose makes this class available in global scope
//@:keepSub prevents -dce full from deleting unused functions, so they still can be used in other plugins
//more info about meta tags can be obtained at Haxe website: 
//http://haxe.org/manual/tips_and_tricks
@:keepSub @:expose class BootstrapMenu
{
	private static var menus:StringMap<Dynamic> = new StringMap();
	
	public static function createMenuBar():Void
	{
		//We use overflow: hidden; to hide window scrollbars
		Browser.document.body.style.overflow = "hidden";
		
		//<!-- Bootstrap 3 Navbar http://getbootstrap.com/components/#navbar -->
		//<div class="navbar navbar-default navbar-inverse navbar-fixed-top">
			//<!-- Menu header 'HIDE' -->
			//<div class="navbar-header">
				//<a class="navbar-brand" href="#">HIDE</a>
			//</div>
			//<div class="navbar-collapse collapse">
				//
				//<!-- A list which contains menus -->
				//<ul id="position-navbar" class="nav navbar-nav">
				//</ul>
				//
			//</div>
		//</div>
			
		var navbar:DivElement = Browser.document.createDivElement();
		navbar.className = "navbar navbar-default navbar-inverse navbar-fixed-top";
		
		var navbarHeader:DivElement = Browser.document.createDivElement();
		navbarHeader.className = "navbar-header";
		navbar.appendChild(navbarHeader);
		
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.className = "navbar-brand";
		a.href = "#";
		a.innerText = "HIDE";
			
		navbarHeader.appendChild(a);
			
		var div:DivElement = Browser.document.createDivElement();
		div.className = "navbar-collapse collapse";
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.id = "position-navbar";
		ul.className = "nav navbar-nav";
			
		div.appendChild(ul);
				
		navbar.appendChild(div);
		
		Browser.document.body.appendChild(navbar);
	}
	
	public static function getMenu(name:String):Menu
	{
		if (!menus.exists(name))
		{
			var menu:Menu = new Menu(name);
			menu.addToDocument();
			menus.set(name, menu);
		}
		
		return menus.get(name);
	}
}