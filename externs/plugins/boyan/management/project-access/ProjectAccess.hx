@:keepSub @:expose extern class ProjectAccess {
	static var currentProject : Project;
	public static function save(?onComplete:Dynamic):Void;
}
