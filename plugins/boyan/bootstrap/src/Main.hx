package ;
import js.Browser;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		//<!-- Bootstrap 3 -->
		//<script src="./includes/js/bootstrap/bootstrap.min.js"></script>	
		//<link href="./includes/css/bootstrap.min.css" rel="stylesheet" media="screen">
		
		//<!-- Bootstrap 3 Glyphicons http://getbootstrap.com/components/#glyphicons -->
		<//link href="./includes/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">
		
		//We use overflow: hidden; to hide window scrollbars
		Browser.document.body.style.overflow = "hidden";
		
		//<!-- Bootstrap 3 Navbar http://getbootstrap.com/components/#navbar -->
		//<div class="navbar navbar-default navbar-inverse navbar-fixed-top">
			//
			//<!-- Menu header 'HIDE' -->
			//<div class="navbar-header">
				//<a class="navbar-brand" href="#">HIDE</a>
			//</div>
			//
			//<div class="navbar-collapse collapse">
				//
				//<!-- A list which contains menus -->
				//<ul id="position-navbar" class="nav navbar-nav">
				//</ul>
				//
			//</div>
		//</div>
	}
	
}