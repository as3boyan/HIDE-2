package ;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class HaxeServer
{
	private static var processStarted:Bool = true;
	private static var haxeCompletionServer:js.Node.NodeChildProcess;

	public static function start():Void
	{
		haxeCompletionServer = js.Node.require('child_process').spawn("haxe", ["--wait", "6001"]);
		
		haxeCompletionServer.stdout.setEncoding('utf8');
		haxeCompletionServer.stdout.on('data', function (data) {
		trace("stdout: " + data); } );
		
		haxeCompletionServer.stderr.setEncoding('utf8');
		haxeCompletionServer.stderr.on('data', function (data) {
				var str:String = data.toString();
				var lines = str.split("\n");
				trace("ERROR: " + lines.join(""));
				processStarted = false;
		});
		
		haxeCompletionServer.on('close', function (code) {
				trace('haxeCompletionServer process exit code ' + code);
		});

		js.Node.require('nw.gui').Window.get().on("close", function (e):Void
		{
			terminate();
		}
		);
	}
	
	public static function terminate():Void
	{
		if (processStarted)
		{
			haxeCompletionServer.kill();
		}
	}
}