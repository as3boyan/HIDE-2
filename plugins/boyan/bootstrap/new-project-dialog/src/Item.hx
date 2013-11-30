package ;

/**
 * ...
 * @author AS3Boyan
 */
class Item
{
	public var name:String;
	public var showCreateDirectoryOption:Bool;
	public var nameLocked:Bool;

	public function new(_name:String, ?_showCreateDirectoryOption:Bool = true, ?_nameLocked:Bool = false) 
	{
		name = _name;
		showCreateDirectoryOption = _showCreateDirectoryOption;
		nameLocked = _nameLocked;
	}
	
}