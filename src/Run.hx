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
		Sys.command("haxelib", ["run", "node-webkit", "bin"]);
	}
}