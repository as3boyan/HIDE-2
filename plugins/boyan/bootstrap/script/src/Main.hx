package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.bootstrap.script";
	public static var dependencies:Array<String> = ["boyan.jquery.script"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		//Bootstrap requires JQuery, so it will not start loading Boostrap until boyan.jquery plugin is loaded
		HIDE.waitForDependentPluginsToBeLoaded(dependencies, loadBootstrap);
		
		//<link href="./includes/css/bootstrap.min.css" rel="stylesheet" media="screen">
		HIDE.loadCSS(name, "bin/includes/css/bootstrap.min.css");
		
		//<!-- Bootstrap 3 Glyphicons http://getbootstrap.com/components/#glyphicons -->
		//<link href="./includes/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">
		HIDE.loadCSS(name, "bin/includes/css/bootstrap-glyphicons.css");
	}
	
	//This function gets called only when all dependent plugins loaded
	public static function loadBootstrap():Void
	{
		//<!-- Bootstrap 3 -->
		//<script src="../plugins/boyan/bootstrap/bin/includes/js/bootstrap/bootstrap.min.js"></script>	
		HIDE.loadJS(name, "bin/includes/js/bootstrap/bootstrap.min.js", function ():Void
		{			
			//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves
			HIDE.plugins.push(name);
		}
		);
	}
}