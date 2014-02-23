package ;

/**
 * ...
 * @author AS3Boyan
 */

//Neko script for haxelib
//Compiles to run.n

class Run
{
	public static function main()
	{
		var output = new sys.io.Process("haxelib", ["path", "HIDE"]).stdout.readAll().toString();
		Sys.command("haxelib", ["run", "node-webkit", output.split("\n")[0] + "/bin" ]);
	}
}
