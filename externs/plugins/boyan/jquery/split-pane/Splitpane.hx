package ;
import js.html.DivElement;

/**
 * ...
 * @author AS3Boyan
 */
extern class Splitpane
{
	public static var components:Array<DivElement>;
	
	public static function createSplitPane(fixedSide:String):DivElement;
	public static function createComponent():DivElement;
	public static function createDivider():DivElement;
}