package ;

/**
 * ...
 * @author AS3Boyan
 */
@:keepSub @:expose class Item
{
	public var name:String;
	public var showCreateDirectoryOption:Bool;
	public var nameLocked:Bool;
	public var createProjectFunction:Dynamic;

	public function new(_name:String, ?_createProjectFunction:Dynamic, ?_showCreateDirectoryOption:Bool = true, ?_nameLocked:Bool = false) 
	{
		name = _name;
		showCreateDirectoryOption = _showCreateDirectoryOption;
		nameLocked = _nameLocked;
		createProjectFunction = _createProjectFunction;
	}
	
}