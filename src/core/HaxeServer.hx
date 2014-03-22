package core;
import js.Node;
import nodejs.webkit.Window;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeServer
{
	private static var haxeCompletionServer:js.Node.NodeChildProcess;
	private static var processStarted:Bool = true;

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
			trace(e);
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
		haxeCompletionServer = js.Node.child_process.exec(["haxe", "--wait", "5000"].join(" "), { }, function (error, stdout, stderr)
		{
			trace(stdout);
			trace(stderr);
			
			if (error.code != 0)
			{
				processStarted = false;
			}
			
			trace('haxeCompletionServer process exit code ' + error.code);
		}
		);		

		var window:Window = Window.get();
		
		window.on("close", function (e)
		{
			if (processStarted) 
			{
				haxeCompletionServer.kill('SIGKILL');
			}
		}
		);
	}
}