package core;
import js.Node;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class NekoToolsServer
{
	static var nekoToolsClient:NodeChildProcess;
	
	public static function start(path:String):Void
	{
		if (nekoToolsClient != null)
		{
			nekoToolsClient.kill();
			nekoToolsClient = null;
		}
		
		nekoToolsClient = ProcessHelper.runPersistentProcess("nekotools", ["server", "-p", "8000", "-d", path]);
	}
}