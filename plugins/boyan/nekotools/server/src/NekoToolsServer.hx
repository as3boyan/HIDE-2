package ;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class NekoToolsServer
{
	private static var nekoToolsClient:js.Node.NodeChildProcess;
	
	public static function start():Void
	{
		if (nekoToolsClient != null)
		{
			nekoToolsClient.kill();
			nekoToolsClient = null;
		}
		
		nekoToolsClient = js.Node.child_process.spawn("nekotools", ["server", "-p", "8000"]);
		
		nekoToolsClient.stdout.setEncoding('utf8');
		nekoToolsClient.stdout.on('data', function (data) 
		{
			var str:String = data.toString();
			trace(str);
		}
		);
		
		nekoToolsClient.stderr.setEncoding('utf8');
		nekoToolsClient.stderr.on('data', function (data) 
		{
			var str:String = data.toString();
			trace(str);
		}
		);
		
		nekoToolsClient.on('close', function (code:Int) 
		{		
			if (code == 0)
			{
				trace("Neko Tools Server closed");
			}
			else
			{
				trace('Neko Tools Server process exit code ' + Std.string(code));
			}
		}
		);
	}
}