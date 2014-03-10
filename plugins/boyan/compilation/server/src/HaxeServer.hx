package ;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeServer
{
	//private static var processStarted:Bool = true;
	private static var haxeCompletionServer:js.Node.NodeChildProcess;

	public static function start():Void
	{
		haxeCompletionServer = js.Node.childProcess.exec(["haxe", "--wait", "6001"].join(" "), { }, function (error, stdout, stderr)
		{
			trace(stdout);
			trace(stderr);
			//
			//if (error.code != 0)
			//{
				//processStarted = false;
			//}
			
			trace('haxeCompletionServer process exit code ' + error.code);
		}
		);		

		js.Node.require('nw.gui').Window.get().on("close", function (e):Void
		{
			haxeCompletionServer.kill();
		}
		);
	}
	
	public static function terminate():Void
	{
		//if (processStarted)
		//{
			//haxeCompletionServer.kill();
		//}
	}
}