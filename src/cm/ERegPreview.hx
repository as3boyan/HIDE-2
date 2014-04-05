package cm;

/**
 * ...
 * @author AS3Boyan
 */
class ERegPreview
{
	public static function update(cm:CodeMirror):Void 
	{
		var lineData = cm.getLine(cm.getCursor().line);
			
		var ereg:EReg = ~/~\/(.)+\/[gimsu]+/;
		
		var foundEreg:String = null;
		var foundEregOptions:String = null;
		
		if (ereg.match(lineData))
		{			
			var str = ereg.matched(0);
			str = StringTools.trim(str.substr(2, str.length - 2));
			var index = str.lastIndexOf("/");
			
			foundEreg = str.substr(0, index);
			foundEregOptions = str.substr(index + 1);
		}
		
		for (marker in cm.getAllMarks())
		{
			marker.clear();
		}
		
		if (foundEreg != null) 
		{
			var ereg = new EReg(foundEreg, foundEregOptions);
			ereg.map(cm.getValue(), function (matchedEreg:EReg):String 
			{
				var pos = cm.posFromIndex(matchedEreg.matchedPos().pos);
				var pos2 = cm.posFromIndex(matchedEreg.matchedPos().pos + matchedEreg.matchedPos().len);
				cm.markText(pos, pos2, {className: "showRegex"});
				return "";
			}
			);
		}
	}
}