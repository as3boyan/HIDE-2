package core;
import js.Node;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeServer
{
	static var haxeServer:NodeChildProcess;

	public static function check():Void
	{
		var socket = Node.net.connect(5000, "localhost");
		//socket.on("data", function (e)
		//{
			//trace(e.toString(NodeC.UTF8));
			//socket.destroy();
		//}
		//);
		socket.on("error", function (e)
		{
			trace("Haxe server is not found at localhost:5000");
		}
		);
		socket.on("close", function (e)
		{
			if (e) 
			{
				start();
			}
		}
		);
	}
	
	public static function start():Void
	{
		trace("Starting new Haxe server at localhost:5000");
		
		haxeServer = ProcessHelper.runPersistentProcess("haxe", ["--wait", "5000"], function (stdout:String, stderr:String):Void 
		{
			trace(stdout);
			trace(stderr);
		}
		);

		var window:Window = Window.get();
		
		window.on("close", function (e)
		{
			terminate();
			window.close(true);
		}
		);
	}
	
	public static function terminate():Void
	{
		if (haxeServer != null) 
		{
			haxeServer.kill();
		}
	}
}