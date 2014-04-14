package autoformat;

import haxe.io.Bytes;
import haxeprinter.Printer;
import hxparse.NoMatch;
import hxparse.Unexpected;
import js.Node;
import tjson.TJSON;

/**
 * ...
 * @author David Peek
 */
class HaxePrinter
{
	public static function formatSource(source:String)
	{
		var input = byte.ByteData.ofString(source);
		var parser = new haxeparser.HaxeParser(input, "");

		var ast = try {
			parser.parse();
		} catch(e:NoMatch<Dynamic>) {
			throw e.pos.format(input) + ": Unexpected " +e.token.tok;
		} catch(e:Unexpected<Dynamic>) {
			throw e.pos.format(input) + ": Unexpected " + e.token.tok;
		}

		var printer = new Printer();
		
		var options:NodeFsFileOptions = { };
		options.encoding = NodeC.UTF8;
		printer.config = TJSON.parse(Node.fs.readFileSync(Node.path.join("core", "config", "autoformat.json"), options));
		return printer.printAST(ast);
	}
}