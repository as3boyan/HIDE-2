package ;

/**
 * ...
 * @author AS3Boyan
 */
class Main
{
	public static var name:String = "boyan.tern.server";
	public static var dependencies:Array<String> = ["boyan.codemirror.editor"];
	
	//If this plugin is selected as active in HIDE, then HIDE will call this function once on load	
	public static function main():Void
	{
		HIDE.waitForDependentPluginsToBeLoaded(name, dependencies, function ():Void
		{
			HIDE.loadJS(name, [
			"bin/includes/acorn/acorn.js",
			"bin/includes/acorn/acorn_loose.js",
			"bin/includes/acorn/util/walk.js",
			"bin/includes/tern/doc/demo/polyfill.js",
			"bin/includes/tern/lib/signal.js",
			"bin/includes/tern/lib/tern.js",
			"bin/includes/tern/lib/def.js",
			"bin/includes/tern/lib/comment.js",
			"bin/includes/tern/lib/infer.js",
			"bin/includes/tern/plugin/doc_comment.js",
			], function ():Void
			{
				//Notify HIDE that plugin is ready for use, so plugins that depend on this plugin can start load themselves		
				HIDE.notifyLoadingComplete(name);
			}
			);
		}
		);
		
		
	}
	
}