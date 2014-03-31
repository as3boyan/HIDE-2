package dialogs;
import bootstrap.ButtonManager;
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
		
		var inputGroup = Browser.document.createDivElement();
		inputGroup.className = "input-group";
		
		input = Browser.document.createInputElement();
		input.type = "text";
		input.className = "form-control";
		inputGroup.appendChild(input);
		
		var span = Browser.document.createSpanElement();
		span.className = "input-group-btn";
		
		var browseButton = ButtonManager.createButton("Browse");
		span.appendChild(browseButton);
		
		browseButton.onclick = function (e):Void 
		{
			FileDialog.openFolder(function (path:String):Void 
			{
				input.value = path;
			}
			);
		};
		
		inputGroup.appendChild(span);
		
		getBody().appendChild(inputGroup);
		
		var okButton = ButtonManager.createButton("OK", false, false, true);
		
		okButton.onclick = function (e):Void 
		{
			if (onComplete != null) 
			{
				onComplete(input.value);
			}
			
			hide();
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