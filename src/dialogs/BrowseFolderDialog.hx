package dialogs;
import bootstrap.ButtonManager;
import bootstrap.InputGroupButton;
import core.FileDialog;
import js.Browser;
import js.html.DivElement;
import js.html.InputElement;

/**
 * ...
 * @author AS3Boyan
 */
class BrowseFolderDialog extends ModalDialog
{
	var onComplete:String->Void;
	var input:InputElement;
	
	public function new(?title:String) 
	{
		super(title);
		
		var inputGroupButton = new InputGroupButton("Browse");
		
		input = inputGroupButton.getInput();
		
		var browseButton = inputGroupButton.getButton();
		
		browseButton.onclick = function (e):Void 
		{
			FileDialog.openFolder(function (path:String):Void 
			{
				input.value = path;
			}
			);
		};
		
		getBody().appendChild(inputGroupButton.getElement());
		
		var okButton = ButtonManager.createButton("OK", false, false, true);
		
		okButton.onclick = function (e):Void 
		{
			if (onComplete != null) 
			{
				onComplete(input.value);
			}
		};
		
		getFooter().appendChild(okButton);
		getFooter().appendChild(ButtonManager.createButton("Cancel", false, true));
	}
	
	public function setDefaultValue(_value:String)
	{
		input.value = _value;
	}
	
	public function setCallback(_onComplete:String->Void):Void
	{
		onComplete = _onComplete;
	}
}