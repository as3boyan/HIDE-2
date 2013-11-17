package ;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */

@:keepSub @:expose class BootstrapMenu
{
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
}