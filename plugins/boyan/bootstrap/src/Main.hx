package ;
import haxe.Timer;
import js.Browser;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.UListElement;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		//We use overflow: hidden; to hide window scrollbars
		Browser.document.body.style.overflow = "hidden";
		
		//<!-- Bootstrap 3 -->
		//<script src="../plugins/boyan/bootstrap/bin/includes/js/bootstrap/bootstrap.min.js"></script>	
		
		//Bootstrap requires JQuery, so it will not start loading Boostrap until boyan.jquery plugin is loaded
		HIDE.waitForDependentPluginsToBeLoaded(["boyan.jquery"], loadBootstrap);
		
		//<link href="./includes/css/bootstrap.min.css" rel="stylesheet" media="screen">
		HIDE.loadCSS("../plugins/boyan/bootstrap/bin/includes/css/bootstrap.min.css");
		
		//<!-- Bootstrap 3 Glyphicons http://getbootstrap.com/components/#glyphicons -->
		//<link href="./includes/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">
		HIDE.loadCSS("../plugins/boyan/bootstrap/bin/includes/css/bootstrap-glyphicons.css");
	}
	
	public static function loadBootstrap():Void
	{
		HIDE.loadJS("../plugins/boyan/bootstrap/bin/includes/js/bootstrap/bootstrap.min.js", function ():Void
		{
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
			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves
			HIDE.plugins.push("boyan.bootstrap");
		}
		);
	}
}